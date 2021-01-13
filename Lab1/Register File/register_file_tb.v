`timescale 1ns/1ns
module register_file_tb();
	reg clk;

	reg rstVal;

	reg enableWrite;
	reg [15:0] writeVal;
	reg [4:0] write;

	reg [4:0] readA;
	reg [4:0] readB;
	
	wire [15:0] bsA;
	wire [15:0] bsB;

	reg [1:0] i;

	initial begin
		clk = 1;
		rstVal = 1;
		enableWrite = 0;
		writeVal = 0;
		readA = 0;
		readB = 0;
		write = 0;
		i = -1;
	end
	always #5 clk = ~clk;
	always @(posedge clk) begin
		i = i + 1;
		if(i == 0) begin
			rstVal = 0;
			enableWrite = 1;
			writeVal = 15;
			readA = 3;
			readB = 4;
			write = 4;
		end else if(i == 1) begin 
			rstVal = 0;
			enableWrite = 1;
			writeVal = 15;
			readA = 4;
			readB = 4;
			write = 3;
		end else if(i == 2) begin
			rstVal = 0;
			enableWrite = 1;
			writeVal = 7;
			readA = 3;
			readB = 4;
			write = 4;
		end else begin
			rstVal = 1;
			enableWrite = 1;
			writeVal = 7;
			readA = 3;
			readB = 4;
			write = 4;
		end
	end

	/*
	 * module register_file (
	 *	input rst,
	 *	input WrEn,
	 *	input [15:0] busW,
	 *	input [4:0] Ra,
	 *	input [4:0] Rb,
	 *	input [4:0] Rw,
	 *	output [15:0] busA,
	 *	output [15:0] busB,
	 * );
	 */
	register_file MUT_reg(rstVal, enableWrite, writeVal, readA, readB, write, bsA, bsB);
endmodule
