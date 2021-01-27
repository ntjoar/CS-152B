`timescale 1ms/1ms
module lightcontroller_tb;
    reg clk;
    reg set;
    reg walk;
    reg sensor;

    wire Rs, Ys, Gs, Rm, Ym, Gm, w;

    initial begin
		clk = 1;
    end
    always #500 clk = ~clk;

    initial begin
        set = 1;
        #2000;
        set = 0;
	walk = 1;
	sensor = 1;
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

    lightcontroller MUT(set, clk, walk, sensor, Rm, Ym, Gm, Rs, Ys, Gs, w);
    
endmodule