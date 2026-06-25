// SPI: FROM AXL345(accelerometer) 
module spi_master (
    input clk, //internal heartbeat
    input rst_n, //active low reset
    input MISO, //master in slave out
    input start,//signals to refer to accelermeter
    input [6:0] addr,//address book
    output reg sclk, //clock signal for accelermeter
    output reg MOSI, //master out slave : in FPGA to accelermeter
    output reg cs_n, //accelermeter pays attention when this is low
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
            case(next_state)
                IDLE: begin
                    cs_n <= 1'b1;
                    sclk <= 1'b0;
                    if (start) begin
                        next_state <= START;
                    end
                end

                START: begin
                    cs_n <= 1'b0;
                    bit_count <= 4'd0;
                    //shift reg <=...
                end
                TRANSFER: begin
                    sclk <= ~sclk;//toggel clock
                    if (sclk == 1'b0) begin
                        MOSI <= shift_reg[15];
                        shift_reg <= shift_reg << 1;
                        bit_count <= bit_count + 1'b1;
                        
                    end
                    if (bit_count == 4'd15 && sclk == 1'b1) begin
                        next_state <= FINISH;
                    end
                end
                FINISH: begin
                    cs_n <= 1'b1;
                    data_valid <= 1'b1;
                    state <= IDLE;
                end

                default: begin
                    next_state <= IDLE;
                end 
            endcase
        end
    end
endmodule
            

