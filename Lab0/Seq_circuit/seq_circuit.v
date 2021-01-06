/*
 * Sequential Circuit for lab 0, part 1
 */

module seq_circuit(
	input clk,
	input enable, 
	input load, 
	input up, 
	input clr, 
	input [3:0] d, 
	output [3:0] q, 
	output co
);
	reg[3:0] counter;
	reg carry;

	always @(posedge clk) begin
		if(clr == 1'b0) begin
			counter = 4'hx;
			carry = 1'b0;
		end else if(enable == 1'b1) begin
			if(load == 1'b1) begin
				counter = d;
				carry = 1'b0;
			end else if(up == 1'b1) begin
				if(q == 4'b0101) begin
					counter = 4'b0000;
					carry = 1'b1;
				end else begin
					counter = q + 1;
				end // q ==4'b0101
			end else begin 
				if(q == 4'b0000) begin
					counter = 4'b0000;
					carry = 1'b1;
				end else begin
					counter = q - 1;
				end // q ==4'b0101
			end
		end else begin
			counter <= q;
			carry <= co;
		end
	end

	assign q = counter;
	assign co = carry;

endmodule // seq_circuit