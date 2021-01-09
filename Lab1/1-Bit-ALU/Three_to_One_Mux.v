/*
 * 3-1 MUX for lab 1, part 1
 */

module Three_to_One_Mux (
	input i0,
	input i1,
	input i2,
	input [1:0] selector,
	output value
);

	assign value = (i0 & ~selector[1] & ~selector[0]) | // selector == 2'b00
		       (i1 & ~selector[1] &  selector[0]) | // selector == 2'b01
		       (i2 &  selector[1] & ~selector[0]);  // selector == 2'b10;

endmodule