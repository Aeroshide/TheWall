; A Wall-Style Multi-Instance macro for Minecraft
; By Specnr
; v0.8

#NoEnv
#SingleInstance Force
#Include %A_ScriptDir%\scripts\functions.ahk
#Include settings.ahk

SetKeyDelay, 0
SetWinDelay, 1
SetTitleMatchMode, 2

; Don't configure these
global McDirectories := []
global instances := 0
global hwnds := []
global rawPIDs := []
global PIDs := []
global RM_PIDs := []
global locked := []
global needBgCheck := False
global currBg := GetFirstBgInstance()
global lastChecked := A_NowUTC
global resetKeys := []
global lpKeys := []
global fsKeys := []
global resets := 0
global f1States := []

EnvGet, threadCount, NUMBER_OF_PROCESSORS
global playThreads := playThreadsOverride > 0 ? playThreadsOverride : threadCount ; playThreads = threadCount unless override
global highThreads := highThreadsOverride > 0 ? highThreadsOverride : threadCount ; highThreads = 100% threadCount unless N or override
global lockThreads := lockThreadsOverride > 0 ? lockThreadsOverride : Floor(threadCount * 0.9) ; highThreads ; lockThreads = 80% threadCount if advanced, otherwise highThreads unless override
global midThreads := midThreadsOverride > 0 ? midThreadsOverride : Floor(threadCount * 0.9) ; midThreads = 80% threadCount if advanced, otherwise highThreads unless override
global lowThreads := lowThreadsOverride > 0 ? lowThreadsOverride : Ceil(threadCount * 0.2) ; lowThreads = 20% threadCount unless N or override
global superLowThreads := superLowThreadsOverride > 0 ? superLowThreadsOverride : Ceil(threadCount * 0.1) ; superLowThreads = 10% threadCount unless N or override

global playBitMask := GetBitMask(playThreads)
global lockBitMask := GetBitMask(lockThreads)
global highBitMask := GetBitMask(highThreads)
global midBitMask := GetBitMask(midThreads)
global lowBitMask := GetBitMask(lowThreads)
global superLowBitMask := GetBitMask(superLowThreads)

global instWidth := Floor(A_ScreenWidth / cols)
global instHeight := Floor(A_ScreenHeight / rows)
if (widthMultiplier)
  global newHeight := Floor(A_ScreenHeight / widthMultiplier)
global isWide := False

global MSG_RESET := 0x04E20
global LOG_LEVEL_INFO = "INFO"
global LOG_LEVEL_WARNING = "WARN"
global LOG_LEVEL_ERROR = "ERR"
global obsFile := A_ScriptDir . "/scripts/obs.ops"

if !FileExist("data")
  FileCreateDir, data
global hasMcDirCache := FileExist("data/mcdirs.txt")

FileDelete, %obsFile%
FileDelete, data/log.log
FileDelete, %dailyAttemptsFile%

SendLog(LOG_LEVEL_INFO, "Wall launched")

GetAllPIDs()

