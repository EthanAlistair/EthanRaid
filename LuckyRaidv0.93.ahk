#Requires AutoHotkey v2.0
#SingleInstance Force

CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"
SetMouseDelay -1

; CONFIG
; CHANGE DEPENDING ON YOUR RESOLUTION
; THIS IS FOR 1920X1080 FULLSCREEN DEFAULT CAMERA ANGLE/ZOOM

global CORDS := Map(
    "AutoRaid",  [296, 531],   
    "Lever",     [525, 496],
    "OkayBtn",   [734, 741] 
)

; CHANGE DEPENDING ON YOUR RAID SPEED AND LOADING TIMES
global WALK_DOOR  := 4000 ; 4 seconds
global WALK_BOSS := 6000 ; 6 seconds
global BOSS_KILL := 25000 ; 25 seconds - CHANGE THIS DEPENDING ON YOUR KILL TIME
global RAID_DOWNTIME := 27000 ; 27 seconds- CHANGE THIS DEPENDING ON YOUR RAID TIME
global AUTO_DELAY := 4000 ; 4 seconds
global LOADING_SCREEN := 4000 ; 4 seconds - CHANGE THIS DEPENDING ON YOUR LOADING SCREEN TIME

global toggle := false

; AUTOCLICKER
global CLICK_AREA := Map(
    "x1", 375,  ; left bound
    "y1", 214,  ; top bound
    "x2", 1488, ; right bound
    "y2", 785   ; bottom bound
)

; HOTKEYS
; PERSONAL PREFERENCE - USE THE KEYBINDS YOU WANT

F8:: ExitApp

F5:: {

    global toggle
    toggle := !toggle

    if (toggle) {
        clickSpot(CORDS["AutoRaid"], 1000)
        Sleep AUTO_DELAY
        Sleep LOADING_SCREEN

        while (toggle) {
            runRaidLoop()
        }
    }
}

; GAME LOOP

runRaidLoop() {

    ; autoclicker during raid
    startTime := A_TickCount
    while (A_TickCount - startTime < RAID_DOWNTIME) {
        randX := Random(CLICK_AREA["x1"], CLICK_AREA["x2"])
        randY := Random(CLICK_AREA["y1"], CLICK_AREA["y2"])
        clickSpotPos(randX, randY, 0)
    }

    ; turn off autorid
    clickSpot(CORDS["AutoRaid"], 1000)

    ; click lever
    clickSpot(CORDS["Lever"], 1000)

    ; walk right
    Send "{d down}"
    Sleep WALK_DOOR
    Send "{d up}"
    Sleep 500

    ; prompt door
    Send "{e}"
    Sleep 800

    ; use key
    clickSpot(CORDS["OkayBtn"], 1000)

    ; walk to boss
    Send "{d down}"
    Sleep WALK_BOSS
    Send "{d up}"
    Sleep 500

    Sleep BOSS_KILL

    ; click autoraid to restart
    clickSpot(CORDS["AutoRaid"], 0)
    Sleep AUTO_DELAY
    Sleep LOADING_SCREEN

}

; utils

clickSpot(coords, wait) {
    SendEvent "{Click, " coords[1] ", " coords[2] ", 1}"
    Sleep wait
}

clickSpotPos(x, y, wait) {
    SendEvent "{Click, " x ", " y ", 1}"
    Sleep wait
}