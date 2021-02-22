/*
 * Helper module to operate Ultrasonic sensor
 */

module sonic(
    input clk,
    input ech,
    output trg,
    output [18:0] distance,
    output good_data
);

    reg [18:0] dist;
    reg valid;

    reg [32:0] us_cnt = 0;
    reg trigger = 1'b0;

    reg [9:0] one_us_cnt = 0;
    wire one_us = (one_us_cnt == 0);

    reg [9:0] ten_us_cnt = 0;
    wire ten_us = (ten_us_cnt == 0);

    reg [21:0] forty_ms_cnt = 0;
    wire forty_ms = (forty_ms_cnt == 0);

    assign trg = trigger;
    assign distance = dist;
    assign good_data = valid;

    always @(posedge clk) begin
        one_us_cnt <= (one_us ? 50 : one_us_cnt) - 1;
        ten_us_cnt <= (ten_us ? 500 : ten_us_cnt) - 1;
        forty_ms_cnt <= (forty_ms ? 2000000 : forty_ms_cnt) - 1;
        
        if (ten_us && trigger) begin
            trigger <= 1'b0;
            valid <= 1;
        end
        
        if (one_us) begin	
            if (ech) begin
                us_cnt <= us_cnt + 1;
                valid <= 0;
            end
            else if (us_cnt) begin
                dist <= us_cnt / 58;
                valid <= 1;
                us_cnt <= 0;
            end
        end
        
    if (forty_ms)
        trigger <= 1'b1;
    end

endmodule