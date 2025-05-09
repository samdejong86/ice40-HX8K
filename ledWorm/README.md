# LED worm project

A LED worm crawls around the screen controlled by the buttons:
 - button 1: worm goes down and right
 - button 2: worm goes down and left
 - button 3: worm goes up and right
 - button 4: worm goes up and left

Combinations of buttons move the worm up/down or left/right:
 - buttons 1 & 2: down
 - buttons 3 & 4: up
 - buttons 1 & 3: right
 - buttons 2 & 4: left

The calculations are done in `led_worm.vhd`.

Build the project with `make` and program the board with `make burn`