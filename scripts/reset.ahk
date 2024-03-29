; v0.8

#NoEnv
#NoTrayIcon
#Include settings.ahk
#Include %A_ScriptDir%\functions.ahk
#SingleInstance, off

SetKeyDelay, 0

global MSG_RESET := 0x04E20
global LOG_LEVEL_INFO = "INFO"
global LOG_LEVEL_WARNING = "WARN"
global LOG_LEVEL_ERROR = "ERR"

global pid := A_Args[1]
global logFile := A_Args[2]
global idleFile := A_Args[3]
global holdFile := A_Args[4]
global previewFile := A_Args[5]
global lockFile := A_Args[6]
global killFile := A_Args[7]
global resetKey := A_Args[8]
global lpKey := A_Args[9]
global idx := A_Args[10]
global highBitMask := A_Args[11]
global midBitMask := A_Args[12]
global lowBitMask := A_Args[13]
global superLowBitMask := A_Args[14]

global state := "unknown"
global lastImportantLine := GetLineCount(logFile)

SendLog(LOG_LEVEL_INFO, Format("Instance {1} reset manager started: {2} {3} {4} {5} {6} {7} {8} {9} {10} {11} {12} {13} {14} {15}", idx, pid, logFile, idleFile, holdFile, previewFile, lockFile, killFile, resetKey, lpKey, highBitMask, midBitMask, lowBitMask, superLowBitMask))

OnMessage(MSG_RESET, "Reset")

Reset() {
  if ((state == "resetting" && mode != "C") || state == "kill" || FileExist(killFile)) {
    FileDelete, %holdFile%
    NewSendLog(LOG_LEVEL_INFO, Format("Instance {1} discarding reset management, state: {2}", idx, state), A_TickCount)
    return
  }
  state := "kill"
  FileAppend,, %holdFile%
  FileDelete, %previewFile%
  FileDelete, %idleFile%
  lastImportantLine := GetLineCount(logFile)
  SetTimer, ManageReset, -%manageResetAfter%
  if (resetSounds || obsResetMediaKey) {
    SoundPlay, A_ScriptDir\..\media\reset.wav
    sleep, %obsDelay%
  }
}

ManageReset() {
  start := A_TickCount
  state := "resetting"
  SendLog(LOG_LEVEL_INFO, Format("Instance {1} starting reset management", idx))
  while (True) {
    if (state == "kill" || FileExist(killFile)) {
      SendLog(LOG_LEVEL_INFO, Format("Instance {1} killing reset management from loop", idx))
      FileDelete, %killFile%
      return
    }
    sleep, %resetManagementLoopDelay%
    Loop, Read, %logFile%
    {
      if (A_Index <= lastImportantLine)
        Continue
      if (state == "resetting" && InStr(A_LoopReadLine, "Starting Preview")) {
        ControlSend,, {Blind}{F3 Down}{Esc}{F3 Up}, ahk_pid %pid%
        state := "preview"
        SetTimer, LowerPreviewAffinity, -%loadBurstLength%
        lastImportantLine := GetLineCount(logFile)
        FileDelete, %holdFile%
        FileDelete, %previewFile%
        FileAppend, %A_TickCount%, %previewFile%
        SendLog(LOG_LEVEL_INFO, Format("Instance {1} found preview on log line: {2}", idx, A_Index))
        Continue 2
      } else if (state != "idle" && InStr(A_LoopReadLine, "Loaded 0 advancements")) {
        ControlSend,, {Blind}{F3 Down}{Esc}{F3 Up}, ahk_pid %pid%
        lastImportantLine := GetLineCount(logFile)
        SetTimer, LowerLoadedAffinity, -%loadBurstLength%
        FileDelete, %holdFile%
        if !FileExist(previewFile)
          FileAppend, %A_TickCount%, %previewFile%
        FileAppend,, %idleFile%
        if (state == "resetting") {
          SendLog(LOG_LEVEL_INFO, Format("Instance {1} line dump: {2}", idx, A_LoopReadLine))
          SendLog(LOG_LEVEL_WARNING, Format("Instance {1} found save while looking for preview, restarting reset management. (No World Preview/resetting too fast/lag)", idx))
          state := "unknown"
          Reset()
        } else {
          SendLog(LOG_LEVEL_INFO, Format("Instance {1} found save on log line: {2}", idx, A_Index))
          state := "idle"
        }
        return
      }
    }
    if (resetManagementTimeout > 0 && A_TickCount - start > (resetManagementTimeout * 1000)) {
      SendLog(LOG_LEVEL_ERROR, Format("Instance {1} {2} seconds timeout reached, ending reset management. May have left instance unpaused. (Lag/resetting too fast)", idx, resetManagementTimeout))
      state := "unknown"
      lastImportantLine := GetLineCount(logFile)
      FileDelete, %holdFile%
      FileAppend,, %previewFile%
      FileAppend,, %idleFile%
      return
    }
  }
}

LowerPreviewAffinity() {
  if FileExist("data/instance.txt")
    FileRead, activeInstance, data/instance.txt
  if activeInstance
    SetAffinity(pid, lowBitMask)
  else
    SetAffinity(pid, midBitMask)
}

LowerLoadedAffinity() {
  if FileExist("data/instance.txt")
    FileRead, activeInstance, data/instance.txt
  if (activeInstance == idx)
    SetAffinity(pid, playBitMask)
  else if (!activeInstance)
    SetAffinity(pid, lowBitMask)
  Else
    SetAffinity(pid, highBitMask)
}