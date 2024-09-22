`include "src/ads1115/i2c_ads1115.v"

`timescale 1ns / 1ps // time scale - temporal precision

module ssd1306_display_tb;

	// Inputs
	reg clk;
	reg [6:0] addr_byte_in;
    reg read_write;
    reg [7:0] register_byte_in;
    reg [7:0] data_byte_in;
	reg continue_bit;

	// Bidirs
	wire sda;
	wire scl;

	//Outputs
	wire [3:0] state;
	wire [9:0] data_counter;
	wire [15:0] read_bytesA0;

	i2c_ads1115 UUT_i2c_ads1115 (
		.clk(clk),
		.addr_byte_in(addr_byte_in),
		.read_write(read_write),
		.register_byte_in(register_byte_in),
		.data_byte_in(data_byte_in),
		.continue_bit(continue_bit),
		.sda(sda), 
		.scl(scl),
		.state(state),
		.data_counter(data_counter),
		.read_bytesA0(read_bytesA0)
	);
	
	initial begin
		clk = 0;
		forever begin
			clk = #10 ~clk;
		end		
	end

	initial begin

		$dumpfile("i2c_ads1115_tb.vcd");
		$dumpvars(-1, UUT_i2c_ads1115);

		// Initialize Inputs
		clk = 0;
		addr_byte_in = 7'b1001000;
		read_write = 0;
		register_byte_in = 8'b00000001;
		data_byte_in = 8'hC1;
		continue_bit = 0;
				
		#1000000
		$finish;
		
	end

endmodule