`timescale 1ns / 1ps

module hamming_decoder(
    input [11:0] code_in,
    output reg [7:0] data_out,
    output reg error_detected,
    output reg error_corrected
);

reg [11:0] corrected_code;
reg [3:0] syndrome;

always @(*) begin

    // Default
    corrected_code = code_in;
    error_detected = 0;
    error_corrected = 0;

    // Calculate syndrome bits
    syndrome[0] = code_in[0] ^ code_in[2] ^ code_in[4] ^ code_in[6] ^ code_in[8] ^ code_in[10];
    syndrome[1] = code_in[1] ^ code_in[2] ^ code_in[5] ^ code_in[6] ^ code_in[9] ^ code_in[10];
    syndrome[2] = code_in[3] ^ code_in[4] ^ code_in[5] ^ code_in[6] ^ code_in[11];
    syndrome[3] = code_in[7] ^ code_in[8] ^ code_in[9] ^ code_in[10] ^ code_in[11];

    // If syndrome ≠ 0 → one-bit error exists
    if(syndrome != 0) begin
        error_detected = 1;

        // Correct the wrong bit
        corrected_code[syndrome-1] = ~corrected_code[syndrome-1];

        error_corrected = 1;
    end

    // Extract original data
    data_out[0] = corrected_code[2];
    data_out[1] = corrected_code[4];
    data_out[2] = corrected_code[5];
    data_out[3] = corrected_code[6];
    data_out[4] = corrected_code[8];
    data_out[5] = corrected_code[9];
    data_out[6] = corrected_code[10];
    data_out[7] = corrected_code[11];

end

endmodule