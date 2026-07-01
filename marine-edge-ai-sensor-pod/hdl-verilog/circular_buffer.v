module circular_buffer(
    input clk,
    input rst_n,
    input read_enable,
    input write_enable,
    output reg[7:0] data_out,
    input [7:0] data_in,
    output wire empty,
    output wire buffer_full
);


    //memory
    reg [7:0] mem [0:255];

    //point register to keep track of the write and read locations
    reg[7:0] wr_ptr;
    reg[7:0] rd_ptr;

    //occupancy
    reg[8:0] count; 
    reg[8:0] next_count;

    //status

    assign empty = (count == 9'd0);
    assign buffer_full = (count == 9'd256);
    

    always @(*) begin
        next_count = count;

        if (write_enable && !buffer_full) begin
            next_count = next_count + 1'b1;
        end

        if (read_enable && !empty) begin
            next_count = next_count - 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 8'h00;
            rd_ptr <= 8'h00;
            count <= 9'd0;
        end else begin
            if (write_enable && !buffer_full) begin
                mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1'b1;
            end

            if (read_enable && !empty) begin
                rd_ptr <= rd_ptr + 1'b1;
            end

            count <= next_count;
        end 

    end
    //combinational read block for microcontroller to read from the buffer
    always @(posedge clk) begin
        if (read_enable && !empty) begin
            data_out <= mem[rd_ptr];
        end
    end




endmodule