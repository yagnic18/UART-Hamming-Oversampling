`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2026 15:18:51
// Design Name: 
// Module Name: baud_gen
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


module baud_gen(
    input clk,       // System clock (100MHz)
    input reset,     
    output reg tick  // This pulses once per bit period
);
    // 100MHz / 9600 baud = 10416.6 cycles
    integer count = 0;

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
            tick <= 0;
        end else if (count == 10416) begin
            count <= 0;
            tick <= 1;
        end else begin
            count <= count + 1;
            tick <= 0;
        end
    end
endmodule