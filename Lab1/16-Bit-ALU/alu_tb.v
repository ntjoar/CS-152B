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
		ctrl = -1;
		in0 = 0;
		in1 = 0;
	end
	always #5 clk = ~clk;
	always @(posedge clk) begin
		ctrl = ctrl + 1;
		if(ctrl == 0) begin
			in0 = -32768;
			in1 = 2;
		end else if (ctrl == 1) begin
			in0 = 32767;
			in1 = 2;
		end else if (ctrl == 4) begin
			in0 = -32768;
			in1 = 2;
		end else if (ctrl == 5) begin
			in0 = 32767;
			in1 = 2;
		end else if (ctrl == 8 || ctrl == 12) begin
			in0 = 32767;
			in1 = 1;
		end else if (ctrl == 10) begin
			in0 = -1;
			in1 = 1;
		end else begin
			in0 = 15;
			in1 = 2;
		end
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