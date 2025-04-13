
// Header contains note counter lengths
`include "notes.v"

// uncomment the song you want
//`include "marioTheme.v"
`include "scotlandTheBrave.v"
//`include "lotz.v"


// Module which plays the notes. Based on the `music` module created by Gerald Coe, Devantech Ltd for his iceFun examples:
// https://github.com/devantech/iceFUN/blob/master/music/music.v
module Music (
	input clk12MHz,
	input [14:0] notetime,
	output reg note
	);

   // Timer register */
    reg [14:0] timer = 15'b0;

   // increment the note timer
    always @ (posedge clk12MHz) begin
       if(notetime==0)
	 note <= 0;
       else begin
    	if (timer==notetime)
	  begin
    		timer <= 15'b0;
    		note <= !note;
    	  end
        else timer <= timer + 1;
       end // else: !if(notetime==0)
    end

endmodule

module playTune(
	input		  clkNote,
	input		  key,
	output reg [14:0] note);

   localparam IDLE = 2'b00;
   localparam PLAYNOTE = 2'b01;
   localparam PAUSE = 2'b10;

   reg [1:0]  state = IDLE;
   integer    noteCounter;
   integer    holdCounter;


   always @(posedge clkNote)
     begin
	case(state)

	  IDLE:
	    begin
	       holdCounter <= 0;
	       noteCounter <= 0;
	       note <= 0;
	       if(key==1) state <= IDLE;
	       else state <= PLAYNOTE;
	    end

	  PLAYNOTE:
	    begin
	       if (noteCounter==songLength)
		 state <= IDLE;
	       else
		 begin
		    note <= noteList[noteCounter*15+:15];
		    holdCounter <= holdCounter + 1;

		    if (holdCounter == durationList[noteCounter*5+:5]-1)
		      state <= PAUSE;
		    else
			 state <= PLAYNOTE;
		 end // else: !if(noteCounter==songLength)
	    end // case: PLAYNOTE

	 PAUSE:
	   begin
	      note <= 0;
	      holdCounter <=0;
	      noteCounter <= noteCounter + 1;
	      state <= PLAYNOTE;
	   end
	endcase // case (state)
     end // always @ (posedge clkNote)

endmodule // playTune
