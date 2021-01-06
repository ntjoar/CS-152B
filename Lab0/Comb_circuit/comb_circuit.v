/*
 * Combinational Circuit for lab 0, part 2
 */

module comb_circuit(
	input CLK,
	input [15:0] inval,
	output divisible
);

/* For storage purposes */
	reg temp0 [15:0];
	reg temp1 [7:0];
	reg temp2 [7:0];
	reg temp3 [3:0];
	reg temp4 [3:0];
	reg temp5 [1:0];
	reg temp;

	always @(posedge CLK) begin
		/* First Level */
		temp0[15] = inval[15] & (~inval[14]);
		temp0[14] = inval[14] & (~inval[15]);

		temp0[13] = inval[13] & (~inval[12]);
		temp0[12] = inval[12] & (~inval[13]);

		temp0[11] = inval[11] & (~inval[10]);
		temp0[10] = inval[10] & (~inval[11]);

		temp0[9] = inval[9] & (~inval[8]);
		temp0[8] = inval[8] & (~inval[9]);

		temp0[7] = inval[7] & (~inval[6]);
		temp0[6] = inval[6] & (~inval[7]);

		temp0[5] = inval[5] & (~inval[4]);
		temp0[4] = inval[4] & (~inval[5]);

		temp0[3] = inval[3] & (~inval[2]);
		temp0[2] = inval[2] & (~inval[3]);

		temp0[1] = inval[1] & (~inval[0]);
		temp0[0] = inval[0] & (~inval[1]);

		/* Second Level */
		temp1[7] = (temp0[13] ^ temp0[15]) | (temp0[12] & temp0[14]);
		temp1[6] = (temp0[12] ^ temp0[14]) | (temp0[13] & temp0[15]);

		temp1[5] = (temp0[9] ^ temp0[11]) | (temp0[8] & temp0[10]);
		temp1[4] = (temp0[8] ^ temp0[10]) | (temp0[9] & temp0[11]);

		temp1[3] = (temp0[5] ^ temp0[7]) | (temp0[4] & temp0[6]);
		temp1[2] = (temp0[4] ^ temp0[6]) | (temp0[5] & temp0[7]);

		temp1[1] = (temp0[1] ^ temp0[3]) | (temp0[0] & temp0[2]);
		temp1[0] = (temp0[0] ^ temp0[2]) | (temp0[1] & temp0[3]);

		/* Third Level */
		temp2[7] = temp1[7] & (~temp1[6]);
		temp2[6] = temp1[6] & (~temp1[7]);

		temp2[5] = temp1[5] & (~temp1[4]);
		temp2[4] = temp1[4] & (~temp1[5]);

		temp2[3] = temp1[3] & (~temp1[2]);
		temp2[2] = temp1[2] & (~temp1[3]);

		temp2[1] = temp1[1] & (~temp1[0]);
		temp2[0] = temp1[0] & (~temp1[1]);

		/* Fourt Level */
		temp3[3] = (temp2[5] ^ temp2[7]) | (temp2[4] & temp2[6]); 
		temp3[2] = (temp2[4] ^ temp2[6]) | (temp2[4] & temp2[7]); 

		temp3[1] = (temp2[1] ^ temp2[3]) | (temp2[0] & temp2[2]); 
		temp3[0] = (temp2[0] ^ temp2[2]) | (temp2[1] & temp2[3]); 

		/* Fifth Level */
		temp4[3] = temp3[3] & (~temp3[2]);
		temp4[2] = temp3[2] & (~temp3[3]);

		temp4[1] = temp3[1] & (~temp3[0]);
		temp4[0] = temp3[0] & (~temp3[1]);

		/* Sixth level */
		temp5[1] = (temp4[1] ^ temp4[3]) | (temp4[0] & temp4[2]);
		temp5[0] = (temp4[0] ^ temp4[2]) | (temp4[1] & temp4[3]);

		/* Final value */
		temp = ~(temp5[0] ^ temp5[1]);
	end

	assign divisible = temp;

endmodule 