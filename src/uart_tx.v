`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2026 15:21:33
// Design Name: 
// Module Name: uart_tx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module uart_tx(
    input clk,
    input tick,      // From our baud_gen
    input [7:0] data, 
    input start,
    output reg tx_pin,
    output reg ready
);
    reg [3:0] state = 0; // 0: Idle, 1: Start, 2: Data, 3: Stop
    reg [2:0] bit_count = 0;

    initial tx_pin = 1; // Idle high
    initial ready = 1;

    always @(posedge clk) begin
        if (ready && start) begin
            ready <= 0;
            state <= 1; // Move to Start Bit
        end

        if (tick) begin
            case (state)
                1: begin // Start Bit (Low)
                    tx_pin <= 0;
                    state <= 2;
                end
                2: begin // Data Bits
                    tx_pin <= data[bit_count];
                    if (bit_count == 7) begin
                        bit_count <= 0;
                        state <= 3;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end
                3: begin // Stop Bit (High)
                    tx_pin <= 1;
                    ready <= 1;
                    state <= 0;
                end
            endcase
        end
    end
endmodule
