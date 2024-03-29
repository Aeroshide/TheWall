; v0.8
return
#If WinActive("Minecraft") && (WinActive("ahk_exe javaw.exe") || WinActive("ahk_exe java.exe"))
{
  *End:: ExitWorld() ; Reset
  *Del:: PlayNextLock()
  ; Utility (Remove semicolon ';' and set a hotkey)
  ; ::WideHardo()
  ; ::OpenToLAN()
  ; ::GoToNether()
  ; ::OpenToLANAndGoToNether()
  ; ::CheckFourQuadrants("fortress")
  ; ::CheckFourQuadrants("bastion_remnant")
  ; ::CheckFor("buried_treasure")
}
return

#If WinActive("Fullscreen Projector") || WinActive("Full-screen Projector") || WinActive("Windowed Projector")
  {
    *Q::ResetInstance(MousePosToInstNumber())
    *W::SwitchInstance(MousePosToInstNumber())
    *E::FocusReset(MousePosToInstNumber())
    *R::ResetAll()
    F::Locking(MousePosToInstNumber())
    *D::ResetOverride(MousePosToInstNumber())
    

    ; Reset keys (1-9)
    *1::
      ResetInstance(1)
    return
    *2::
      ResetInstance(2)
    return
    *3::
      ResetInstance(3)
    return
    *4::
      ResetInstance(4)
    return
    *5::
      ResetInstance(5)
    return
    *6::
      ResetInstance(6)
    return
    *7::
      ResetInstance(7)
    return
    *8::
      ResetInstance(8)
    return
    *9::
      ResetInstance(9)
    return

    ; Switch to instance keys (Shift + 1-9)
    *+1::
      SwitchInstance(1)
    return
    *+2::
      SwitchInstance(2)
    return
    *+3::
      SwitchInstance(3)
    return
    *+4::
      SwitchInstance(4)
    return
    *+5::
      SwitchInstance(5)
    return
    *+6::
      SwitchInstance(6)
    return
    *+7::
      SwitchInstance(7)
    return
    *+8::
      SwitchInstance(8)
    return
    *+9::
      SwitchInstance(9)
    return

    ; Locking instance keys (Ctrl + 1-9)
    *^1::
      Locking(1)
    return
    *^2::
      Locking(2)
    return
    *^3::
      Locking(3)
    return
    *^4::
      Locking(4)
    return
    *^5::
      Locking(5)
    return
    *^6::
      Locking(6)
    return
    *^7::
      Locking(7)
    return
    *^8::
      Locking(8)
    return
    *^9::
      Locking(9)
    return
  }
