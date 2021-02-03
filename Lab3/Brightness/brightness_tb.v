`timescale 1ns/1ns
module brightness_tb;
    reg clk;
    reg [31:0] bits_in;

    /* Image parameters, just using size of int_32 */
    parameter [31:0] Width = 1080; // width
    parameter [31:0] Depth = 1080; // length
    parameter [31:0] filter_size = Width*Depth;

    /* File handlers and data */
    integer data_file; // file handler
    integer write_data;
    reg [7:0] data;
    reg [7:0] out_buf [0:filter_size-1];

    wire [7:0] image_output;
    integer i;
    integer state;

    reg en;
    reg en_proc;
    reg rst;

    initial begin
        rst = 1;
        clk = 1;
        bits_in = 0;
        state = 0;
        data_file = $fopen("./noisy_image.text","r");
        write_data = $fopen("./filtered_image.text","w");
	    i = -1;
        en = 1;
        en_proc = 0;
    end
    always #5 clk = ~clk;
    initial begin
        rst = 1;
        #10;
        rst = 0;
    end
    always @(posedge clk) begin
        if(state == 0) begin // Write to register
            i = i + 1;
            if(!$feof(data_file) && i < filter_size) begin
                $fscanf(data_file, "%d,", data);
            end else begin
                state = 1;
                i = -1;
            end
        end else if(state == 1) begin
            i = i+1;
            if(i >= 2) begin
                state = 2;
                i = -1;
                en = 0;
                en_proc = 1;
            end
        end else if(state == 2) begin // Get process
            en = 0;
            en_proc = 1;
            out_buf[i] = image_output;
            i = i + 1;
            if(i >= filter_size) begin
                state = 3;
            end
        end else begin // Write 
            for(i = 0; i < filter_size; i = i+1) begin
                if(i+1 == filter_size) begin
                    $fwrite(write_data, "%d", out_buf[i]);
                end else begin
                    $fwrite(write_data, "%d,", out_buf[i]);
                end
            end

            $fclose(data_file);
            $fclose(write_data);
            $stop;
        end

    end

    /*
     * module brightness (
     *  input rst,
     *  input [7:0] image_input,
     *  input enable,
     *  input enable_process,
     *  input clk, 
     *  input do_bright,
     *  input [7:0] bright,
     *  output [7:0] image_output
     * );
     */

    brightness MUT(rst, data, en, en_proc, clk, 1, 20, image_output);
endmodule