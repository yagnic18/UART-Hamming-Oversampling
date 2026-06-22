`timescale 1ns / 1ps

module uart_tx_hamming(
    input clk,
    input tick,
    input start,
    input [11:0] data,
    output reg tx_pin,
    output reg ready
);

reg [3:0] state = 0;
reg [3:0] bit_count = 0;

initial begin
    tx_pin = 1;
    ready  = 1;
end

always @(posedge clk) begin

    // Start transmission
    if(ready && start) begin
        ready <= 0;
        state <= 1;
        bit_count <= 0;
    end

    if(tick) begin
        case(state)

            // Start bit
            1: begin
                tx_pin <= 0;
                state <= 2;
            end

            // Send 12 Hamming bits
            2: begin
                tx_pin <= data[bit_count];

                if(bit_count == 11) begin
                    bit_count <= 0;
                    state <= 3;
                end
                else begin
                    bit_count <= bit_count + 1;
                end
            end

            // Stop bit
            3: begin
                tx_pin <= 1;
                ready <= 1;
                state <= 0;
            end

        endcase
    end
end

endmodule