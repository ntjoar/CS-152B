`timescale 1ns/1ns
module debouncer_long_tb;
    reg clk;
    reg btnPress;

    wire btnOut;

    initial begin
        clk = 1;
        btnPress = 0;
    end
    always #5 clk = ~clk;
    initial begin
        btnPress = 1;
        #200;
        btnPress = 0;
        #10;
        btnPress = 1;
        #300000010;
        btnPress = 0;
    end

    /*
     * module debouncer_long(
     *  input clk, 
     *  input btnIn,
     *  output wire btnOut
     * ); 
     */
    debouncer_long MUT(clk, btnPress, btnOut);
endmodule