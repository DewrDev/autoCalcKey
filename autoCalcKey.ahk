Menu, Tray, Tip, autoCalcKey is running
Menu, Tray, Add, Launch on Startup?, toggleAutoLaunch
FileCreateDir, %A_appdata%\DewrDev\autoCalcKey\
autoLaunch()

#useHook on ; increases likelihood of hotkey working while a fullscreen (i.e game) application is focused

; when the 'Calculator' key is pressed, send the a Play/Pause keypress.

RegRead, key,HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AppKey\18,ShellExecute
; msgbox % key

Hotkey, ~launch_App2 , calcKeyPress
; Modify Explorer's 'Appskey' to prevent the Calculator app from being run by the Calculator button. This is required because AHK cannot seem to tell if the key is being HELD when we consume all key input.
RegWrite,REG_SZ,HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AppKey\18,ShellExecute,

#InstallKeybdHook

calcKeyPress()
{
    start:=A_TickCount
    loop,
    {
        if ( !(GetKeyState("launch_App2",P)) && (A_TickCount-start <= 250))
        {
            send, {Media_Play_Pause}
            return
        }
        Else if ((GetKeyState("launch_App2",P)) && (A_TickCount-start >= 250))
        {
            ;activate modifier key and use Pause+ScrollLock for media back/next
        Hotkey,pause,nextButton,on
        Hotkey,ScrollLock,backButton,on
        loop,
        {
            ; when key is released, turn off Pause+ScrollLock hotkeys
            if !(GetKeyState("launch_App2",P))
            {
                Hotkey,pause,nextButton,off
                Hotkey,ScrollLock,backButton,off
                return
            }
        }
            return
        }
    }
}

backButton()
{
    send, {Media_Prev}
}

nextButton()
{
    send, {Media_Next}
}

toggleAutoLaunch()
{
    IniRead, iniValue, %A_appdata%\DewrDev\autoCalcKey\autoCalcKey.ini, config, launchOnStartup ,% false
    IniWrite,% !(iniValue) , %A_appdata%\DewrDev\autoCalcKey\autoCalcKey.ini, config, launchOnStartup
    autoLaunch()
}

autoLaunch()
{
    IniRead, iniValue, %A_appdata%\DewrDev\autoCalcKey\autoCalcKey.ini, config, launchOnStartup ,% false
    if (iniValue)
    {
        FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\autoCalcKey.lnk, %A_Scriptdir%,,autoCalcKey,,,
        Menu, Tray, Check, Launch on Startup?
    }
    Else
    {
        Menu, Tray, UnCheck, Launch on Startup?
        fileDelete,%A_Startup%\autoCalcKey.lnk
    }
}