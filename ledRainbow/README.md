# LED rainbow project

This project powers RGB LEDs connected to pins [2:0], [5:3], and [8:6].
It could likely be adapted to use the high current RGB drivers as well.

The RGB connections are:
 - RED: pins 0, 3, 6
 - GREEN: pins 1, 4, 7
 - BLUE: pins 2, 5, 8

When running, the RGB leds cycle smoothly through a spectrum of colours.
This is achieved via pulse width modulation (PMW), which uses the duty cycle of the signal going into the LEDs to vary the brightness of that LED.

## How it works

The file `sines.mif` contains 360 values for the duty cycle, ranging from 0% (off) to 100% (fill brightness).
These were generated using this formula
```
Duty cycle = sin(n) x 127 + 127
```
in order to produce a smooth transition between colours.

The duty cycle of each colour is offset from the others by 120:
```
Red duty cycle = data(i)
Green duty cycle = data(i+120)
Blue duty cycle = data(i+240)
```

This data is read by `sineLoop.vhd`.
The duty cycle is created in `colour_generator.vhd`