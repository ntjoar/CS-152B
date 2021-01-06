`timescale 1ns/1ns
module seq_circuit_tb();
	reg clk;
	reg [7:0] inval;

	wire [3:0] counter;
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
	 * seq_circuit(
	 * 	input CLK,
	 *	input enable, 
	 *	input load, 
	 *	input up, 
	 *	input clr, 
	 *	input [3:0] d, 
	 *	output [3:0] q, 
	 *	output co
	 * );
	 */

	seq_circuit MUT(clk, inval[4], inval[5], inval[6], 1'b1, inval[3:0], counter, carry);
endmodule 