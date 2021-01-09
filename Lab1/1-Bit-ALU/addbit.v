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

	reg val;
	reg carry;

	/* Note: a ^ b = (a & ~b) | (~a & b) */
	always @(*) begin
		// (a ^ b) ^ cin => ((a & ~b) | (~a & b)) ^ cin => (~((a & ~b) | (~a & b)) & cin) | (((a & ~b) | (~a & b)) & ~cin)
		val = (~((a & ~b) | (~a & b)) & cin) | (((a & ~b) | (~a & b)) & ~cin);

		// (a & b) | ((a ^ b) & cin) => (a & b) | (((a & ~b) | (~a & b)) & cin)
		carry = (a & b) | (((a & ~b) | (~a & b)) & cin); 
	end

	assign sum = val;
	assign co = carry;

endmodule