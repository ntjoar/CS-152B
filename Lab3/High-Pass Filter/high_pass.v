/*
 * High pass filter module for lab 3
 */

module high_pass (
    input rst,
    input [7:0] image_input,
    input enable,
    input enable_process,
    input clk,
    output [7:0] image_output
);

    `define NULL 0

    /* Image parameters, just using size of int_32 */
    parameter [31:0] Depth = 410; // width
    parameter [31:0] Width = 361; // length
    parameter [31:0] filter_size = Width*Depth;

    /* Image buffer */
    reg [7:0] filtered_image [0:filter_size-1];
    reg [31:0] bits_in_filter; // Is filter filled
    reg [31:0] bit_to_return; // Which bit are we returning

    /* Temp variables */
    reg [7:0] replacement;
    reg [7:0] window [0:8];
    reg [7:0] pos_filled;
    reg [11:0] average;
    integer i;

    /* Do stuff here */ 
    always @(posedge clk, posedge rst) begin
        if(rst) begin 
            bits_in_filter = 0;
            bit_to_return = 0;
            pos_filled = 0;
        end else if (enable) begin
            pos_filled = 0;
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
                /* 0 padding on the values around it */
                /* Will have to make the assumtion that the original image array in mat lab is width across and depth down */
                /* Resource used: https://diffractionlimited.com/help/maximdl/High-Pass_Filtering.htm */

                /* Check window */
                // Center bit
                window[0] = filtered_image[bit_to_return]; 
                pos_filled = 0;

                // Middle bit is on top row
                if((bit_to_return %  Depth) == 0) begin
                    window[1] = 0;
                    window[2] = 0;
                    window[3] = 0;
                    pos_filled[0] = 1;
                    pos_filled[1] = 1;
                    pos_filled[2] = 1;
                end

                // Middle bit is in left column
                if(bit_to_return < Depth) begin
                    window[1] = 0;
                    window[4] = 0;
                    window[6] = 0;
                    pos_filled[0] = 1;
                    pos_filled[3] = 1;
                    pos_filled[5] = 1;
                end

                // Middle bit is in right column
                if(bit_to_return > (filter_size - 1 - Depth)) begin
                    window[3] = 0;
                    window[5] = 0;
                    window[8] = 0;
                    pos_filled[2] = 1;
                    pos_filled[4] = 1;
                    pos_filled[7] = 1;
                end

                // Middle bit is in bottom row
                if((bit_to_return % Depth) == (Depth - 1)) begin
                    window[6] = 0;
                    window[7] = 0;
                    window[8] = 0;
                    pos_filled[5] = 1;
                    pos_filled[6] = 1;
                    pos_filled[7] = 1;
                end

                /* Assign window values missing */
                // Top Left
                if(pos_filled[0] == 1'b0) begin
                    window[1] = filtered_image[bit_to_return-1-Depth];
                end

                // Top Middle
                if(pos_filled[1] == 1'b0) begin
                    window[2] = filtered_image[bit_to_return-1];
                end

                // Top Right
                if(pos_filled[2] == 1'b0) begin
                    window[3] = filtered_image[bit_to_return-1+Depth];
                end

                // Mid Left
                if(pos_filled[3] == 1'b0) begin
                    window[4] = filtered_image[bit_to_return-Depth];
                end

                // Mid Right
                if(pos_filled[4] == 1'b0) begin
                    window[5] = filtered_image[bit_to_return+Depth];
                end

                // Bottom Left
                if(pos_filled[5] == 1'b0) begin
                    window[6] = filtered_image[bit_to_return+1-Depth];
                end

                // Bottom Middle
                if(pos_filled[6] == 1'b0) begin
                    window[7] = filtered_image[bit_to_return+1];
                end

                // Bottom Left
                if(pos_filled[7] == 1'b0) begin
                    window[8] = filtered_image[bit_to_return+1+Depth];
                end

                /* Averaging with values from high pass convolution network */
                /* Throw away corners and add up sides */
                average = window[2] + window[4] + window[5] + window[7];
                average = average / 4 * (-1); // Scale sides
                average = average + window[0] * 2; // add by a 2x scaled center pt.

                /* Copy avg */ 
                replacement = average[7:0]; // Should be low enough after division
            end
            bit_to_return = bit_to_return + 1;
        end
    end

    assign image_output = replacement;

endmodule