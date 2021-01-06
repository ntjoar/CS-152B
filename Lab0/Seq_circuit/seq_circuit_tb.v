`timescale 1ns/1ns
module seq_circuit_tb();
	reg clk;
	reg [3:0] inval;
	reg en, ld, ud, cl;
	reg [7:0] seqCounter;

	reg [2:0] stage;

	wire [3:0] counter;
	wire carry;

	initial begin
		clk = 1;
		stage = 0;
	end
	always #5 clk = ~clk;
	always @(posedge clk) begin
		if(stage == 0) begin // ld in a value
			en = 1;
			ld = 1;
			ud = 0;
			inval = 2;
			cl = 1;
			stage = 1;
		end else if(stage == 1) begin // increment
			seqCounter = 1;
			cl = 1;
			inval = 0;
			ud = 1;
			ld = 0;
			en = 1;
			if(carry == 1'b1) begin
				stage = 2;
			end
		end else if(stage == 2) begin // clr
			seqCounter = 1;
			cl = 0;
			inval = 1;
			ud = 0;
			ld = 1;
			en = 0;
			stage = 3;
		end else if(stage == 3) begin // ld
			en = 1;
			ld = 1;
			ud = 0;
			inval = 2;
			cl = 1;
			stage = 4;
		end else if(stage == 4) begin // decrement
			seqCounter = 1;
			cl = 1;
			inval = 0;
			ud = 0;
			ld = 0;
			en = 1;
			if(carry == 1'b1) begin
				stage = 5;
			end
		end else if(stage == 5) begin // clr
			seqCounter = 0;
			cl = 0;
			inval = 0;
			ud = 1;
			ld = 0;
			en = 1;
			stage = 6;
		end else begin
			seqCounter = seqCounter + 1;
			inval = seqCounter[3:0];
			cl = seqCounter[7];
			ud = seqCounter[4];
			ld = seqCounter[5];
			en = seqCounter[6];
		end 
	end

	/*
	 * seq_circuit(
	 * 	input clk,
	 *	input enable, 
	 *	input load, 
	 *	input up, 
	 *	input clr, 
	 *	input [3:0] d, 
	 *	output [3:0] q, 
	 *	output co
	 * );
	 */

	seq_circuit MUT(clk, en, ld, ud, cl, inval, counter, carry);
endmodule 
