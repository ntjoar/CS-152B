/*
 * Helping multiplexer for lab 1, part 2
 */

module mux16 (
	input [3:0] s,
	input in0,
	input in1,
	input in2,
	input in3,
	input in4,
	input in5,
	input in6,
	input in7,
	input in8,
	input in9,
	input in10,
	input in11,
	input in12,
	input in13,
	input in14,
	input in15,
	output val
);

	assign val = (~s[3] & ~s[2] & ~s[1] & ~s[0] & in0) | // 0000
				 (~s[3] & ~s[2] & ~s[1] &  s[0] & in1) | // 0001
				 (~s[3] & ~s[2] &  s[1] & ~s[0] & in2) | // 0010
				 (~s[3] & ~s[2] &  s[1] &  s[0] & in3) | // 0011
				 (~s[3] &  s[2] & ~s[1] & ~s[0] & in4) | // 0100
				 (~s[3] &  s[2] & ~s[1] &  s[0] & in5) | // 0101
				 (~s[3] &  s[2] &  s[1] & ~s[0] & in6) | // 0110
				 (~s[3] &  s[2] &  s[1] &  s[0] & in7) | // 0111
				 ( s[3] & ~s[2] & ~s[1] & ~s[0] & in8) | // 1000
				 ( s[3] & ~s[2] & ~s[1] &  s[0] & in9) | // 1001
				 ( s[3] & ~s[2] &  s[1] & ~s[0] & in10) | // 1010
				 ( s[3] & ~s[2] &  s[1] &  s[0] & in11) | // 1011
				 ( s[3] &  s[2] & ~s[1] & ~s[0] & in12) | // 1100
				 ( s[3] &  s[2] & ~s[1] &  s[0] & in13) | // 1101
				 ( s[3] &  s[2] &  s[1] & ~s[0] & in14) | // 1110
				 ( s[3] &  s[2] &  s[1] &  s[0] & in15); // 1111

endmodule