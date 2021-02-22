`timescale 1ns/1ns
module sonic_tb;
    reg clk;
    reg echo;
    reg start;
    reg [31:0] cnt;

    wire valid_data;
    wire trig;
    wire [18:0] data;

    initial begin
       echo = 0;
       clk = 1; 
       start = 0;
       cnt = 0;
    end
    always #5 clk = ~clk;
    initial begin
        echo = 0;
    end

    always @(posedge clk) begin
        if(~trig) begin
            start = 1;
        end

        if(start) begin
            cnt = cnt + 1;
            if(cnt == 100000) begin
                echo = 1;
                start = 0;
            end
        end else begin
            cnt = cnt + 1;
            if(cnt < 150000) begin
                echo = 1;
                start = 0;
            end else begin 
                echo = 0;
                start = 0;
            end
        end
    end

    /*
     * module sonic(
     *  input clk, 
     *  input ech,
     *  output trg,
     *  output [18:0] distance
     *  output good_data
     * );
     */

    sonic MUT(clk, echo, trig, data, valid_data);

endmodule