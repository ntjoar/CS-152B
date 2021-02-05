`timescale 1ns/1ns
module resize_tb;
    reg clk;
    reg [31:0] bits_in;

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

    /* File handlers and data */
    integer data_file; // file handler
    integer write_data;
    reg [7:0] data;
    reg [7:0] out_buf [0:resize_size_up-1]; // Extra is fine, our params will handle

    wire [7:0] image_output;
    integer i;
    integer state;

    reg en;
    reg en_proc;
    reg rst;
    reg size;
    reg [31:0] resize_size;

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
        size = 1; // Change for sizing
        if(size) begin
            resize_size = resize_size_up;
        end else begin
            resize_size = resize_size_down;
        end
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
            if(i >= resize_size) begin
                state = 3;
            end
        end else begin // Write 
            for(i = 0; i < resize_size; i = i+1) begin
                if(i+1 == resize_size) begin
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
     * module low_pass (
     *  input rst,
     *  input [7:0] image_input,
     *  input enable,
     *  input enable_process,
     *  input clk, 
     *  input size,
     *  output [7:0] image_output
     * );
     */
     
    resize MUT(rst, data, en, en_proc, clk, size, image_output);
endmodule