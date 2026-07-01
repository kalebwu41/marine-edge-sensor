module threshold_comparator (
    input rst_n,
    input data_valid,
    input signed [15:0] accel_x,
    input signed [15:0] accel_y,
    input signed [15:0] accel_z,
    input signed [15:0] threshold,
    output reg impact_detected
);

    reg signed [15:0] abs_x;
    reg signed [15:0] abs_y;
    reg signed [15:0] abs_z;

    always @(*) begin
        abs_x = (accel_x < 0) ? (~accel_x + 1'b1) : accel_x;
        abs_y = (accel_y < 0) ? (~accel_y + 1'b1) : accel_y;
        abs_z = (accel_z < 0) ? (~accel_z + 1'b1) : accel_z;
    end
    always @(posedge data_valid or negedge rst_n) begin
        if (!rst_n) begin
            impact_detected <= 1'b0;
        end else if (data_valid)begin
            if ((abs_x > threshold) || (abs_y > threshold) || (abs_z > threshold)) begin
                impact_detected <= 1'b1;
            end else begin
                impact_detected <= 1'b0;
            end
        end else begin
            impact_detected <= 1'b0;
        end

    end


endmodule