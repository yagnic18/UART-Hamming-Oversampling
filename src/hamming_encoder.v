`timescale 1ns / 1ps

module hamming_encoder(
    input  [7:0] data_in,
    output [11:0] code_out
);

// Hamming(12,8)
// Positions:
// 1,2,4,8 = parity bits
// others = data bits

assign code_out[2]  = data_in[0]; // position 3
assign code_out[4]  = data_in[1]; // position 5
assign code_out[5]  = data_in[2]; // position 6
assign code_out[6]  = data_in[3]; // position 7
assign code_out[8]  = data_in[4]; // position 9
assign code_out[9]  = data_in[5]; // position 10
assign code_out[10] = data_in[6]; // position 11
assign code_out[11] = data_in[7]; // position 12

// Parity bits
assign code_out[0] = code_out[2] ^ code_out[4] ^ code_out[6] ^ code_out[8] ^ code_out[10];
assign code_out[1] = code_out[2] ^ code_out[5] ^ code_out[6] ^ code_out[9] ^ code_out[10];
assign code_out[3] = code_out[4] ^ code_out[5] ^ code_out[6] ^ code_out[11];
assign code_out[7] = code_out[8] ^ code_out[9] ^ code_out[10] ^ code_out[11];

endmodule