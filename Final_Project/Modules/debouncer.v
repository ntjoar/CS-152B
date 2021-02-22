/*
 * Debouncer module, 1-second
 */

module debouncer(
    input clk, 
    input btnIn,
    output wire btnOut
);

    reg [28:0] cntPressed = 0;
    reg btnO;

    assign btnOut = btnO;

    always @(posedge clk) begin
        if(btnIn == 1'b1) begin
            cntPressed <= cntPressed + 1'b1;
            btnO <= 1'b0;
        end
        else begin
            btnO <= 1'b0;
            if (cntPressed > 10000000)begin
                btnO <= 1'b1;
            end
            cntPressed <= 0;
        end
    end

endmodule