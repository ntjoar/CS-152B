`timescale 1ms/1ms
module lightcontroller_tb;
    reg clk;
    reg set;

    wire Rs, Ys, Gs, Rm, Ym, Gm, w;

    initial begin
		clk = 1;
    end
    always #500 clk = ~clk;

    initial begin
        set = 1;
        #1500;
        set = 0;
        #10000;
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