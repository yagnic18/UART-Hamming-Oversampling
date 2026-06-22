`timescale 1ns / 1ps

module tb_uart_hamming();

reg clk = 0;
reg reset = 1;
reg start = 0;

reg [7:0] data = 8'h41;

wire tick;
wire sample_tick;
wire tx_pin;
wire ready;

// Controlled error injection
reg inject_error;
wire rx_line;

// Hamming signals
wire [11:0] encoded_data;
wire [11:0] received_data;

wire [7:0] corrected_data;
wire error_detected;
wire error_corrected;

wire data_valid;


// Channel:
// normal path = tx_pin
// noise path = force HIGH
assign rx_line = (inject_error) ? 1'b1 : tx_pin;


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
    .data_in(data),
    .code_out(encoded_data)
);


// UART Hamming transmitter
uart_tx_hamming tx1(
    .clk(clk),
    .tick(tick),
    .start(start),
    .data(encoded_data),
    .tx_pin(tx_pin),
    .ready(ready)
);


// UART Hamming receiver
uart_rx_hamming rx1(
    .clk(clk),
    .reset(reset),
    .rx_pin(rx_line),
    .sample_tick(sample_tick),
    .rx_data(received_data),
    .data_valid(data_valid)
);


// Hamming decoder
hamming_decoder dec1(
    .code_in(received_data),
    .data_out(corrected_data),
    .error_detected(error_detected),
    .error_corrected(error_corrected)
);


// Clock generation
always #5 clk = ~clk;


initial begin

    inject_error = 0;

    // Reset
    #20;
    reset = 0;

    // Start transmission
    #100;
    start = 1;

    #10;
    start = 0;


    // --------------------------------------
    // Short glitch noise
    // Small edge noise
    // Oversampling should ignore
    // --------------------------------------
    #250000;
    inject_error = 1;

    // very short noise
    #10000;
    inject_error = 0;


    // --------------------------------------
    // Full-bit corruption
    // Hamming should correct
    // --------------------------------------
    #260000;
    inject_error = 1;

    // one-bit corruption
    #80000;
    inject_error = 0;


    // Wait until receiver completes
    @(posedge data_valid);

    // Hold waveform for observation
    #500000;

    $stop;

end

endmodule