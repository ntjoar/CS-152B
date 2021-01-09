/*
 * Register File for lab 1, part 3
 */

/* Using behavioral logic */
module register_file (
	input rst,
	input WrEn,
	input [15:0] busW,
	input [4:0] Ra,
	input [4:0] Rb,
	input [4:0] Rw,
	output [15:0] busA,
	output [15:0] busB
);

	reg [15:0] registerFile [0:31];

	integer i;
	always @(*) begin
		if(rst) begin
			for(i = 0; i < 32; i=i+1) begin
				registerFile[i] <= 0;
			end
		end else begin
			if (WrEn) begin
				registerFile[Rw] <= busW;
			end
		end
	end

	assign busA = registerFile[Ra];
	assign busB = registerFile[Rb];
endmodule