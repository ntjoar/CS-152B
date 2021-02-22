`timescale 1ns/1ns
module conversion_tb;
    reg clk;
    reg [1:0] units;

    wire [18:0] out;

    initial begin
        clk = 1;
        units = 0;
    end
    always #5 clk = ~clk;
    initial begin
        units = 0;
        #20;
        units = 1;
        #20;
        units = 2;
        #20;
        units = 3;
        #20;
    end

    /*
     * module conversion(
     *  input [18:0] data_in, 
     *  input [1:0] convertTo,
     *  output [18:0] data_out
     * ); 
     */
    conversion MUT(130, units, out);
endmodule