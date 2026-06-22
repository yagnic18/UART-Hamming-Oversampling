`timescale 1ns / 1ps

module oversample_gen_16x(
    input clk,
    input reset,
    output reg sample_tick
);

    integer count = 0;

    // 100MHz / (9600 * 16) = 651
    parameter SAMPLE_COUNT = 651;

    always @(posedge clk) begin
        if(reset) begin
            count <= 0;
            sample_tick <= 0;
        end
        else if(count == SAMPLE_COUNT-1) begin
            count <= 0;
            sample_tick <= 1;
        end
        else begin
            count <= count + 1;
            sample_tick <= 0;
        end
    end

endmodule