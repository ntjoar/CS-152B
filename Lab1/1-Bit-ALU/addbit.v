/*
 * Full Adder for lab 1, part 1
 */

module addbit (
	input a,
	input b,
	input cin, 
	output co,
	output sum
);

	// (a ^ b) ^ cin => ((a & ~b) | (~a & b)) ^ cin => (~((a & ~b) | (~a & b)) & cin) | (((a & ~b) | (~a & b)) & ~cin)
	assign sum = (~((a & ~b) | (~a & b)) & cin) | (((a & ~b) | (~a & b)) & ~cin);

	// (a & b) | ((a ^ b) & cin) => (a & b) | (((a & ~b) | (~a & b)) & cin)
	assign co = (a & b) | (((a & ~b) | (~a & b)) & cin); 

endmodule
