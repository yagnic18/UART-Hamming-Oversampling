`timescale 1ns / 1ps

module uart_hamming_top(
    input clk,
    input reset,
    input start,
    input [7:0] data_in,

    output tx_pin,
    output [7:0] data_out,
    output data_valid,
    output error_detected,
    output error_corrected
);

// Internal wires
wire tick;
wire sample_tick;

wire [11:0] encoded_data;
wire [11:0] received_data;


// Baud generator
baud_gen b1(
    .clk(clk),
    .reset(reset),
    .tick(tick)
);


// 16x oversampling generator
oversample_gen_16x os1(
    .clk(clk),
    .reset(reset),
    .sample_tick(sample_tick)
);


// Hamming encoder
hamming_encoder enc1(
    .data_in(data_in),
    .code_out(encoded_data)
);


// UART transmitter
uart_tx_hamming tx1(
    .clk(clk),
    .tick(tick),
    .start(start),
    .data(encoded_data),
    .tx_pin(tx_pin),
    .ready()
);


// UART receiver
uart_rx_hamming rx1(
    .clk(clk),
    .reset(reset),
    .rx_pin(tx_pin),     // loopback connection
    .sample_tick(sample_tick),
    .rx_data(received_data),
    .data_valid(data_valid)
);


// Hamming decoder
hamming_decoder dec1(
    .code_in(received_data),
    .data_out(data_out),
    .error_detected(error_detected),
    .error_corrected(error_corrected)
);

endmodule