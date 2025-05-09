# Music project

This project plays simple tunes on the piezo speaker when a button is pressed.
Example tunes are located in the `music-files` directory.

Each button on the icefun board plays a different tune

Note that I am not a musician nor an expert on music theory.
As such, my definitions of notes and octaves might be incorrect.

## Building the project

Build the firmware with `make` and program the board with `make burn`.

To change the tunes associated with the buttons, use
```
make MUSIC<N>=filename.notes
```

where <N> can be 1, 2, 3, or 4.
The format of `filename.notes` is desribed in the "Music file format" section.


## Music file format

The music files follow this format:
```
NOTE	OCTAVE	DURATION
```

 - `NOTE` is the letter value of the note and can be `A`, `A#`, `Bf`, `B`, `Cf`, `C`, `C#`, `Df`, `D`, `D#`, `Ef`, `E`, `F`, `F#`, `Gf`, `G`, or `G#`
   - `#` indicates sharp notes, `f` indicates flat notes
 - `OCTAVE` indicates the octave relative to the octave where the frequency of A is 440 Hz
 - `DURATION` indicates the duration of the note in 16ths: A value of '16' would indicate a whole note, '8' would be a half note, etc.

The `songWriter.py` script in `../scripts` converts this file into a format which can be read by the compiler.

## Note generation

To generate a note, a waveform is procduced by holding the input to the speaker high for half the wavelength of the note, then low for half the wavelength.

The number of clock ticks for a given frequency is
```
N=base-frequency/(2*note-frequency)
```

The clock on the icefun board has a frequency of 12 MHz, which gives these values for the number of ticks for octave 0:
| Note          | Frequency (Hz) | Counts |
|----------------|---------------|--------|
| C              | 261.63        | 9173   |
| C sharp/D flat | 277.18        | 8659   |
| D              | 293.66        | 8173   |
| D sharp/E flat | 311.1         | 7715   |
| E              | 329.63        | 7281   |
| F              | 349.23        | 6872   |
| F sharp/G flat | 369.9         | 6488   |
| G              | 392           | 6122   |
| G sharp/A flat | 415.3         | 5779   |
| A              | 440           | 5455   |
| A sharp/B flat | 466.16        | 5148   |
| B/C sharp      | 493.88        | 4859   |

So holding the speaker input hight for 5455 ticks of the 12 MHz clock then low for the same number will produce an A note.

Doubling the count will halve the frequency, dropping the note by an octave.