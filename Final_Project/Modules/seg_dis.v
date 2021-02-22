/*
 * Helper module to operate 7-segment display
 */

module seg_dis(
    input [2:0] offset,
    input [1:0] data_left,
    input [1:0] data_type,
    input [18:0] value_to_display,
    output [7:0] segment,
    output [7:0] anode
);

    reg [3:0] what_number;
    reg [2:0] equal_position;
    reg [7:0] seg_val;
    reg [7:0] an_val;

    reg [3:0] values [0:5];

    assign anode = an_val;
    assign segment = seg_val;

    always @(offset) begin
        if(data_left == 0) begin
            values[0] <= value_to_display % 10;
            values[1] <= (value_to_display % 100) / 10;
            values[2] <= (value_to_display % 1000) / 100;
            values[3] <= (value_to_display % 10000) / 1000;
            values[4] <= (value_to_display % 100000) / 10000;
            values[5] <= (value_to_display % 1000000) / 100000;

            if(value_to_display < 10) begin
                equal_position <= 1;
            end else if(value_to_display < 100) begin
                equal_position <= 2;
            end else if(value_to_display < 1000) begin
                equal_position <= 3;
            end else if(value_to_display < 10000) begin
                equal_position <= 4;
            end else if(value_to_display < 100000) begin
                equal_position <= 5;
            end else begin
                equal_position <= 6;
            end

            if(offset > equal_position) begin
                if(offset - 1 == equal_position) begin
                    if(data_type == 0) begin
                        what_number <= 11;
                    end else if(data_type == 1) begin
                        what_number <= 12;
                    end else begin
                        what_number <= 13;
                    end
                end else begin
                    what_number <= 15;
                end
            end else if(offset == equal_position) begin
                what_number <= 10;
            end else begin
                what_number <= values[offset];
            end
        end else begin
            what_number <= 14;
        end

        case(offset) 
            3'b000: begin
                an_val <= 8'b11111110;
            end
            3'b001: begin
                an_val <= 8'b11111101;
            end
            3'b010: begin
                an_val <= 8'b11111011;
            end
            3'b011: begin
                an_val <= 8'b11110111;
            end
            3'b100: begin
                an_val <= 8'b11101111;
            end
            3'b101: begin
                an_val <= 8'b11011111;
            end
            3'b110: begin
                an_val <= 8'b10111111;
            end
            3'b111: begin
                an_val <= 8'b01111111;
            end
        endcase
    end

    always @(what_number) begin
        case(what_number) 
            4'b0000: seg_val <= 8'b11000000; // 0
            4'b0001: seg_val <= 8'b11111001; // 1
            4'b0010: seg_val <= 8'b10100100; // 2
            4'b0011: seg_val <= 8'b10110000; // 3
            4'b0100: seg_val <= 8'b10011001; // 4
            4'b0101: seg_val <= 8'b10010010; // 5
            4'b0110: seg_val <= 8'b10000010; // 6
            4'b0111: seg_val <= 8'b11111000; // 7
            4'b1000: seg_val <= 8'b10000000; // 8
            4'b1001: seg_val <= 8'b10010000; // 9
            4'b1010: seg_val <= 8'b10110111; // =
            4'b1011: seg_val <= 8'b11000111; // L
            4'b1100: seg_val <= 8'b10001000; // A
            4'b1101: seg_val <= 8'b11000001; // V
            4'b1110: seg_val <= 8'b10111111; // -
            default: seg_val <= 8'b11111111; // <empty>
        endcase
    end

endmodule