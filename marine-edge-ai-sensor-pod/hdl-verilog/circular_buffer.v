module circular_buffer(
    input clk,
    input rst_n,

    input write_enable,
    input [7:0] read_addr,
    output reg[7:0] data_out,

    output reg buffer_full

);
    //buffer depth: 256 samples of 8 bit data
    reg [7:0] mem [0:255];

    //point regisrer to keep track of the write locations
    reg[7:0] wr_ptr;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 8'h00;
            buffer_full <= 1'b0;
        end else begin
            if (write_enable) begin
                mem[wr_ptr] <= data_in;

                if (wr_ptr == 8'hFF) begin
                    buffer_full <= 1'b1;
                end
                wr_ptr <= wr_ptr + 1'b1;
            end
        end
    end
    //combinational read block for microcontroller to read from the buffer
    always @(posedge clk) begin
        if (read_enable) begin
            data_out <= mem[read_addr];
        end
    end




endmodule