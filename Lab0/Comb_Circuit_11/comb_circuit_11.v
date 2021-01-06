/*
 * Combinational Circuit for lab 0, part 2, doing 11
 */

module comb_circuit_11(
	input [15:0] inval,
	output divisible
);

	/* Add 0'b110 */
	function [15:0] adder;
		input [15:0] inval;		
		input activate; 
		
		reg carry;
		reg[15:0] temp;
		reg addVal;
		
		begin
			addVal = 1'b1 & activate;
			temp[0] = inval[0];
	
			temp[1] = (addVal ^ inval[1]);
			carry = (addVal & inval[1]);
		
			temp[2] = ((addVal ^ inval[2]) ^ carry);
			carry = (addVal & inval[2]) | ((addVal ^ inval[2]) & carry);
		
			temp[3] = (carry ^ inval[3]);
			carry = (carry & inval[3]);
			
			temp[4] = (carry ^ inval[4]);
			carry = (carry & inval[4]);
		
			temp[5] = (carry ^ inval[5]);
			carry = (carry & inval[5]);
		
			temp[6] = (carry ^ inval[6]);
			carry = (carry & inval[6]);
		
			temp[7] = (carry ^ inval[7]);
			carry = (carry & inval[7]);
		
			temp[8] = (carry ^ inval[8]);
			carry = (carry & inval[8]);
		
			temp[9] = (carry ^ inval[9]);
			carry = (carry & inval[9]);
		
			temp[10] = (carry ^ inval[10]);
			carry = (carry & inval[10]);
		
			temp[11] = (carry ^ inval[11]);
			carry = (carry & inval[11]);
		
			temp[12] = (carry ^ inval[12]);
			carry = (carry & inval[12]);
			
			temp[13] = (carry ^ inval[13]);
			carry = (carry & inval[13]);
		
			temp[14] = (carry ^ inval[14]);
			carry = (carry & inval[14]);
		
			temp[15] = (carry ^ inval[15]);
			carry = (carry & inval[15]);
	
			adder = temp;
		end	
	endfunction
	
	function [15:0] shifter;
		input [15:0] inval;
		input activate;
	
		reg [15:0] value;
		begin
			value[15] = 1'b0;
			value[14] = (inval[15] & activate) | (inval[14] & ~activate);
			value[13] = (inval[14] & activate) | (inval[13] & ~activate);
			value[12] = (inval[13] & activate) | (inval[12] & ~activate);
			value[11] = (inval[12] & activate) | (inval[11] & ~activate);
			value[10] = (inval[11] & activate) | (inval[10] & ~activate);
			value[9] = (inval[10] & activate) | (inval[9] & ~activate);
			value[8] = (inval[9] & activate) | (inval[8] & ~activate);
			value[7] = (inval[8] & activate) | (inval[7] & ~activate);
			value[6] = (inval[7] & activate) | (inval[6] & ~activate);
			value[5] = (inval[6] & activate) | (inval[5] & ~activate);
			value[4] = (inval[5] & activate) | (inval[4] & ~activate);
			value[3] = (inval[4] & activate) | (inval[3] & ~activate);
			value[2] = (inval[3] & activate) | (inval[2] & ~activate);
			value[1] = (inval[2] & activate) | (inval[1] & ~activate);
			value[0] = (inval[1] & activate) | (inval[0] & ~activate);
			shifter = value;
		end
	endfunction 

	function isZero;
		input [15:0] inval;
	
		reg noZero;
		begin
			noZero = inval[15] | inval[14] | inval[13] | inval[12] |
					 inval[11] | inval[10] | inval[9]  | inval[8]  | 
					 inval[7]  | inval[6]  | inval[5]  | inval[4]  |
					 inval[3]  | inval[2]  | inval[1]  | inval[0];
			isZero = ~noZero;
		end
	endfunction 

	/* For other modules */
	reg [15:0] value;
	reg act;

	reg prevVal;

	/* Final val */
	reg temp;

	/* Essentially loop until all values are zero (i.e. 12 loops give or take) */
	always @(*) begin
		// Save result
		temp = isZero(inval ^ 11) | isZero(inval);

		// Shift until just one 
		act = 1'b1;
		value = shifter(inval, act);
		act = ~inval[0] & act;
		value = shifter(value, act);
		act = ~inval[1] & act;
		value = shifter(value, act);
		act = ~inval[2] & act;
		value = shifter(value, act);
		act = ~inval[3] & act;
		value = shifter(value, act);
		act = ~inval[4] & act;
		value = shifter(value, act);
		act = ~inval[5] & act;
		value = shifter(value, act);
		act = ~inval[6] & act;
		value = shifter(value, act);
		act = ~inval[7] & act;
		value = shifter(value, act);
		act = ~inval[8] & act;
		value = shifter(value, act);
		act = ~inval[9] & act;
		value = shifter(value, act);
		act = ~inval[10] & act;
		value = shifter(value, act);
		act = ~inval[11] & act;
		value = shifter(value, act);
		act = ~inval[12] & act;
		value = shifter(value, act);
		act = ~inval[13] & act;
		value = shifter(value, act);
		act = ~inval[14] & act;
		value = shifter(value, act);

		value = adder(value, ~temp);

		// Save result
		temp = isZero(value ^ 11) | isZero(inval) | temp;

		// Shift until just one 
		act = ~temp;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;

		value = adder(value, ~temp);

		// Save result
		temp = isZero(value ^ 11) | isZero(inval) | temp;

		// Shift until just one 
		act = ~temp;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;

		value = adder(value, ~temp);

		// Save result
		temp = isZero(value ^ 11) | isZero(inval) | temp;

		// Shift until just one 
		act = ~temp;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;

		value = adder(value, ~temp);

		// Save result
		temp = isZero(value ^ 11) | isZero(inval) | temp;

		// Shift until just one 
		act = ~temp;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;

		value = adder(value, ~temp);

		// Save result
		temp = isZero(value ^ 11) | isZero(inval) | temp;

		// Shift until just one 
		act = ~temp;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;

		value = adder(value, ~temp);

		// Save result
		temp = isZero(value ^ 11) | isZero(inval) | temp;

		// Shift until just one 
		act = ~temp;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;

		value = adder(value, ~temp);

		// Save result
		temp = isZero(value ^ 11) | isZero(inval) | temp;

		// Shift until just one 
		act = ~temp;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;

		value = adder(value, ~temp);

		// Save result
		temp = isZero(value ^ 11) | isZero(inval) | temp;

		// Shift until just one 
		act = ~temp;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;

		value = adder(value, ~temp);

		// Save result
		temp = isZero(value ^ 11) | isZero(inval) | temp;

		// Shift until just one 
		act = ~temp;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;

		value = adder(value, ~temp);

		// Save result
		temp = isZero(value ^ 11) | isZero(inval) | temp;

		// Shift until just one 
		act = ~temp;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;

		value = adder(value, ~temp);

		// Save result
		temp = isZero(value ^ 11) | isZero(inval) | temp;

		// Shift until just one 
		act = ~temp;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;

		value = adder(value, ~temp);

		// Save result
		temp = isZero(value ^ 11) | isZero(inval) | temp;

		// Shift until just one 
		act = ~temp;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;
		prevVal = value[0];
		value = shifter(value, act);
		act = ~prevVal & act;

		value = adder(value, ~temp);

		// Save result
		temp = isZero(value ^ 11) | isZero(inval) | temp;
	end
	
	assign divisible = temp;
endmodule 