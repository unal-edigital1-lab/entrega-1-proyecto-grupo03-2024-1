`include "src/fsm/top_fsm.v"

`timescale 1ns / 1ps // time scale - temporal precision

module hcsr04_tb;

	reg clk;
    reg btn_reset;
    reg btn_cancel;
    reg btn_test;
    reg btn_action;
    wire scl_display;
    wire sda_display;
    wire scl_converter;
    wire sda_converter;
    wire buzzer;
	wire trigger;

    top UUT (
        .clk(clk),
        .btn_reset(btn_reset),
        .btn_cancel(btn_cancel),
        .btn_test(btn_test),
        .btn_action(btn_action),
        .scl_display(scl_display),
        .sda_display(sda_display),
        .scl_converter(scl_converter),
        .sda_converter(sda_converter),
        .buzzer(buzzer),
        .trigger(trigger)
    );
	
	initial begin
		clk = 0;
		forever begin
			clk = #10 ~clk;
		end		
	end

	initial begin

		$dumpfile("top_fsm.vcd");
		$dumpvars(-1, UUT);

		clk = 0;
				
		#10000000
		$finish;
		
	end

endmodule