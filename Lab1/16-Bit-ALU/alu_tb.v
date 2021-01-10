`timescale 1ns/1ns
module alu_tb();
	reg clk;

	reg [3:0] ctrl;

	reg [15:0] in0;
	reg [15:0] in1;

	wire [15:0] out;
	wire of;
	wire z;

	initial begin
		clk = 1;
		ctrl = 0;
		in0 = 0;
		in1 = 0;
	end
	always #5 clk = ~clk;
	always @(posedge clk) begin
		ctrl = 1;
		in0 = 15;
		in1 = 2;
	end

	/*
	 * module alu (
	 *	input [3:0] ctrl,
	 *	input [15:0] a,
	 *	input [15:0] b,
	 *	output [15:0] s,
	 *	output zero,
	 *	output overflow
	 * );
	 */
	alu MUT_alu(ctrl, in0, in1, out, z, of);
endmodule