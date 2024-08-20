module max7219_display
#(parameter SIZE = 2)
(
    input clk,
    input reset_n,
    input [64 * SIZE - 1:0] pixels,
    output reg mosi,
    output reg cs
);
    
	localparam  noop        = 8'h00,

               digit0      = 8'h01,
               digit1      = 8'h02,
               digit2      = 8'h03,
               digit3      = 8'h04,
               digit4      = 8'h05,
               digit5      = 8'h06,
               digit6      = 8'h07,
               digit7      = 8'h08,

               decodeMode  = 8'h09,
               intensity   = 8'h0A,//10
               scanLimit   = 8'h0B,//11
               shutdown    = 8'h0C,//12
               displayTest = 8'h0F;//15
	
	reg [8*SIZE-1:0] address;//Registro de 16 bits
   reg [8*SIZE-1:0] data;//Registro de 16 bits
   wire finished;

	max7219_spi #(.SIZE(SIZE)) max7219_spi_inst
   (
		.clk(clk),
      .reset_n(reset_n),
      .address(address),
      .data(data),
      .mosi(mosi),
      .cs(cs),
      .finished(finished)
   );
	
	reg [5:0] state, nextState;

	localparam  S_SCAN_LIMIT = 8'd0,
               S_DECODE_MODE = 8'd1,
               S_SHUTDOWN = 8'd2,
               S_DISPLAY_TEST = 8'd3,
               S_INTENSITY = 8'd4,

               S_RESET_DIGIT0 = 8'd5,
               S_RESET_DIGIT1 = 8'd6,
               S_RESET_DIGIT2 = 8'd7,
               S_RESET_DIGIT3 = 8'd8,
               S_RESET_DIGIT4 = 8'd9,
               S_RESET_DIGIT5 = 8'd10,
               S_RESET_DIGIT6 = 8'd11,
               S_RESET_DIGIT7 = 8'd12,

               S_NOOP_RESET = 8'd13,

               S_DISPLAY_DIGIT0 = 8'd14,
               S_DISPLAY_DIGIT1 = 8'd15,
               S_DISPLAY_DIGIT2 = 8'd16,
               S_DISPLAY_DIGIT3 = 8'd17,
               S_DISPLAY_DIGIT4 = 8'd18,
               S_DISPLAY_DIGIT5 = 8'd19,
               S_DISPLAY_DIGIT6 = 8'd20,
               S_DISPLAY_DIGIT7 = 8'd21,

               S_NOOP_DISPLAY = 8'd22;

	always @(posedge clk or negedge reset_n)
		if (~reset_n)
			state <= S_SCAN_LIMIT;
		else
			state <= nextState;

	integer i;
	always @* begin
		nextState = state;
		i = 0;

		case (state)
			S_SCAN_LIMIT: begin
				address = {SIZE{scanLimit}};
            data = {SIZE{8'h07}};
            if (finished)
					nextState = S_DECODE_MODE;
            end
				
			S_DECODE_MODE: begin
            address = {SIZE{decodeMode}};
            data = {SIZE{8'h00}};
            if (finished)
               nextState = S_SHUTDOWN;
            end
				
			S_SHUTDOWN: begin
            address = {SIZE{shutdown}};
            data = {SIZE{8'h01}};
            if (finished)
               nextState = S_DISPLAY_TEST;
            end
				
         S_DISPLAY_TEST: begin
            address = {SIZE{displayTest}};
            data = {SIZE{8'h00}};
            if (finished)
					nextState = S_INTENSITY;
				end
				
         S_INTENSITY: begin
            address = {SIZE{intensity}};
            data = {SIZE{8'h02}};
            if (finished)
					nextState = S_RESET_DIGIT0;
            end

         S_RESET_DIGIT0: begin
            address = {SIZE{digit0}};
            data = {SIZE{8'h00}};
            if (finished)
					nextState = S_RESET_DIGIT1;
            end
				
         S_RESET_DIGIT1: begin
				address = {SIZE{digit1}};
            data = {SIZE{8'h00}};
            if (finished)
					nextState = S_RESET_DIGIT2;
            end
				
			S_RESET_DIGIT2: begin
            address = {SIZE{digit2}};
            data = {SIZE{8'h00}};
            if (finished)
					nextState = S_RESET_DIGIT3;
            end
				
			S_RESET_DIGIT3: begin
            address = {SIZE{digit3}};
            data = {SIZE{8'h00}};
            if (finished)
					nextState = S_RESET_DIGIT4;
            end
				
			S_RESET_DIGIT4: begin
            address = {SIZE{digit4}};
            data = {SIZE{8'h00}};
            if (finished)
               nextState = S_RESET_DIGIT5;
            end
         S_RESET_DIGIT5: begin
            address = {SIZE{digit5}};
            data = {SIZE{8'h00}};
            if (finished)
               nextState = S_RESET_DIGIT6;
            end
         S_RESET_DIGIT6: begin
            address = {SIZE{digit6}};
            data = {SIZE{8'h00}};
            if (finished)
               nextState = S_RESET_DIGIT7;
            end
			S_RESET_DIGIT7: begin
            address = {SIZE{digit7}};
            data = {SIZE{8'h00}};
            if (finished)
               nextState = S_NOOP_RESET;
            end
				
			S_NOOP_RESET: begin
            address = {SIZE{noop}};
            data = {SIZE{8'h00}};
            if (finished)
               nextState = S_DISPLAY_DIGIT0;
            end

         S_DISPLAY_DIGIT0: begin
            address = {SIZE{digit0}};
				
				for (i = 0; i < SIZE; i = i + 1) begin
					data[8 * (i + 1) - 1 -: 8] = pixels[64 * i + 64 - 1 -: 8];
            end
				
				for (i = 0; i < 8; i = i + 1) begin
					data[7-i] = pixels[0+i];
				end
				
				for (i = 0; i < 8; i = i + 1) begin
					data[23-i] = pixels[128+i];
				end

            if (finished)
					nextState = S_DISPLAY_DIGIT1;
            end
				
			S_DISPLAY_DIGIT1: begin
				address = {SIZE{digit1}};
				
				for (i = 0; i < SIZE; i = i + 1) begin
               data[8 * (i + 1) - 1 -: 8] = pixels[64 * i + 56 - 1 -: 8];
            end
				
				for (i = 0; i < 8; i = i + 1) begin
					data[7-i] = pixels[8+i];
				end
				
				for (i = 0; i < 8; i = i + 1) begin
					data[23-i] = pixels[136+i];
				end

            if (finished)
					nextState = S_DISPLAY_DIGIT2;
            end
				
			S_DISPLAY_DIGIT2: begin
            address = {SIZE{digit2}};
				
				for (i = 0; i < SIZE; i = i + 1) begin
					data[8 * (i + 1) - 1 -: 8] = pixels[64 * i + 48 - 1 -: 8];
            end

				for (i = 0; i < 8; i = i + 1) begin
					data[7-i] = pixels[16+i];
				end
				
				for (i = 0; i < 8; i = i + 1) begin
					data[23-i] = pixels[144+i];
				end

            if (finished)
               nextState = S_DISPLAY_DIGIT3;
            end
				
         S_DISPLAY_DIGIT3: begin
				address = {SIZE{digit3}};
				
				for (i = 0; i < SIZE; i = i + 1) begin
					data[8 * (i + 1) - 1 -: 8] = pixels[64 * i + 40 - 1 -: 8];
            end

				for (i = 0; i < 8; i = i + 1) begin
					data[7-i] = pixels[24+i];
				end
				
				for (i = 0; i < 8; i = i + 1) begin
					data[23-i] = pixels[152+i];
				end

            if (finished)
               nextState = S_DISPLAY_DIGIT4;
            end
				
			S_DISPLAY_DIGIT4: begin
				address = {SIZE{digit4}};
				
				for (i = 0; i < SIZE; i = i + 1) begin
					data[8 * (i + 1) - 1 -: 8] = pixels[64 * i + 32 - 1 -: 8];
            end

				for (i = 0; i < 8; i = i + 1) begin
					data[7-i] = pixels[32+i];
				end
				
				for (i = 0; i < 8; i = i + 1) begin
					data[23-i] = pixels[160+i];
				end

            if (finished)
					nextState = S_DISPLAY_DIGIT5;
				end
			
			S_DISPLAY_DIGIT5: begin
				address = {SIZE{digit5}};
				
				for (i = 0; i < SIZE; i = i + 1) begin
					data[8 * (i + 1) - 1 -: 8] = pixels[64 * i + 24 - 1 -: 8];
            end
				
				for (i = 0; i < 8; i = i + 1) begin
					data[7-i] = pixels[40+i];
				end
				
				for (i = 0; i < 8; i = i + 1) begin
					data[23-i] = pixels[168+i];
				end

            if (finished)
					nextState = S_DISPLAY_DIGIT6;
            end
				
			S_DISPLAY_DIGIT6: begin
				address = {SIZE{digit6}};
				
				for (i = 0; i < SIZE; i = i + 1) begin
					data[8 * (i + 1) - 1 -: 8] = pixels[64 * i + 16 - 1 -: 8];
            end

				for (i = 0; i < 8; i = i + 1) begin
					data[7-i] = pixels[48+i];
				end
				
				for (i = 0; i < 8; i = i + 1) begin
					data[23-i] = pixels[176+i];
				end

            if (finished)
               nextState = S_DISPLAY_DIGIT7;
            end
				
         S_DISPLAY_DIGIT7: begin
				address = {SIZE{digit7}};
				
				for (i = 0; i < SIZE; i = i + 1) begin
					data[8 * (i + 1) - 1 -: 8] = pixels[64 * i + 8 - 1 -: 8];
            end
				
				for (i = 0; i < 8; i = i + 1) begin
					data[7-i] = pixels[56+i];
				end
				
				for (i = 0; i < 8; i = i + 1) begin
					data[23-i] = pixels[184+i];
				end

            if (finished)
					nextState = S_NOOP_DISPLAY;
            end

			S_NOOP_DISPLAY: begin
            address = {SIZE{noop}};
            data = {SIZE{8'h00}};
            if (finished)
					nextState = S_NOOP_RESET;
            end

         default: nextState = S_SCAN_LIMIT;
		endcase
	end

endmodule
