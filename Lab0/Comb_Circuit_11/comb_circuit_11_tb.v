`timescale 1ns/1ns
module comb_circuit_11_tb();
	reg clk;
	reg [15:0] inval;
	
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
	 * comb_circuit(
	 *	input CLK,
	 *	input [15:0] inval,
	 *	output divisible
	 * );
	 */

	comb_circuit_11 MUT3(inval, result);
endmodule
