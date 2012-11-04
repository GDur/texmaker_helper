#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force


SetTitleMatchMode 2
if FileExist("texmaker.exe")
  run, texmaker.exe %1%
else
  MsgBox, Please put this script into the same folder where the texmaker.exe is.`n`nThen open the .tex files always with this .exe instead of the texmaker.exe

ToolTip , Texmaker helper activated
Sleep, 2000
ToolTip ,
page := 1

if FileExist("texmaker.ico")
  Menu, Tray, Icon, texmaker.ico

Menu, tray, add  ; Creates a separator line.
Menu, tray, add, Show Tips, MenuHandler  ; Creates a new menu item.

WinWaitClose, Texmaker ahk_class QWidget
{
  WinWaitClose, .tex ahk_class QWidget
  {
  }
  ToolTip , Closed Texmaker helper
  Sleep, 2000
  ExitApp 
}

MenuHandler:
MsgBox ,Press F5 while the texmaker window is active to rebuild the PDF and go to the last opened page.`n`nPress F4 while the texmaker window is active to rebuild the PDF and go to page 1.`n`nTexmaker helper can rebuild the PDF while it's still open.`nTexmaker helper can also remember the page.`n`nby GDur
return

#IfWinActive .tex ahk_class QWidget
  F5::
    WinGetTitle, tmp 
    StringGetPos, pos,  tmp, /, 1
    if pos < 0
    {
    StringGetPos, pos,  tmp, \, 1
    }
    if pos >= 0
    {
      pos++

      StringTrimLeft, tmp, tmp, %pos%
      StringReplace, winTitle, tmp, .tex

      winTitle := winTitle ".pdf" 
      ;MsgBox, %winTitle%

      IfWinExist, %winTitle%
      {
        ControlGetText, tmp, Edit2
        page := tmp
        ;MsgBox, %page%
        WinClose
      }
      WinWaitClose, %winTitle%
      {
        send, {F1}
        sleep,400
                send, {F7}
      }
      WinWaitActive, %winTitle%
      {
        ControlSetText, Edit2, %page%
        ControlSend, Edit2, {Enter}
      }
    }
  return
  
  F4::
    WinGetTitle, tmp 
    StringGetPos, pos,  tmp, /, 1
    if pos < 0
    {
    StringGetPos, pos,  tmp, \, 1
    }
    if pos >= 0
    {
      pos++

      StringTrimLeft, tmp, tmp, %pos%
      StringReplace, winTitle, tmp, .tex

      winTitle := winTitle ".pdf"

      IfWinExist, %winTitle%
      {
        WinClose
      }
      WinWaitClose, %winTitle%
      {
        send, {F1}
        sleep,400
        send, {F7}
      }
    }
  return