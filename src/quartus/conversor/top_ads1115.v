`timescale 1ns / 1ps // time scale - temporal precision

module top_ads1115 (
    input clk,
	 input wire sw,
    inout wire sda,
    inout wire scl,
	 output reg led1 = 1,
	 output reg led2 = 1,
	 output reg led3 = 1,
	 output reg led4 = 1
);

	wire [15:0] read_bytesA0;

	always @ (posedge clk) begin
		led4 <= sw;
		if (read_bytesA0 < 15'h0FA0 ||read_bytesA0 > 15'h7D00) begin
			led1 <= 0;
			led2 <= 1;
			led3 <= 1;
		end
		else if (read_bytesA0 > 15'h57E4) begin
			led1 <= 1;
			led2 <= 1;
			led3 <= 0;
		end
		else begin
			led1 <= 1;
			led2 <= 0;
			led3 <= 1;
		end
	end

	wire [6:0] addr_byte_in;
    wire read_write;
    wire [7:0] register_byte_in;
    wire [7:0] data_byte_in;
	wire continue_bit;
    wire [3:0] state;
	wire [9:0] data_counter;

    i2c_ads1115 UTT_i2c (
		.clk(clk),
		.addr_byte_in(addr_byte_in),
		.read_write(read_write),
		.register_byte_in(register_byte_in),
		.data_byte_in(data_byte_in),
		.continue_bit(continue_bit),
		.sda(sda), 
		.scl(scl),
		.only_register(only_register),
		.state(state),
		.data_counter(data_counter),
		.read_bytesA0(read_bytesA0)
	);

    ads1115_master UUT_setup (
        .clk(clk),
        .state(state),
		.data_counter(data_counter),
        .addr_byte_in(addr_byte_in),
		.read_write(read_write),
		.register_byte_in(register_byte_in),
		.data_byte_in(data_byte_in),
		.continue_bit(continue_bit),
		.only_register(only_register)
    );

endmodule