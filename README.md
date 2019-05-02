# QMK FUNCTIONALITY REPLICATOR for AutoHotkey

These scripts (both the ahk and py) are meant to replicate certain functionality
seen on QMK keyboards, like the Ergodox. The two pieces of functionality it
replicates are:
1. Hold a key for Ctrl and tap (without using the Ctrl already) for the key itself
2. Tap shift (without using the shift) to output a parenthesis

## THE AHK FILE

I've also put in a way to disable this by toggling ScrollLock in the ahk. The reason
I've done this is because many keyboards still include a light for ScrollLock, so you
can see if the script is toggled or not based on visuals.

By default, this script uses the keys closest to shift as the Ctrl keys. If you use
Dvorak, search for the comments with "DVORAK_ITEM" to make this script compatable,
for the ahk version.

I've commented the code so you should be able to edit it as you need.

This code seems to also work in conjuction with Synergy, but you have to:
1. Have another script with hotkeys (anything that is "key1::key2").
2. Start this script.
3. Start Synergy on all machines until connected.
4. Restart/reload this script.
I don't know why it works but it does for me.

## THE PYTHON FILE
Ahk only works for Windows, and I wanted this in Linux as well. This will actually
require you to get scancodes from xev and such, but it replicates most of the
functionality (not the Scroll lock thing though, maybe later), with some caveats:
1. It uses keycodes, which you'll need to get from xev.
2. It uses Python3.
3. It uses https://github.com/boppreh/keyboard.
4. You have to remap your keyboard layout to swap the Z and Forward Slash keys
   to the corresponding ctrl keys on that side of the keyboard (If you're QWERTY.
   If you use another layout, you'll need that). I personally use Xmodmap, which
   I'll post later.
I also have this run using the root crontab using @reboot.

### Xmodmap
Here is my ~/.Xmodmap, keeping in mind I use a Kinesis Advantage keyboard with dvorak.
You'll want to use xev to get your own keycodes.
```
remove Control = Control_L
remove Control = Control_R
keycode 52 = Control_L
keycode 61 = Control_R
keycode 37 = semicolon colon
keycode 105 = z Z
add Control = Control_L
add Control = Control_R
```
