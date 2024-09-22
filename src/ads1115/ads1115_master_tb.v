`include "src/ads1115/i2c_ads1115.v"
`include "src/ads1115/ads1115_master.v"

`timescale 1ns / 1ps // time scale - temporal precision

module ssd1306_display_tb;

	reg clk;
	wire [6:0] addr_byte_in;
    wire read_write;
    wire [7:0] register_byte_in;
    wire [7:0] data_byte_in;
	wire continue_bit;
    wire [3:0] state;
	wire [9:0] data_counter;
	wire [15:0] read_bytesA0;

	// Bidirs
	wire sda;
	wire scl;

	i2c_ads1115 UUT_i2c (
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
	
	initial begin
		clk = 0;
		forever begin
			clk = #10 ~clk;
		end		
	end

	initial begin

		$dumpfile("master_i2c_tb.vcd");
		$dumpvars(-1, UUT_i2c);
        $dumpvars(-1, UUT_setup);

		// Initialize Inputs
		clk = 0;
		//addr_byte_in = 7'b0111100;
		//read_write = 0;
		//register_byte_in = 8'b00000010;
		//data_byte_in = 8'b11111110;
		//continue_bit = 0;
				
		#1000000
		$finish;
		
	end

endmodule