

   parameter songLength = 134;
   parameter [0:(15*songLength)-1] noteList = {_A,
_r,
_A,
_A,
_A,
_A,
_A,
_G,
_A,
_r,
_A,
_A,
_A,
_A,
_A,
_G,
_A,
_r,
_A,
_A,
_A,
_A,
_A,
_E,
_E,
_E,
_E,
_E,
_E,
_E,
_E,
_E,
_E,
_A,
_E,
_A,
_A,
_B,
_Cs>>1,
_D>>1,
_E>>1,
_r,
_E>>1,
_E>>1,
_F>>1,
_G>>1,
_A>>1,
_r,
_A>>1,
_A>>1,
_G>>1,
_F>>1,
_G>>1,
_F>>1,
_E>>1,
_E>>1,
_D>>1,
_D>>1,
_E>>1,
_F>>1,
_E>>1,
_D>>1,
_C>>1,
_C>>1,
_D>>1,
_E>>1,
_D>>1,
_C>>1,
_B,
_B,
_Cs>>1,
_Ds>>1,
_Fs>>1,
_E>>1,
_E,
_E,
_E,
_E,
_E,
_E,
_E,
_E,
_E,
_E,
_A,
_E,
_A,
_A,
_B,
_Cs>>1,
_D>>1,
_E>>1,
_r,
_E>>1,
_E>>1,
_F>>1,
_G>>1,
_A>>1,
_r,
_C>>2,
_B>>1,
_Gs>>1,
_E>>1,
_F>>1,
_A>>1,
_Gs>>1,
_E>>1,
_E>>1,
_F>>1,
_A>>1,
_Gs>>1,
_E>>1,
_Cs>>1,
_D>>1,
_F>>1,
_E>>1,
_C>>1,
_A,
_B,
_B,
_Cs>>1,
_Ds>>1,
_Fs>>1,
_E>>1,
_E,
_E,
_E,
_E,
_E,
_E,
_E,
_E,
_E,
					       _E};


   parameter [0:(5*songLength)-1] durationList = {5'd4,
5'd2,
5'd1,
5'd2,
5'd2,
5'd2,
5'd2,
5'd1,
5'd2,
5'd2,
5'd1,
5'd2,
5'd2,
5'd2,
5'd2,
5'd1,
5'd2,
5'd2,
5'd1,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd3,
5'd1,
5'd2,
5'd2,
5'd2,
5'd2,
5'd4,
5'd1,
5'd1,
5'd2,
5'd2,
5'd2,
5'd4,
5'd1,
5'd1,
5'd2,
5'd2,
5'd2,
5'd3,
5'd2,
5'd4,
5'd2,
5'd2,
5'd2,
5'd2,
5'd4,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd4,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd4,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd3,
5'd1,
5'd2,
5'd2,
5'd2,
5'd2,
5'd4,
5'd1,
5'd1,
5'd2,
5'd2,
5'd2,
5'd4,
5'd2,
5'd2,
5'd2,
5'd4,
5'd2,
5'd6,
5'd2,
5'd2,
5'd4,
5'd2,
5'd6,
5'd2,
5'd2,
5'd4,
5'd2,
5'd6,
5'd2,
5'd2,
5'd4,
5'd2,
5'd2,
5'd2,
5'd2,
5'd4,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2,
5'd2};
