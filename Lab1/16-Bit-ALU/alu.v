/*
 * ALU for lab 1, part 2
 */

module alu (
	input [3:0] ctrl,
	input [15:0] a,
	input [15:0] b,
	output [15:0] s,
	output zero,
	output overflow
);

	/* General use */
	wire carry;
	wire [15:0] outval;

	/* 
	 * Ctrl 0 - Subtraction (a-b) 
	 */
	wire [15:0] sub_value;
	wire sub_of;

	add16 n0(~b, 1, carry, outval);

	add16 n1(a, outval, carry, sub_value);
	assign sub_of = ((outval[15] & ~sub_value[15] & a[15]) | (~outval[15] & sub_value[15] & ~a[15])); // overflow

	/* 
	 * Ctrl 1 - Addition (a+b)
	 */
	wire [15:0] add_value;
	wire add_of;

	add16 a0(a, b, carry, add_value);
	assign add_of = ((a[15] & b[15] & ~add_value[15]) | 
			  (~a[15] & ~b[15] & add_value[15]));
	
	/* 
	 * Ctrl 2 - Bitwise OR (a|b)
	 */
	wire [15:0] or_value;
	wire or_of;

	assign or_value = a|b;
	assign or_of = 0;

	/* 
	 * Ctrl 3 - Bitwise AND (a&b)
	 */
	wire [15:0] and_value;
	wire and_of;

	assign and_value = a&b;
	assign and_of = 0;

	/* 
	 * Ctrl 4 - Decrement (a-1)
	 */
	wire [15:0] dec_value;
	wire dec_of;

	add16 d0(a, -1, carry, dec_value);
	assign dec_of = a[15] & ~dec_value[15];

	/* 
	 * Ctrl 5 - Increment (a+1)
	 */
	wire [15:0] inc_value;
	wire inc_of;

	add16 i0(a, 1, carry, inc_value);
	assign inc_of = ~a[15] & inc_value[15];

	/* 
	 * Ctrl 6 - Invert (~a)
	 */
	wire [15:0] inv_value;
	wire inv_of;

	assign inv_value = ~a;
	assign inv_of = 0;

	/* 
	 * Ctrl 9 - Less than or equal to (a <= b)
	 */
	wire [15:0] lte_value;
	wire lte_of;

	wire [15:0] lte_subval0;
	wire [15:0] lte_subval1;

	add16 l0(~b, 1, carry, lte_subval0);
	add16 l1(a, lte_subval0, carry, lte_subval1); // a-b

	assign lte_value[0] = (lte_subval1[15] | (a[15] & ~b[15]) | 
			       (~lte_subval1[15] & ~lte_subval1[14] & ~lte_subval1[13] & ~lte_subval1[12] &
				~lte_subval1[11] & ~lte_subval1[10] &  ~lte_subval1[9] &  ~lte_subval1[8] &
				 ~lte_subval1[7] &  ~lte_subval1[6] &  ~lte_subval1[5] &  ~lte_subval1[4] &
				 ~lte_subval1[3] &  ~lte_subval1[2] &  ~lte_subval1[1] &  ~lte_subval1[0]));
	assign lte_value[1] = 0;
	assign lte_value[2] = 0;
	assign lte_value[3] = 0;
	assign lte_value[4] = 0;
	assign lte_value[5] = 0;
	assign lte_value[6] = 0;
	assign lte_value[7] = 0;
	assign lte_value[8] = 0;
	assign lte_value[9] = 0;
	assign lte_value[10] = 0;
	assign lte_value[11] = 0;
	assign lte_value[12] = 0;
	assign lte_value[13] = 0;
	assign lte_value[14] = 0;
	assign lte_value[15] = 0;
	assign lte_of = 0;

	/* 
	 * Ctrl 8 - Logical shift left (a << b)
	 */
	wire [15:0] lsl_value;
	wire lsl_of;

	function [15:0] left_shifter;
		input [15:0] inval;

		reg [15:0] value;
		begin
			value[0] = 1'b0;
			value[1] = inval[0];
			value[2] = inval[1];
			value[3] = inval[2];
			value[4] = inval[3];
			value[5] = inval[4];
			value[6] = inval[5];
			value[7] = inval[6];
			value[8] = inval[7];
			value[9] = inval[8];
			value[10] = inval[9];
			value[11] = inval[10];
			value[12] = inval[11];
			value[13] = inval[12];
			value[14] = inval[13];
			value[15] = inval[14];
			left_shifter = value;
		end
	endfunction

	reg [15:0] left_shifts;

	integer i;
	always @(*) begin
		left_shifts = a;
		for(i = 0; i < b; i=i+1) begin
			left_shifts = left_shifter(left_shifts);
		end
	end

	assign lsl_value = left_shifts;
	assign lsl_of = (~a[15] & lsl_value[15]) | (a[15] & ~lsl_value[15]);

	/* 
	 * Ctrl 10 - Logical shift right (a >> b)
	 */
	wire [15:0] lsr_value;
	wire lsr_of;

	function [15:0] right_logic_shifter;
		input [15:0] inval;
	
		reg [15:0] value;
		begin
			value[15] = 1'b0;
			value[14] = inval[15];
			value[13] = inval[14];
			value[12] = inval[13];
			value[11] = inval[12];
			value[10] = inval[11];
			value[9] = inval[10];
			value[8] = inval[9];
			value[7] = inval[8];
			value[6] = inval[7];
			value[5] = inval[6];
			value[4] = inval[5];
			value[3] = inval[4];
			value[2] = inval[3];
			value[1] = inval[2];
			value[0] = inval[1];
			right_logic_shifter = value;
		end
	endfunction

	reg [15:0] right_logic;

	always @(*) begin
		right_logic = a;
		for(i = 0; i < b; i=i+1) begin
			right_logic = right_logic_shifter(right_logic);
		end
	end

	assign lsr_value = right_logic;
	assign lsr_of = (a[15] & ~right_logic[15]) | (~a[15] & right_logic[15]);

	/* 
	 * Ctrl 12 - Arithmetic shift left (a << b)
	 */
	wire [15:0] asl_value;
	wire asl_of;

	assign asl_value = left_shifts;
	assign asl_of = (~a[15] & asl_value[15]) | (a[15] & ~asl_value[15]);

	/* 
	 * Ctrl 14 - Arithmetic shift right (a >>> b)
	 */
	wire [15:0] asr_value;
	wire asr_of;

	function [15:0] right_arith_shifter;
		input [15:0] inval;
	
		reg [15:0] value;
		begin
			value[15] = inval[15];
			value[14] = inval[15];
			value[13] = inval[14];
			value[12] = inval[13];
			value[11] = inval[12];
			value[10] = inval[11];
			value[9] = inval[10];
			value[8] = inval[9];
			value[7] = inval[8];
			value[6] = inval[7];
			value[5] = inval[6];
			value[4] = inval[5];
			value[3] = inval[4];
			value[2] = inval[3];
			value[1] = inval[2];
			value[0] = inval[1];
			right_arith_shifter = value;
		end
	endfunction

	reg [15:0] right_arith;

	always @(*) begin
		right_arith = a;
		for(i = 0; i < b; i=i+1) begin
			right_arith = right_arith_shifter(right_arith);
		end
	end

	assign asr_value = right_arith;
	assign asr_of = 0;

