module spi_master (
    input clk,            // internal heartbeat
    input rst_n,          // active low reset
    input MISO,           // master in slave out
    input start,          // signals to refer to accelerometer
    input [6:0] addr,     // address book
    output reg sclk,      // clock signal for accelerometer
    output reg MOSI,      // master out slave : in FPGA to accelerometer
    output reg cs_n,      // accelerometer pays attention when this is low
    output reg [7:0] data_out, // data from accelerometer
    output reg data_valid
);
    // state definitions
    localparam IDLE     = 2'b00;
    localparam START    = 2'b01;
    localparam TRANSFER = 2'b10;
    localparam FINISH   = 2'b11;

    reg [1:0] state, next_state; // state tracker
    reg [3:0] bit_count;        
    reg [15:0] shift_reg;

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            sclk      <= 1'b1; // SCLK idle high
            cs_n      <= 1'b1; // CS idle high
            MOSI      <= 1'b0;
            bit_count <= 4'd0;
            shift_reg <= 16'h0000;
        end else begin
            state <= next_state;
            
            if (state == START) begin
                bit_count <= 4'd0;
                shift_reg <= {1'b1, addr, 8'h00}; // Set R/W bit to 1 for Read
            end 
            else if (state == TRANSFER) begin
                sclk <= ~sclk; // toggle clock
                // Shift out data on the falling edge of SCLK
                if (sclk == 1'b0) begin 
                    MOSI      <= shift_reg[15];
                    shift_reg <= shift_reg << 1;
                    bit_count <= bit_count + 1'b1;
                end
            end
            else if (state == IDLE) begin
                bit_count <= 4'd0;
                sclk      <= 1'b1;
            end
        end
    end

    // Combinational logic
    always @* begin
        // Set defaults to prevent latches
        next_state = state;
        cs_n       = 1'b1;
        data_valid = 1'b0;
        data_out   = data_out; 

        case (state)
            IDLE: begin
                cs_n = 1'b1;
                if (start) begin
                    next_state = START;
                end
            end
            
            START: begin
                cs_n       = 1'b0;
                next_state = TRANSFER;
            end
            
            TRANSFER: begin
                cs_n = 1'b0;
                //wait until all 16 bits are shifted out before finishing
                if (bit_count == 4'd15 && sclk == 1'b1) begin
                    next_state = FINISH;
                end
            end
            
            FINISH: begin
                cs_n       = 1'b1;
                data_valid = 1'b1;
                data_out   = shift_reg[7:0]; // capture shifted-in data
                next_state = IDLE;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end
endmodule