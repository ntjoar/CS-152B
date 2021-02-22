`timescale 1ns/1ns
module seg_dis_tb;
    reg clk;
    reg rst;

    reg [2:0] off;
    reg [2:0] l;
    reg [1:0] t;
    reg [18:0] value;
    
    wire [7:0] seg;
    wire [7:0] an;

    initial begin
        clk = 1;
        rst = 1;
        off = 0;
    end
    always #5 clk = ~clk;

    initial begin
        rst = 1;
        l = 0;
        t = 0;
        value = 0;
        #50;
        rst = 0;
        l = 0;
        t = 0;
        value = 0;
        #50;
        rst = 0;
        l = 2;
        t = 0;
        value = 0;
        #50;
        rst = 0;
        l = 2;
        t = 3;
        value = 0;
        #50;
        rst = 0;
        l = 0;
        t = 1;
        value = 123456;
        #50;
        rst = 0;
        l = 0;
        t = 2;
        value = 1234;
        #50;
    end

    always @(posedge clk) begin
        off = off + 1;
    end

    /* 
     * module seg_dis(
     *  input [2:0] offset,
     *  input [1:0] data_left,
     *  input [1:0] data_type,
     *  input [18:0] value_to_display,
     *  output [7:0] segment,
     *  output [7:0] anode
     * )
     */

    seg_dis MUT(off, l, t, value, seg, an);

endmodule
