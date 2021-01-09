`timescale 1ns/1ns
module addbit_tb();
	reg clk;
	reg [3:0] inval;
	
	wire result;
	wire carry;

	initial begin
		clk = 1;
		inval = -1;
	end
	always #5 clk = ~clk;
	always @(posedge clk) begin
		inval = inval + 1; 
	end

	/*
	 * module addbit (
	 *	input a,
	 *	input b,
	 *	input cin, 
	 *	output co,
	 *	output sum
	 * );
	 */
	addbit MUT_add(inval[0], inval[1], inval[2], carry, result);
endmodule