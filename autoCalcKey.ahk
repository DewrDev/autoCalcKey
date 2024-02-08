Menu, Tray, Tip, autoCalcKey is running
Menu, Tray, Add, Launch on Startup?, toggleAutoLaunch
FileCreateDir, %A_appdata%\DewrDev\autoCalcKey\
autoLaunch()

#useHook on ; increases likelihood of hotkey working while a fullscreen (i.e game) application is focused

; when the 'Calculator' key is pressed, send the a Play/Pause keypress.
launch_App2::
send, {Media_Play_Pause}
return

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