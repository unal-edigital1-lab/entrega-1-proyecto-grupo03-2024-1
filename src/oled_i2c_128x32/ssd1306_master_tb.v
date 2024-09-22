`include "src/oled_i2c_128x32/master_i2c.v"
`include "src/oled_i2c_128x32/ssd1306_master.v"

`timescale 1ns / 1ps // time scale - temporal precision

module ssd1306_display_tb;

	reg clk;
	wire [6:0] addr_byte_in;
    wire read_write;
    wire [7:0] control_byte_in;
    wire [7:0] data_byte_in;
	wire continue_bit;
    wire [3:0] state;
	wire [9:0] data_counter;

	// Bidirs
	wire sda;
	wire scl;

	master_i2c UUT_i2c (
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

    ssd1306_master UUT_setup (
        .clk(clk),
        .state(state),
		.data_counter(data_counter),
        .addr_byte_in(addr_byte_in),
		.read_write(read_write),
		.control_byte_in(control_byte_in),
		.data_byte_in(data_byte_in),
		.continue_bit(continue_bit)
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
		//control_byte_in = 8'b00000010;
		//data_byte_in = 8'b11111110;
		//continue_bit = 0;
				
		#100000000
		$finish;
		
	end

endmodule