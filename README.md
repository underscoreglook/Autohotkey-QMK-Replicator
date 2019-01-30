# QMK FUNCTIONALITY REPLICATOR for AutoHotkey

This script is meant to replicate certain functionality seen on QMK keyboards, like the Ergodox.
The two pieces of functionality it replicates are:
1. Hold a key for Ctrl and tap (without using the Ctrl already) for the key itself
2. Tap shift (without using the shift) to output a parenthesis

I've also put in a way to disable this by toggling ScrollLock. The reason I've done
this is because many keyboards still include a light for ScrollLock, so you can see
if the script is toggled or not based on visuals.

By default, this script uses the keys closest to shift as the Ctrl keys. If you use
Dvorak, search for the comments with "DVORAK_ITEM" to make this script compatable.

I've commented the code so you should be able to edit it as you need.

This code seems to also work in conjuction with Autohotkey, but only if the structure is adhered to.
