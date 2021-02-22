/*
 * Helper Conversion module
 */

module conversion(
    input [18:0] data_in,
    input [1:0] convertTo,
    output [18:0] data_out
);

    reg [18:0] out;

    assign data_out = out;

    always @(*) begin
        case(convertTo) 
            2'b00: begin
                out <= data_in / 100;
            end
            2'b01: begin
                out <= data_in;
            end
            2'b10: begin
                out <= data_in / 30;
            end
            default: begin
                out <= data_in * 12 / 30;
            end
        endcase
    end

endmodule