`timescale 1ns/1ns
module Two_to_One_Mux_tb();
	reg clk;
	reg [2:0] inval;
	
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
	 * module Two_to_One_Mux (
	 *	input i0,
	 *	input i1,
	 *	input selector,
	 *	output value
	 * );
	 */
	Two_to_One_Mux MUT2_1(inval[0], inval[1], inval[2], result);
endmodule