/* Final MUX Gate output */
	wire [15:0] final_value;
	wire final_of;

	mux16 m0(ctrl, sub_value[0], add_value[0],  or_value[0], and_value[0], 
	               dec_value[0], inc_value[0], inv_value[0],         1'b0, 
	               lsl_value[0], lte_value[0], lsr_value[0],         1'b0,
	               asl_value[0],         1'b0, asr_value[0],         1'b0,
	               final_value[0]);
	mux16 m1(ctrl, sub_value[1], add_value[1],  or_value[1], and_value[1], 
	               dec_value[1], inc_value[1], inv_value[1],         1'b0, 
	               lsl_value[1], lte_value[1], lsr_value[1],         1'b0,
	               asl_value[1],         1'b0, asr_value[1],         1'b0,
	               final_value[1]);
	mux16 m2(ctrl, sub_value[2], add_value[2],  or_value[2], and_value[2], 
	               dec_value[2], inc_value[2], inv_value[2],         1'b0, 
	               lsl_value[2], lte_value[2], lsr_value[2],         1'b0,
	               asl_value[2],         1'b0, asr_value[2],         1'b0,
	               final_value[2]);
	mux16 m3(ctrl, sub_value[3], add_value[3],  or_value[3], and_value[3], 
	               dec_value[3], inc_value[3], inv_value[3],         1'b0, 
	               lsl_value[3], lte_value[3], lsr_value[3],         1'b0,
	               asl_value[3],         1'b0, asr_value[3],         1'b0,
	               final_value[3]);
	mux16 m4(ctrl, sub_value[4], add_value[4],  or_value[4], and_value[4], 
	               dec_value[4], inc_value[4], inv_value[4],         1'b0, 
	               lsl_value[4], lte_value[4], lsr_value[4],         1'b0,
	               asl_value[4],         1'b0, asr_value[4],         1'b0,
	               final_value[4]);
	mux16 m5(ctrl, sub_value[5], add_value[5],  or_value[5], and_value[5], 
               	   dec_value[5], inc_value[5], inv_value[5],         1'b0, 
               	   lsl_value[5], lte_value[5], lsr_value[5],         1'b0,
               	   asl_value[5],         1'b0, asr_value[5],         1'b0,
               	   final_value[5]);
	mux16 m6(ctrl, sub_value[6], add_value[6],  or_value[6], and_value[6], 
	               dec_value[6], inc_value[6], inv_value[6],         1'b0, 
	               lsl_value[6], lte_value[6], lsr_value[6],         1'b0,
	               asl_value[6],         1'b0, asr_value[6],         1'b0,
	               final_value[6]);
	mux16 m7(ctrl, sub_value[7], add_value[7],  or_value[7], and_value[7], 
	               dec_value[7], inc_value[7], inv_value[7],         1'b0, 
	               lsl_value[7], lte_value[7], lsr_value[7],         1'b0,
	               asl_value[7],         1'b0, asr_value[7],         1'b0,
	               final_value[7]);
	mux16 m8(ctrl, sub_value[8], add_value[8],  or_value[8], and_value[8], 
	               dec_value[8], inc_value[8], inv_value[8],         1'b0, 
	               lsl_value[8], lte_value[8], lsr_value[8],         1'b0,
	               asl_value[8],         1'b0, asr_value[8],         1'b0,
	               final_value[8]);
	mux16 m9(ctrl, sub_value[9], add_value[9],  or_value[9], and_value[9], 
	               dec_value[9], inc_value[9], inv_value[9],         1'b0, 
	               lsl_value[9], lte_value[9], lsr_value[9],         1'b0,
	               asl_value[9],         1'b0, asr_value[9],         1'b0,
	               final_value[9]);
	mux16 m10(ctrl, sub_value[10], add_value[10],  or_value[10], and_value[10], 
	               dec_value[10], inc_value[10], inv_value[10],         1'b0, 
	               lsl_value[10], lte_value[10], lsr_value[10],         1'b0,
	               asl_value[10],         1'b0, asr_value[10],         1'b0,
	               final_value[10]);
	mux16 m11(ctrl, sub_value[11], add_value[11],  or_value[11], and_value[11], 
	               dec_value[11], inc_value[11], inv_value[11],         1'b0, 
	               lsl_value[11], lte_value[11], lsr_value[11],         1'b0,
	               asl_value[11],         1'b0, asr_value[11],         1'b0,
	               final_value[11]);
	mux16 m12(ctrl, sub_value[12], add_value[12],  or_value[12], and_value[12], 
	               dec_value[12], inc_value[12], inv_value[12],         1'b0, 
	               lsl_value[12], lte_value[12], lsr_value[12],         1'b0,
	               asl_value[12],         1'b0, asr_value[12],         1'b0,
	               final_value[12]);
	mux16 m13(ctrl, sub_value[13], add_value[13],  or_value[13], and_value[13], 
	               dec_value[13], inc_value[13], inv_value[13],         1'b0, 
	               lsl_value[13], lte_value[13], lsr_value[13],         1'b0,
	               asl_value[13],         1'b0, asr_value[13],         1'b0,
	               final_value[13]);
	mux16 m14(ctrl, sub_value[14], add_value[14],  or_value[14], and_value[14], 
	               dec_value[14], inc_value[14], inv_value[14],         1'b0, 
	               lsl_value[14], lte_value[14], lsr_value[14],         1'b0,
	               asl_value[14],         1'b0, asr_value[14],         1'b0,
	               final_value[14]);
	mux16 m15(ctrl, sub_value[15], add_value[15],  or_value[15], and_value[15], 
               	   dec_value[15], inc_value[15], inv_value[15],         1'b0, 
               	   lsl_value[15], lte_value[15], lsr_value[15],         1'b0,
               	   asl_value[15],         1'b0, asr_value[15],         1'b0,
               	   final_value[15]);
	mux16 mof(ctrl, sub_of, add_of,  or_of, and_of, 
               	    dec_of, inc_of, inv_of,         1'b0, 
               	    lsl_of, lte_of, lsr_of,         1'b0,
               	    asl_of,         1'b0, asr_of,         1'b0,
               	    final_of);

    assign overflow = final_of;
    assign s = final_value;
    assign zero = ~((s[0])  | (s[1])  | (s[2])  | (s[3])  | 
    			    (s[4])  | (s[5])  | (s[6])  | (s[7])  | 
    			    (s[8])  | (s[9])  | (s[10]) | (s[11]) | 
    			    (s[12]) | (s[13]) | (s[14]) | (s[15]));

endmodule