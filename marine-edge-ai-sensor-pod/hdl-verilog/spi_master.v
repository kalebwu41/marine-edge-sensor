// SPI: FROM AXL345
module spi_master (
    input clk, //internal heartbeat
    input rst_n, //active low reset
    input MISO, //master in slave out
    input start,//signals to refer to accelermeter
    input [6:0] addr,//address book
    output reg sclk, //clock signal for accelermeter
    output reg MOSI, //master out slave : in FPGA to accelermeter
    output reg cs_n,
    output reg [7:0] data_out, //data from accelermeter
    output reg data_valid
);
    //state definitions
    localparam IDLE = 2'b00;
    localparam START = 2'b01;
    localparam TRANSFER = 2'b10;
    localparam FINISH = 2'b11;

    reg[1:0] state, next_state; //state tracker
    reg[3:0] bit_count; //holds up to 15, so when 
    reg[15:0] shift_reg;

    //every time th clocl ticks or when reset is asserted, the state machine will 
    //update its state and outputs accordingly.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            SCLK  <= 1'b1;//SLCK idle high
            cs_n <= 1'b1; //CS idle high
            MOSI <= 1'b0;
            data_out <= 8'b0;
            data_valid <= 1'b0;
            bit_count <= 0;
            shift_reg <= 0;
        end else begin
            state <= next_state;
            //finite machine state starts here.
        end
    end
endmodule
            

