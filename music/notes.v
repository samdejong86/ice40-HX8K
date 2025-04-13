/*
 * Note counters for 12 MHz clock.
 * Values are calculed as f_12MHz/(2*f_note)
 *
 * left and right shifts can be used to go down or up an octave.
 *
 * applying >>1 shifts up by 1 octave (higher pitch)
 * applyubg <<1 shifts down by one octave
 */

parameter _C  = 15'd22933; //261.63 Hz
parameter _Cs = 15'd21647; //277.18 Hz
parameter _D  = 15'd20432; //293.66 Hz
parameter _Ds = 15'd19285; //311.13 Hz
parameter _E  = 15'd18202; //329.63 Hz
parameter _F  = 15'd17181; //349.23 Hz
parameter _Fs = 15'd16217; //369.9 Hz
parameter _G  = 15'd15306; //392 Hz
parameter _Gs = 15'd14447; //415.3 Hz
parameter _A  = 15'd13636; //440 Hz
parameter _As = 15'd12871; //466.16 Hz
parameter _B  = 15'd12149; //493.88 Hz
parameter _r  = 15'd0;     //rest: don't play a note
