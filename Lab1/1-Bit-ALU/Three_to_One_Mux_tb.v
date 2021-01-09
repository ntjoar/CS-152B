`timescale 1ns/1ns
module Three_to_One_Mux_tb();
	reg clk;
	reg [4:0] inval;
	
	wire result;

	initial begin
		clk = 1;
		inval = -1;
	end
	always #5 clk = ~clk;
	always @(posedge clk) begin
		inval = inval + 1; 
	end

	/*
	 * module Three_to_One_Mux (
	 *	input i0,
	 *	input i1,
	 *  input i2,
	 *	input [1:0] selector,
	 *	output value
	 * );
	 */
	Three_to_One_Mux MUT3_1(inval[0], inval[1], inval[2], inval[4:3], result);
endmodule