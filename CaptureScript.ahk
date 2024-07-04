; Define the location of the inbox file
INBOX_LOCATION := "Enter/Your/Path-Here"

; Set basic minimalist GUI
#SingleInstance Force ; Ensures only one instance of the script runs

Gui, +AlwaysOnTop
Gui, Font, s10 ; Default font size 10
Gui, Add, Text,, Enter anything:
Gui, Add, Edit, vMessage w300 r3 vMessage Multi -WantReturn ; Multi-line edit box with width 300 and rounded corners, Enter submits disabled
Gui, Add, Button, gSubmit Default, OK ; Submit button
Gui, Show, , Quick Capture

Return

Submit:
    Gui, Submit

    ; If the user cancels or leaves the input blank, exit the script
    if (Message = "")
    {
        MsgBox, 48, Error, Error getting input.
        ExitApp
    }

    ; Get the current date and time
    FormatTime, today,, yyyy-MM-dd
    FormatTime, now,, HH:mm

    ; Read the stored date from a temporary file
    stored_date := ""
    FileRead, stored_date, %A_Temp%\last_date.txt

    ; If the date has changed, update the stored date and write the date heading and message
    if (today != stored_date)
    {
        FileAppend, "`n`n### %today%`n- [%now%] %Message%", %INBOX_LOCATION%
        FileDelete, %A_Temp%\last_date.txt
        FileAppend, %today%, %A_Temp%\last_date.txt
    }
    else ; If the date is the same, just append the message
    {
        FileAppend, `n- [%now%] %Message%, %INBOX_LOCATION%
    }

    ; The note has been captured, no need to notify the user
ExitApp

GuiEscape:
GuiClose:
ExitApp

; Handle Shift+Enter to move to next line in the edit box
EditKeyPress:
    If (A_ThisHotkey = "~Enter")
    {
        if (GetKeyState("Shift", "P"))
        {
            SendInput, {Enter}
        }
        else
        {
            ControlClick, Button1
        }
    }
Return
