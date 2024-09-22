`include "src/oled_i2c_128x32/master_i2c.v"
`include "src/oled_i2c_128x32/ssd1306_master.v"

`timescale 1ns / 1ps // time scale - temporal precision

module top_oled (
    input clk,
    inout wire sda,
    inout wire scl
);

	wire [6:0] addr_byte_in;
    wire read_write;
    wire [7:0] control_byte_in;
    wire [7:0] data_byte_in;
	wire continue_bit;
    wire [3:0] state;
	wire [9:0] data_counter;

    master_i2c i2c (
		.clk(clk),
		.addr_byte_in(addr_byte_in),
		.read_write(read_write),
		.control_byte_in(control_byte_in),
		.data_byte_in(data_byte_in),
		.continue_bit(continue_bit),
		.sda(sda), 
		.scl(scl),
		.state(state),
		.data_counter(data_counter)
	);

    ssd1306_master setup (
        .clk(clk),
        .state(state),
		.data_counter(data_counter),
        .addr_byte_in(addr_byte_in),
		.read_write(read_write),
		.control_byte_in(control_byte_in),
		.data_byte_in(data_byte_in),
		.continue_bit(continue_bit)
    );

endmodule