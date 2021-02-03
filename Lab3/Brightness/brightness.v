/*
 * Brightness module for lab 
 */

module brightness (
    input rst,
    input [7:0] image_input,
    input enable,
    input enable_process,
    input clk, 
    input do_bright,
    input [7:0] bright,
    output [7:0] image_output
);

    `define NULL 0

    /* Image parameters, just using size of int_32 */
    parameter [31:0] Width = 1080; // width
    parameter [31:0] Depth = 1080; // length
    parameter [31:0] filter_size = Width*Depth;

    /* Image buffer */
    reg [7:0] filtered_image [0:filter_size-1];
    reg [31:0] bits_in_filter; // Is filter filled
    reg [31:0] bit_to_return; // Which bit are we returning

    /* Temp variables */
    integer i;
    reg [8:0] replacement;

    /* Do stuff here */ 
    always @(posedge clk, posedge rst) begin
        if(rst) begin 
            bits_in_filter = 0;
            bit_to_return = 0;
        end else if (enable) begin
            // While we have as many bits as in filter
            if(bits_in_filter < filter_size) begin
                filtered_image[bits_in_filter] = image_input;
                bits_in_filter = bits_in_filter + 1;
            end
        end else if (enable_process) begin
            if(bits_in_filter == filter_size) begin // only process if we have all the bits
                if(do_bright) begin // increment
                    replacement = filtered_image[bit_to_return] + bright;
                    if(replacement[8] == 1) begin // Overflow
                        replacement = 9'b011111111;
                    end
                end else begin // decrement
                    replacement = filtered_image[bit_to_return] - bright;
                    if(replacement[8] == 1) begin // Overflow
                        replacement = 0;
                    end
                end
                bit_to_return = bit_to_return + 1;
            end
        end
    end

    assign image_output = replacement[7:0];

endmodule