#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SetBatchLines, -1
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; QMK FUNCTIONALITY REPLICATOR ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This script is meant to replicate certain functionality seen on QMK keyboards, like
; the Ergodox. The two pieces of functionality it replicates are:
; 1. Hold a key for Ctrl and tap (without using the Ctrl already) for the key itself
; 2. Tap shift (without using the shift) to output a parenthesis
; I've also put in a way to disable this by toggling ScrollLock. The reason I've done
; this is because many keyboards still include a light for ScrollLock, so you can see
; if the script is toggled or not based on visuals.
; By default, this script uses the keys closest to shift as the Ctrl keys. If you use
; Dvorak, search for the comments with "DVORAK_ITEM" to make this script compatable.
; I've commented the code so you should be able to edit it as you need.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; =========
; = SETUP =
; =========
; This is for all the global variables and constants

; Constants (you may edit the values based on your needs, see comments)
controlTimeLimit := 200 ; The time in milliseconds that a key release needs to happen to
	; register a "tap".

; Global vars (do not mess with this unless you understand the code)
keyIsPressed := false
leftCtrlHeldDown := false
leftCtrlTimeDown := 0
rightCtrlHeldDown := false
rightCtrlTimeDown := 0
leftShiftHeldDown := false
leftShiftTimeDown := 0
rightShiftHeldDown := false
rightShiftTimeDown := 0


; ==================
; = NORMAL HOTKEYS =
; ==================
; This is the area where all your other hotkeys should go, should you need them.
; I've left some in here as examples of what you can leave in.
; The reason why they are here is that for some reason, Synergy doesn't work with
; this script unless normal hotkeys are placed here, between the setup and the actual
; QMK emulation.
; Note that if you want to use your actual CTRL keys for something else, you should
; use the dollar sign prefix ($) so that the script still works.
; So do something like "$LControl::Send boop"
; You may also want to hook into ScrollLock, so it outputs the normal CTRL
; if the other CTRLs are disabled.

; Fix the F7 and F8 keys on my home machine, which is broken for some reason
VKB4::F7
VKAC::F8

; Remap Insert to shortcut keys
Insert::Send ^z


; ====================
; = TAP/CTRL HOTKEYS =
; ====================
; This section holds the hotkeys for:
; - If you press and release a key within %controlTimeLimit%, output the key
; - If you hold it and press another key, treat the key as a CTRL
; - If you hold it > %controlTimeLimit%, treat it like a CTRL (usually does nothing)
; A side effect of this is that as soon as you press the key, it presses CTRL as well.
; This usually doesn't have any effect, unless you're playing a game or something.

; DVORAK_ITEM - Change the below line to *$`;::
*$z::
	if (!leftCtrlHeldDown && !GetKeyState("ScrollLock", "T")) {
		Send {Blind}{LControl down}
		leftCtrlHeldDown := true
		keyIsPressed := false
		leftCtrlTimeDown := A_TickCount
		; Disable all other hold keys
		rightCtrlTimeDown := 0
		leftShiftTimeDown := 0
		rightShiftHeldDown := 0
	} else if (!leftCtrlHeldDown) {
		; DVORAK_ITEM - Change the 'z' to a ';'
		Send {Blind};
	}
return
; DVORAK_ITEM - Change the below line to *$` Up;::
*$z Up::
	if (leftCtrlHeldDown && !GetKeyState("ScrollLock", "T")) {
		Send {Blind}{LControl up}
		elapsedTime := A_TickCount - leftCtrlTimeDown
		if (!keyIsPressed && elapsedTime < controlTimeLimit) {
			; DVORAK_ITEM - Change the 'z' to a ';'
			Send {Blind};
			keyIsPressed := true
		}
		leftCtrlHeldDown := false
	}
return

; DVORAK_ITEM - Change the below line to *$z::
*$/::
	if (!rightCtrlHeldDown && !GetKeyState("ScrollLock", "T")) {
		Send {Blind}{RControl down}
		rightCtrlHeldDown := true
		keyIsPressed := false
		rightCtrlTimeDown := A_TickCount
		; Disable all other hold keys
		leftCtrlTimeDown := 0
		leftShiftTimeDown := 0
		rightShiftHeldDown := 0
	} else if (!rightCtrlHeldDown) {
		; DVORAK_ITEM - Change the / to z
		Send {Blind}z
	}
