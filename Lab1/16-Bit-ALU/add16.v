/*
 * Helping adder for lab 1, part 2
 */

module add16 (
	input [15:0] a,
	input [15:0] b,
	output co,
	output [15:0] sum
);

	wire carry [0:15];
	wire [15:0] result;

	addbit u0(a[0], b[0], 1'b0, carry[0], result[0]);
	addbit u1(a[1], b[1], carry[0], carry[1], result[1]);
	addbit u2(a[2], b[2], carry[1], carry[2], result[2]);
	addbit u3(a[3], b[3], carry[2], carry[3], result[3]);

	addbit u4(a[4], b[4], carry[3], carry[4], result[4]);
	addbit u5(a[5], b[5], carry[4], carry[5], result[5]);
	addbit u6(a[6], b[6], carry[5], carry[6], result[6]);
	addbit u7(a[7], b[7], carry[6], carry[7], result[7]);

	addbit u8(a[8], b[8], carry[7], carry[8], result[8]);
	addbit u9(a[9], b[9], carry[8], carry[9], result[9]);
	addbit u10(a[10], b[10], carry[9], carry[10], result[10]);
	addbit u11(a[11], b[11], carry[10], carry[11], result[11]);

	addbit u12(a[12], b[12], carry[11], carry[12], result[12]);
	addbit u13(a[13], b[13], carry[12], carry[13], result[13]);
	addbit u14(a[14], b[14], carry[13], carry[14], result[14]);
	addbit u15(a[15], b[15], carry[14], carry[15], result[15]);

	assign sum = result;
	assign co = carry[15];

endmodule 