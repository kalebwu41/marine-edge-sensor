module threshold_comparator_tb(
    reg signed [0:0] rst_n,
    reg signed [0:0] data_valid,
    reg signed [15:0] accel_x,
    reg signed [15:0] accel_y,
    reg signed [15:0] accel_z,
    reg signed [15:0] threshold,
    wire signed [0:0] impact_detected
    
);
    wire signed [15:0] abs_x;
    wire signed [15:0] abs_y;
    wire signed [15:0] abs_z;

    threshold_comparator uut(
        .rst_n(rst_n),
        .data_valid(data_valid),
        .accel_x(accel_x),
        .accel_y(accel_y),
        .accel_z(accel_z),
        .threshold(threshold),
        .impact_detected(impact_detected)
    );
    #20;
    initial begin
        rst_n = 0;
        data_valid = 0;
        accel_x = 16'sd0;
        accel_y = 16'sd0;
        accel_z = 16'sd0;
        threshold = 16'sd100;

        #20;
        rst_n = 1;

        // test case 1: No impact
        #20;
        data_valid = 1;
        accel_x = 16'sd50;
        accel_y = 16'sd30;
        accel_z = 16'sd20;

        #20;
        data_valid = 0;

        //test case 2: Impact detected on x-axis
        #20;
        data_valid = 1;
        accel_x = 16'sd150; // Exceeds threshold
        accel_y = 16'sd30;
        accel_z = 16'sd20;

        #20;
        data_valid = 0;

        // test case 3: impact detected on y-axis
        #20;
        data_valid = 1;
        accel_x = 16'sd50;
        accel_y = -16'sd200; // Exceeds threshold
        accel_z = 16'sd20;

        #20;
        data_valid = 0;

        // test case 4: impact detected on z-axis
        #20;
        data_valid = 1;
    end

endmodule;