`timescale 1ns / 1ps

module uart_rx_hamming(
    input clk,
    input reset,
    input rx_pin,
    input sample_tick,
    output reg [11:0] rx_data,
    output reg data_valid
);

reg receiving;
reg start_phase;
reg [3:0] sample_count;
reg [3:0] bit_index;
reg [11:0] temp_data;

always @(posedge clk) begin
    if(reset) begin
        receiving    <= 0;
        start_phase  <= 0;
        sample_count <= 0;
        bit_index    <= 0;
        temp_data    <= 0;
        rx_data      <= 0;
        data_valid   <= 0;
    end
    else begin
        data_valid <= 0;

        if(sample_tick) begin

            // Detect start bit
            if(!receiving && !start_phase && rx_pin == 0) begin
                start_phase <= 1;
                sample_count <= 0;
            end

            // Half-bit align
            else if(start_phase) begin
                sample_count <= sample_count + 1;

                if(sample_count == 7) begin
                    start_phase <= 0;
                    receiving <= 1;
                    sample_count <= 0;
                    bit_index <= 0;
                    temp_data <= 0;
                end
            end

            // Receive 12 Hamming bits
            else if(receiving) begin
                sample_count <= sample_count + 1;

                if(sample_count == 7) begin
                    temp_data[bit_index] <= rx_pin;
                end

                if(sample_count == 15) begin
                    sample_count <= 0;

                    if(bit_index == 11) begin
                        receiving <= 0;

                        // Final received 12-bit code
                        rx_data <= {rx_pin, temp_data[10:0]};

                        data_valid <= 1;
                        bit_index <= 0;
                    end
                    else begin
                        bit_index <= bit_index + 1;
                    end
                end
            end
        end
    end
end

endmodule