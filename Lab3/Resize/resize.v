/*
 * Resize filter module for lab 3
 */

module resize (
    input rst,
    input [7:0] image_input,
    input enable,
    input enable_process,
    input clk,
    input size,
    output [7:0] image_output
);

    `define NULL 0

    /* Image parameters, just using size of int_32 */
    parameter [31:0] Depth = 410; // width
    parameter [31:0] Width = 361; // length
    parameter [31:0] filter_size = Width*Depth;

    parameter [31:0] Size_Up_Depth = Depth * 2;
    parameter [31:0] Size_Up_Width = Width * 2;
    parameter [31:0] resize_size_up = Size_Up_Depth * Size_Up_Width;

    parameter [31:0] Size_Down_Depth = Depth / 2;
    parameter [31:0] Size_Down_Width = Width / 2;
    parameter [31:0] resize_size_down = Size_Down_Depth * Size_Down_Width;

    /* Image buffer */
    reg [7:0] filtered_image [0:filter_size-1];
    reg [31:0] bits_in_filter; // Is filter filled
    reg [31:0] bit_to_return; // Which bit are we returning

    /* Temp variables */
    reg [7:0] replacement;
    reg [11:0] average;

    reg [31:0] last_pos;
    reg [31:0] in_row;
    reg [31:0] in_col;
    reg [31:0] start;

    /* Do stuff here */ 
    always @(posedge clk, posedge rst) begin
        if(rst) begin 
            in_row = 0;
            in_col = 0;
            bits_in_filter = 0;
            bit_to_return = 0;
            last_pos = 0;
        end else if (enable) begin
            average = 0;
            // While we have as many bits as in filter
            if(bits_in_filter < filter_size) begin
                filtered_image[bits_in_filter] = image_input;
                bits_in_filter = bits_in_filter + 1;
            end
        end else if (enable_process) begin
            if(bits_in_filter == filter_size) begin // only process if we have all the bits
                /* We know the array is a single size (0->filter_size-1) */
                /* It goes down first and then by row */
                /* Will have to make the assumtion that the original image array in mat lab is width across and depth down */

                /* Size up/down */
                if(size) begin // size up
                    in_row = bit_to_return / Size_Up_Depth;
                    in_col = bit_to_return % Size_Up_Depth;

                    start = in_row/2 * Depth + in_col/2;
                    if(start >= filter_size) begin // Overwrite if error
                        start = last_pos;
                    end
                    last_pos = start;

                    replacement = filtered_image[start];
                end else begin // size down
                    if((bit_to_return % Size_Down_Depth) == 0) begin // Bit is in top row
                        start = 4 * bit_to_return;
                    end else begin // Increment by two positions
                        start = last_pos + 2;
                    end

                    last_pos = start; // Save last position

                    average = filtered_image[start] + filtered_image[start + 1] + filtered_image[start + Depth] + filtered_image[start + Depth + 1];
                    replacement = average/4;
                end
            end
            bit_to_return = bit_to_return + 1;
        end
    end

    assign image_output = replacement;

endmodule