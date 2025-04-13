/*
 *
 *  Copyright(C) 2018 Gerald Coe, Devantech Ltd <gerry@devantech.co.uk>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any purpose with or
 *  without fee is hereby granted, provided that the above copyright notice and
 *  this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO
 *  THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
 *  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
 *  DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
 *  AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
 *  CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

`include "playTune.v"
`include "ledscan.v"

module top (
	input clk12MHz,
	input key1,
	input key2,
	input key3,
	input key4,
	output led1,
	output led2,
	output led3,
	output led4,
	output led5,
	output led6,
	output led7,
	output led8,
	output lcol1,
	output lcol2,
	output lcol3,
	output lcol4,
	output spkp,
	output spkm
	);

// Counter register
    reg [31:0] counter;

// Midi note number
	wire [14:0] midi;

// these are the led holding registers, whatever you write to these appears on the led display
	reg [7:0] leds1;
	reg [7:0] leds2;
	reg [7:0] leds3;
	reg [7:0] leds4;

// The output from the ledscan module
	wire [7:0] leds;
	wire [3:0] lcol;

// The output from the music module
	wire note;

// map the output of ledscan to the port pins
	assign { led8, led7, led6, led5, led4, led3, led2, led1 } = leds[7:0];
	assign { lcol4, lcol3, lcol2, lcol1 } = lcol[3:0];


// map the note output from the music module to the port pins
	assign spkp = note;
	assign spkm = !note;

// instantiate the led scan module
 	LedScan scan (
		.clk12MHz(clk12MHz),
		.leds1(leds1),
		.leds2(leds2),
		.leds3(leds3),
		.leds4(leds4),
		.leds(leds),
		.lcol(lcol)
	);

// instantiate the music module
	Music music (
		.clk12MHz(clk12MHz),
		.notetime(midi),
		.note(note)
	);

// instantiate module which generates the notes
        playTune song(
	.clkNote(counter[19]),
	.key(key1),
	.note(midi)
	);




// This is where you place data in the leds matrix for display.
// Here we put a counter on the 1st column and a simple pattern on the others
    always @ (*) begin
		leds1[7:0] = ~counter[28:21];
		leds2[7:0] = 8'b11111100;
		leds3[7:0] = 8'b11100011;
		leds4[7:4] = 4'b0011;
		leds4[3:0] = {key4, key3, key2, key1 };
    end

// increment the counter every clock, only the upper bits are mapped to the leds.
    always @ (posedge clk12MHz) begin
        counter <= counter + 1;
    end

endmodule
