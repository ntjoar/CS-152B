`timescale 1ns/1ns
module lightcontroller_tb;
    reg clk;
    reg set;

    wire Rs, Ys, Gs, Rm, Ym, Gm, w;

    initial begin
		clk = 1;
    end
    always #5 clk = ~clk;

    initial begin
        set = 1;
        #15;
        set = 0;
        #1000;
        $stop;
    end

    /*
     * module lightcontroller (
     *  input rst,
     *  input clk,
     *  input walk_button,
     *  input sen,
     *  output Rm,
     *  output Ym,
     *  output Gm,
     *  output Rs,
     *  output Ys,
     *  output Gs,
     *  output walk
     * );
     */

    lightcontroller MUT(set, clk, 0, 1, Rm, Ym, Gm, Rs, Ys, Gs, w);
    
endmodule