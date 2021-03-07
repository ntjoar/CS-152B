/*
 * Overall Dimensional Module
 */

module crypto_dimension(
    input clk,
    input btns,
    input btnr,
    input btnd,
    input btnl,
    input btnu,
    input rst,
    input echo,
    input [15:0] sw,
    output led16_b,
    output led16_g,
    output led16_r,
    output led17_b,
    output led17_g,
    output led17_r,
    output trig,
    output [15:0] Led,
    output wire [7:0] seg,
    output wire [7:0] an
);

    /*
     * Resources Used:
     * HC-SR04 Datasheet: https://cdn.sparkfun.com/datasheets/Sensors/Proximity/HCSR04.pdf
     * Nexys A7 Datasheet: https://reference.digilentinc.com/reference/programmable-logic/nexys-a7/reference-manual
     * Vivado Design Suite: https://www.xilinx.com/support/documentation/sw_manuals/xilinx2018_2/ug910-vivado-getting-started.pdf
     * Verilog: http://www.asic-world.com/verilog/index.html
     * Voltage Divider: https://learn.sparkfun.com/tutorials/voltage-dividers/all
     * Speed of Sound: https://www.grc.nasa.gov/www/k-12/airplane/sound.html
     */

    /* For Display */
    reg [19:0] disp_counter;
    reg [2:0] offset;
    reg [18:0] good_data;
    reg [18:0] display_data = 0;
    reg [18:0] orig_data = 0;
    reg [1:0] dat;

    /* Connecting wires */
    wire [18:0] data; // Ultrasonic Sensor
    wire valid_data;
    wire s, r, d, l, u, d_long;

    /* Authentication */
    reg [15:0] pw = 0;
    reg auth = 0;
    reg [15:0] led_mask = 0;
    reg [15:0] enc_mask = 6000;

    /* Need to measure */
    reg [1:0] measurements_left = 0;

    /* States */
    reg [1:0] units = 0;
    reg [1:0] dimension;

    /* Units Params */
    parameter [1:0] meters = 0;
    parameter [1:0] centimeters = 1;
    parameter [1:0] feet = 2;
    parameter [1:0] inches = 3;
    reg [2:0] l16;
    reg [2:0] l17;

    /* Storage */
    reg [18:0] storage [0:99];
    reg [18:0] dimension_data [0:2];
    reg [6:0] storage_id = 0;
    reg [6:0] current = -1;
    reg [1:0] dimension_id = 0;
    reg [6:0] storage_size = 0;
    integer i;

    /* Assignments */
    assign Led = sw & led_mask;
    assign led16_b = l16[2];
    assign led16_g = l16[1];
    assign led16_r = l16[0];
    assign led17_b = l17[2];
    assign led17_g = l17[1];
    assign led17_r = l17[0];

    always @(posedge clk) begin
        if(~rst) begin
            offset <= -1;
            disp_counter <= -1;
            good_data <= 0;
            units <= 0;
            pw <= 0;
            auth <= 0;
            led_mask <= 0;
            dimension <= 0;
            units <= 0;
            display_data <= 0;
            orig_data <= 0;
            storage_id <= 0;
            current <= -1;
            dimension_id <= 0;
            storage_size <= 0;
            enc_mask <= 5000;
        end else begin
            disp_counter <= disp_counter + 1;
            offset <= disp_counter[19:17];

            /* Store data */
            if(valid_data) begin
                good_data <= data;
            end

            /* Handle units */
            if(r && auth) begin
                current = storage_id - 1;
                dimension_id = 0;
                units <= sw[1:0];
            end

            case(units)
                meters: begin
                    if(l16 == 3'b010) begin
                        l16 <= 3'b000;
                        l17 <= 3'b000;
                    end else begin
                        l16 <= 3'b010;
                        l17 <= 3'b010;
                    end
                end
                centimeters: begin
                    if(l16 == 3'b010) begin
                        l16 <= 3'b000;
                        l17 <= 3'b000;
                    end else begin
                        l16 <= 3'b010;
                        l17 <= 3'b100;
                    end
                end
                feet: begin
                    if(l16 == 3'b100) begin
                        l16 <= 3'b000;
                        l17 <= 3'b000;
                    end else begin
                        l16 <= 3'b100;
                        l17 <= 3'b100;
                    end
                end
                inches: begin
                    if(l16 == 3'b100) begin
                        l16 <= 3'b000;
                        l17 <= 3'b000;
                    end else begin
                        l16 <= 3'b100;
                        l17 <= 3'b010;
                    end
                end
                default: begin // Error
                    if(l16 == 3'b001) begin
                        l16 <= 3'b000;
                        l17 <= 3'b000;
                    end else begin
                        l16 <= 3'b001;
                        l17 <= 3'b001;
                    end
                end
            endcase

            /* Handle Dimension Change */
            if(l && auth) begin
                current = storage_id - 1;
                dimension_id = 0;
                if(3 == dimension) begin
                    dimension <= 0;
                end else begin
                    dimension <= dimension + 1;
                end
            end

            case(dimension)
                2'b00: measurements_left <= 1;
                2'b01: measurements_left <= 2;
                2'b10: measurements_left <= 3;
                default: measurements_left <= 0;
            endcase

            /* Handle authentication */
            if(d_long && auth) begin // Log out and change pw
                pw <= sw;
                auth = 0;
                led_mask <= 0;
                enc_mask = good_data ^ orig_data;
            end else if(d || d_long) begin // Log in/out
                if(~auth && pw == sw) begin
                    auth = 1;
                    led_mask <= -1;
                    enc_mask = 0;
                end else begin
                    auth = 0;
                    led_mask <= 0;
                    enc_mask = good_data ^ orig_data;
                end
            end

            /* Access history */
            if(u && auth) begin 
                if(current - 1> storage_size) begin
                    current =  storage_size - 1;
                end else begin
                    current = current - 1;
                end
            end

            /* Handle save data */
            if(s && auth) begin
                // orig_data = good_data;
                if(units == meters) begin
                    dimension_data[dimension_id] = (good_data / 100);
                end else if(units == centimeters) begin
                    dimension_data[dimension_id] = good_data;
                end else if(units == feet) begin
                    dimension_data[dimension_id] = good_data / 30;
                end else begin
                    dimension_data[dimension_id] = good_data * 12 / 30;
                end
                dimension_id = dimension_id + 1;
                dat <= measurements_left - dimension_id;
                if(dimension_id >= measurements_left) begin // Change data display and store in our history
                    if(measurements_left == 1) begin
                        orig_data = dimension_data[0];
                    end else if(measurements_left == 2) begin
                        orig_data = dimension_data[0] * dimension_data[1];
                    end else begin 
                        orig_data = dimension_data[0] * dimension_data[1] * dimension_data[2];
                    end
                    dimension_id = 0;
                    storage[storage_id] = orig_data;
                    storage_id = storage_id + 1;
                    if(storage_size < 100) begin
                        storage_size = storage_size + 1;
                    end

                    if(storage_id == 100) begin // loop back
                        storage_id = 0;
                    end
                end
                if(storage_id != 0) begin
                    current = storage_id - 1;
                end else begin 
                    current = 0;
                end
            end

            display_data = storage[current] ^ enc_mask;
        end
    end

    /*
     * module debouncer(
     *  input clk, 
     *  input btnIn,
     *  output wire btnOut
     * ); 
     */
    debouncer dbs(clk, btns, s);
    debouncer dbr(clk, btnr, r);
    debouncer dbd(clk, btnd, d);
    debouncer dbl(clk, btnl, l);
    debouncer dbu(clk, btnu, u);

    /*
     * module debouncer_long(
     *  input clk, 
     *  input btnIn,
     *  output wire btnOut
     * ); 
     */
    debouncer_long dbd_long(clk, btnd, d_long);

    /*
     * module sonic(
     *  input clk, 
     *  input ech,
     *  output trg,
     *  output [18:0] distance
     *  output good_data
     * );
     */
    sonic MEASUREMENT(clk, echo, trig, data, valid_data);

    /* 
     * module seg_dis(
     *  input [2:0] offset,
     *  input [1:0] data_left,
     *  input [1:0] data_type,
     *  input [18:0] value_to_display,
     *  output [7:0] segment,
     *  output [7:0] anode
     * );
     */
    seg_dis DISP_SEG(offset, dat, dimension, display_data, seg, an);

endmodule