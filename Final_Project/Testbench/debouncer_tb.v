`timescale 1ns/1ns
module debouncer_tb;
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
        #100000010;
        btnPress = 0;
    end

    /*
     * module debouncer(
     *  input clk, 
     *  input btnIn,
     *  output wire btnOut
     * ); 
     */
    debouncer MUT(clk, btnPress, btnOut);
endmodule