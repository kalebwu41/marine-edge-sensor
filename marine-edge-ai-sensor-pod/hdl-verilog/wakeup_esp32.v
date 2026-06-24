module wakeup_controller (
    input clk,
    output reg wakeup_pin
);
    always @(posedge clk) begin
        wakeup_pin <= 1'b1; 
    end
endmodule