return
; DVORAK_ITEM - Change the below line to *$z Up::
*$/ Up::
	if (rightCtrlHeldDown && !GetKeyState("ScrollLock", "T")) {
		Send {Blind}{RControl up}
		elapsedTime := A_TickCount - rightCtrlTimeDown
		if (!keyIsPressed && elapsedTime < controlTimeLimit) {
			; DVORAK_ITEM - Change the / to z
			Send {Blind}z
			keyIsPressed := true
		}
		rightCtrlHeldDown := false
	}
return


; ========================
; = SHIFT PARENS HOTKEYS =
; ========================
; This section holds the hotkeys for; if you press and release shift within
; %controlTimeLimit% without pressing any other key, output a parenthesis.
; Shift otherwise works the same as normal.

*$~LShift::
	if (!leftShiftHeldDown && !GetKeyState("ScrollLock", "T")) {
		leftShiftHeldDown := true
		keyIsPressed := false
		leftShiftTimeDown := A_TickCount
		; Disable all other hold keys
		rightCtrlTimeDown := 0
		leftCtrlTimeDown := 0
		rightShiftHeldDown := 0
	}
return
*$~LShift Up::
	if (leftShiftHeldDown && !GetKeyState("ScrollLock", "T")) {
		elapsedTime := A_TickCount - leftShiftTimeDown
		if (!keyIsPressed && elapsedTime < controlTimeLimit) {
			Send {Blind}(
			keyIsPressed := true
		}
		leftShiftHeldDown := false
	}
return

*$~RShift::
	if (!rightShiftHeldDown && !GetKeyState("ScrollLock", "T")) {
		rightShiftHeldDown := true
		keyIsPressed := false
		rightShiftTimeDown := A_TickCount
		; Disable all other hold keys
		rightCtrlTimeDown := 0
		leftCtrlTimeDown := 0
		leftShiftHeldDown := 0
	}
return
*$~RShift Up::
	if (rightShiftHeldDown && !GetKeyState("ScrollLock", "T")) {
		elapsedTime := A_TickCount - rightShiftTimeDown
		if (!keyIsPressed && elapsedTime < controlTimeLimit) {
			Send {Blind})
			keyIsPressed := true
		}
		rightShiftHeldDown := false
	}
return


; ==========================
; = HOTKEY DISABLE HOTKEYS =
; ==========================
; If we release a key within %controlTimeLimit% but we've pressed another key,
; with a high probability, we've used the key as a modifier and not a typed key.
; The section below listens to every relevant key and sets our state appropriately.
; There are a couple of differences for Dvorak to pay attention to.

; DVORAK_ITEM - Replace "`;" with "/" in the next line
*$~`;::
*$~Right::
*$~Left::
*$~Up::
*$~Down::
*$~PgUp::
*$~PgDn::
*$~Home::
*$~End::
*$~\::
*$~]::
*$~[::
*$~=::
*$~-::
*$~LControl::
*$~RControl::
*$~LAlt::
*$~RAlt::
*$~LWin::
*$~RWin::
*$~CapsLock::
*$~ScrollLock::
*$~Pause::
*$~PrintScreen::
*$~`::
*$~,::
*$~.::
*$~'::
*$~Tab::
*$~Esc::
*$~a::
*$~b::
*$~c::
*$~d::
*$~e::
*$~f::
*$~g::
*$~h::
*$~i::
*$~j::
*$~k::
*$~l::
*$~m::
*$~n::
*$~o::
*$~p::
*$~q::
*$~r::
*$~s::
*$~t::
*$~u::
*$~v::
*$~w::
*$~x::
*$~y::
*$~1::
*$~2::
*$~3::
*$~4::
*$~5::
*$~6::
*$~7::
*$~8::
*$~9::
*$~0::
*$~F1::
*$~F2::
*$~F3::
*$~F4::
*$~F5::
*$~F6::
*$~F7::
*$~F8::
*$~F9::
*$~F10::
*$~F11::
*$~F12::
*$~F13::
*$~F14::
*$~F15::
*$~F16::
*$~F17::
*$~F18::
*$~F19::
*$~F20::
*$~F21::
*$~F22::
*$~F23::
*$~F24::
	keyIsPressed := true
return
