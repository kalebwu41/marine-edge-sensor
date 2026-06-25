`timescale 1ns / 1ps

module spi_master_tb;

    //Inputs to the SPI Master (declared as reg so i can drive them)
    reg clk;
    reg rst_n;
    reg MISO;
    reg start;
    reg [6:0] addr;

    //outputs from the SPI Master (declared as wire)
    wire sclk;
    wire MOSI;
    wire cs_n;
    wire [7:0] data_out;
    wire data_valid;

    //Instantiate the unit under test
    spi_master uut (
        .clk(clk),
        .rst_n(rst_n),
        .MISO(MISO),
        .start(start),
        .addr(addr),
        .sclk(sclk),
        .MOSI(MOSI),
        .cs_n(cs_n),
        .data_out(data_out),
        .data_valid(data_valid)
    );

    //Generate a 50 MHz clock (20ns period -> 10ns high, 10ns low)
    always #10 clk = ~clk;

    // Test stimulus sequence
    initial begin
        //signals
        clk = 0;
        rst_n = 0;
        MISO = 0;
        start = 0;
        addr = 7'h32; // Example address (e.g., DATAX0 on ADXL345)

        //hold reset for a few cycles
        #40;
        rst_n = 1;
        
        // Wait then trigger the start pulse
        #20;
        start = 1;
        
        // hold the start pulse high for one cycle, then drop it
        #20;
        start = 0;

        // Provide a mock serial response on MISO for testing 
        @(negedge cs_n);
        
        #200; MISO = 1;
        #200; MISO = 0;
        #200; MISO = 1;
        #200; MISO = 0;
        #200; MISO = 1;
        #200; MISO = 1;
        #200; MISO = 0;
        #200; MISO = 0;

        @(posedge data_valid);
        #100;
        
        $finish;
    end
    //waveform dupmping
    initial begin
        $dumpfile("spi_master_tb.vcd");
        $dumpvars(0, spi_master_tb);
    end

endmodule