for i, mcdir in McDirectories {
  pid := PIDs[i]
  logs := mcdir . "logs\latest.log"
  idle := mcdir . "idle.tmp"
  hold := mcdir . "hold.tmp"
  preview := mcdir . "preview.tmp"
  lock := mcdir . "lock.tmp"
  kill := mcdir . "kill.tmp"
  VerifyInstance(mcdir, pid, i)
  resetKey := resetKeys[i]
  lpKey := lpKeys[i]
  SendLog(LOG_LEVEL_INFO, Format("Running a reset manager: {1} {2} {3} {4} {5} {6} {7} {8} {9} {10} {11} {12} {13} {14} {15}", pid, logs, idle, hold, preview, lock, kill, resetKey, lpKey, i, highBitMask, midBitMask, lowBitMask, superLowBitMask, lockBitMask))
  Run, "%A_ScriptDir%\scripts\reset.ahk" %pid% "%logs%" "%idle%" "%hold%" "%preview%" "%lock%" "%kill%" %resetKey% %lpKey% %i% %highBitMask% %midBitMask% %lowBitMask% %superLowBitMask% %lockBitMask%, %A_ScriptDir%,, rmpid
  DetectHiddenWindows, On
  WinWait, ahk_pid %rmpid%
  DetectHiddenWindows, Off
  RM_PIDs[i] := rmpid
  lockDest := mcdir . "lock.png"
  if (!FileExist(lockDest)) {
    FileCopy, %A_ScriptDir%\media\unlock.png, %lockDest%, 1
  }
  UnlockInstance(i, False)
  if (!FileExist(idle))
    FileAppend, %A_TickCount%, %idle%
  if FileExist(hold)
    FileDelete, %hold%
  if FileExist(kill)
    FileDelete, %kill%
  if FileExist(preview)
    FileDelete, %preview%
  WinGetTitle, winTitle, ahk_pid %pid%
  if !InStr(winTitle, " - ") {
    ControlClick, x0 y0, ahk_pid %pid%,, RIGHT
    ControlSend,, {Blind}{Esc}, ahk_pid %pid%
    WinMinimize, ahk_pid %pid%
    WinRestore, ahk_pid %pid%
  }
  if (windowMode == "B") {
    WinSet, Style, -0xC40000, ahk_pid %pid%
  } else {
    WinSet, Style, +0xC40000, ahk_pid %pid%
  }
  if (widthMultiplier) {
    pid := PIDs[i]
    WinRestore, ahk_pid %pid%
    WinMove, ahk_pid %pid%,,0,0,%A_ScreenWidth%,%newHeight%
  } else {
    WinMaximize, ahk_pid %pid%
  }
  WinSet, AlwaysOnTop, Off, ahk_pid %pid%
  SendLog(LOG_LEVEL_INFO, Format("Instance {1} ready for resetting", i))
}

SetTitles()

for i, tmppid in PIDs {
  SetAffinity(tmppid, highBitMask)
}

if audioGui {
  Gui, New
  Gui, Show,, The Wall Audio
}

if (useObsWebsocket) {
  WinWait, OBS
  if (useSingleSceneOBS) {
    lastInst := -1
    if FileExist("data/instance.txt")
      FileRead, lastInst, data/instance.txt
    SendOBSCmd("ss-tw" . " " .lastInst)
    cmd := "python.exe """ . A_ScriptDir . "\scripts\obsListener.py"" " . instances . " " . "True"
  }
  else {
    SendOBSCmd("tw")
    cmd := "python.exe """ . A_ScriptDir . "\scripts\obsListener.py"" " . instances . " " . "False"
  }
  Run, %cmd%,, Hide
}

if (SubStr(RunHide("python.exe --version"), 1, 6) == "Python")
  Menu, Tray, Add, Delete Worlds, WorldBop
else
  SendLog(LOG_LEVEL_WARNING, "Missing Python installation. No Delete Worlds option added to tray")

Menu, Tray, Add, End Session, CloseInstances

SendOBSCmd("Reload")

SendLog(LOG_LEVEL_INFO, "Wall setup done")
if (!disableTTS)
  ComObjCreate("SAPI.SpVoice").Speak("Ready")

#Persistent
OnExit, ExitSub
SetTimer, CheckScripts, 20
return

ExitSub:
  if A_ExitReason not in Logoff,Shutdown
  {
    SendOBSCmd("xx")
    DetectHiddenWindows, On
    rms := RM_PIDs.MaxIndex()
    loop, %rms% {
      pid := RM_PIDs[A_Index]
      WinClose, ahk_pid %pid%
    }
    DetectHiddenWindows, Off
  }
ExitApp

CheckScripts:
  Critical
  if (useSingleSceneOBS && needBgCheck && A_NowUTC - lastChecked > tinderCheckBuffer) {
    newBg := GetFirstBgInstance()
    if (newBg != -1) {
      SendLog(LOG_LEVEL_INFO, Format("Instance {1} was found and will be used with tinder", newBg))
      SendOBSCmd("tm -1" . " " . newBg)
      needBgCheck := False
      currBg := newBg
    }
    lastChecked := A_NowUTC
  }
  if resets
    CountAttempts()
return

#Include hotkeys.ahk
