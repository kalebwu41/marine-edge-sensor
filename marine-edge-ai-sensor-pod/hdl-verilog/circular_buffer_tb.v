//testbench for circular_buffer.v
module circular_buffer_tb(
    reg clk;
    reg rst_n;
    reg read_enable;

    reg write_enable,
    reg[7:0] data_out;

    wire [7:0] data_in;
    wire empty;
    wire buffer_full;
);
    circular_buffer uut(
        .clk(clk),
        .rst_n(rst_n),
        .read_enable(read_enable),
        .write_enable(write_enable),
        .read_addr(read_addr),
        .data_out(data_out),
        .data_in(data_in),
        .buffer_full(buffer_full)
        .empty(empty),


    );
    always #10 clk = ~ clk;
    initial begin
        clk = 0;
        rst_n = 0;
        read_enable = 0;
        write_enablew = 0;
        data_out = 0;

        #20;
        rst_n = 1;
    end
    data _in = 8'h11;
    write_enable = 1;
    #20;

    data_in = 8'h22;
    #20;

    data_in = 8'h33;
    #20;

    write_enable = 0;

    //read back
    #20;
    #20;
    #20;
    read_enable = 0;

endmodule;
