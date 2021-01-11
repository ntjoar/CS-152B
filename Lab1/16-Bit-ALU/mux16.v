/*
 * Helping multiplexer for lab 1, part 2
 */

module mux16 (
	input [3:0] s,
	input in0,
	input in1,
	input in2,
	input in3,
	input in4,
	input in5,
	input in6,
	input in7,
	input in8,
	input in9,
	input in10,
	input in11,
	input in12,
	input in13,
	input in14,
	input in15,
	output val
);

	wire l0_1, l0_2, l0_3, l0_4, l0_5, l0_6, l0_7, l0_8,
		 l1_1, l1_2, l1_3, l1_4,
		 l2_1, l2_2,
		 l3_1;

	Two_to_One_Mux m0_1(in0, in1, s[0], l0_1);
	Two_to_One_Mux m0_2(in2, in3, s[0], l0_2);
	Two_to_One_Mux m0_3(in4, in5, s[0], l0_3);
	Two_to_One_Mux m0_4(in6, in7, s[0], l0_4);
	Two_to_One_Mux m0_5(in8, in9, s[0], l0_5);
	Two_to_One_Mux m0_6(in10, in11, s[0], l0_6);
	Two_to_One_Mux m0_7(in12, in13, s[0], l0_7);
	Two_to_One_Mux m0_8(in14, in15, s[0], l0_8);

	Two_to_One_Mux m1_1(l0_1, l0_2, s[1], l1_1);
	Two_to_One_Mux m1_2(l0_3, l0_4, s[1], l1_2);
	Two_to_One_Mux m1_3(l0_5, l0_6, s[1], l1_3);
	Two_to_One_Mux m1_4(l0_7, l0_8, s[1], l1_4);

	Two_to_One_Mux m2_1(l1_1, l1_2, s[2], l2_1);
	Two_to_One_Mux m2_2(l1_3, l1_4, s[2], l2_2);

	Two_to_One_Mux m3_1(l2_1, l2_2, s[3], l3_1);

	assign val = l3_1;

endmodule