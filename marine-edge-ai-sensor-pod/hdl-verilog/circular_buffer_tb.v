//testbench for circular_buffer.v
module circular_buffer(
    input sclk,
    input rst_n,
    input read_enable,

    input write_enable,
    input [7:0] read_addr,
    output reg[7:0] data_out,
    input [7:0] data_in,

    output reg buffer_full,
);
    circular_buffer uut(
        .clk(sclk),
        .rstn(rst_n),
        .read_enable(read_enable),
        .write_enable(write_enable),
        .read_addr(read_addr),
        .data_out(data_out),
        .data_in(data_in),
        .buffer_full(buffer_full)

    );
    always #10 sclk = ~ sclk;
    inital begin
        //signals 
        rst_n = 0;
    end

endmodule;
