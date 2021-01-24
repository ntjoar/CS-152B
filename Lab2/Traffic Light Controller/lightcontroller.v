/*
 * Light Controller for lab 2
 */

module lightcontroller (
    input rst,
    input clk,
	input walk_button,
    input sen,
    output Rm,
    output Ym,
    output Gm,
    output Rs,
    output Ys,
    output Gs,
    output walk
);

    /* Debouncing timer */
    // reg [26:0] sys_clk_timer;
    reg [3:0] seconds_passed;

    /* State machine */
    reg [2:0] state;

    /* Walk button triggered */
    reg walk_flag;

    /* Sensor tripped to high in first 6s of Main St Green or last second of Side St */
    reg sensor_flag;

    /* Switching parameters for state of movement */
    parameter [2:0] main_g = 3'b000;
    parameter [2:0] main_y = 3'b001;
    parameter [2:0] side_g = 3'b010;
    parameter [2:0] side_y = 3'b011;
    parameter [2:0] cross = 3'b100;

    /* Light temp registers */
    reg w;
    reg [2:0] main;
    reg [2:0] side;

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            state = 0;
            seconds_passed = 0;
            walk_flag = 0;
            sensor_flag = 0;
        end else begin
            if(walk_button) begin
                walk_flag = 1;
            end

            case (state)
                main_g: begin
                    if((seconds_passed == 11 && sensor_flag == 0) || (seconds_passed == 8 && sensor_flag == 1)) begin // -1 bc 0 is a second
                        seconds_passed = 0;
                        state = main_y; 
                        sensor_flag = 0;
                    end else begin
                        seconds_passed = seconds_passed + 1;
                        if(seconds_passed < 5 && sen == 1) begin
                            sensor_flag = 1;
                        end
                        state = main_g;
                    end
                end
                main_y: begin
                    if(seconds_passed == 1) begin // -1 bc 0 is a second
                        seconds_passed = 0;
                        if(walk_flag == 1) begin
                            state = cross;
                        end else begin
                            state = side_g; 
                        end
                    end else begin
                        seconds_passed = seconds_passed + 1;
                        state = main_y;
                    end
                end
                side_g: begin
                    if((seconds_passed == 5 && sensor_flag == 0) || (seconds_passed == 8 && sensor_flag == 1)) begin// -1 bc 0 is a second
                        seconds_passed = 0;
                        state = side_y; 
                        sensor_flag = 0;
                    end else begin
                        seconds_passed = seconds_passed + 1;
                        if(seconds_passed == 5 && sen == 1) begin // Sensor high at the end of side green state
                            sensor_flag = 1;
                        end
                        state = side_g;
                    end
                end
                side_y: begin
                    if(seconds_passed == 1) begin // -1 bc 0 is a second
                        seconds_passed = 0;
                        state = main_g; 
                    end else begin
                        seconds_passed = seconds_passed + 1;
                        state = side_y;
                    end
                end
                cross: begin
                    if(seconds_passed == 2) begin // -1 bc 0 is a second
                        seconds_passed = 0;
                        walk_flag = 0;
                        state = side_g; 
                    end else begin
                        seconds_passed = seconds_passed + 1;
                        state = cross;
                    end
                end
            endcase
        end
    end

    always @(state) begin
        case (state) 
            main_g: begin
                w = 0;
                main = 3'b001;
                side = 3'b100;
            end
            main_y: begin
                w = 0;
                main = 3'b010;
                side = 3'b100;
            end
            side_g: begin
                w = 0;
                main = 3'b100;
                side = 3'b001;
            end
            side_y: begin
                w = 0;
                main = 3'b100;
                side = 3'b010;
            end
            cross: begin
                w = 1;
                main = 3'b100;
                side = 3'b100;
            end
        endcase
    end

    assign walk = w;

    assign Rm = main[2];
    assign Ym = main[1];
    assign Gm = main[0];

    assign Rs = side[2];
    assign Ys = side[1];
    assign Gs = side[0];

endmodule