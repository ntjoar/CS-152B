/*
 * 2-1 MUX for lab 1, part 1
 */

module Two_to_One_Mux (
	input i0,
	input i1,
	input selector,
	output value
);

	reg val;

	/* selector == 1 ? i1 : i0; */
	always @(*) begin
		val = (i0 & ~selector) | (i1 & selector); 
	end

	assign value = val;

endmodule