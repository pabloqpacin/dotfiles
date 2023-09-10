#Requires AutoHotkey v2

; https://www.autohotkey.com/docs/v2/lib/Run.htm
; https://www.autohotkey.com/docs/v2/Hotkeys.htm
; https://www.autohotkey.com/docs/v2/Tutorial.htm
; https://www.autohotkey.com/docs/v2/lib/Process.htm

; Super+T == WindowsTerminal 
#t:: {
    Run 'wt.exe'
    ; TODO: PID to focus
}

; Super+B == Brave
#b:: {
    Run 'brave.exe'
    ; TODO: PID to focus
}


; TODO: code window transparency
