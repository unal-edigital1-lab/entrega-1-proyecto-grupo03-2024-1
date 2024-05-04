module max7219_spi
#(parameter SIZE = 2)
(
    input clk,
    input rst_n,
    input [8*SIZE-1:0] address,
    input [8*SIZE-1:0] data,
    input start,
    output finished,
    output reg mosi, cs
);
    
	reg [16*SIZE-1:0] buffer;
	reg load_en;
   reg enable;
   wire out;

	parameter SIZE_LS = SIZE*16;
	
	//LSHIFT_REG--------------------------------------------------lshift_reg_inst
	localparam COUNTER_SIZE = $clog2(SIZE_LS);

	integer j;
	reg [SIZE_LS-1:0] buffer2;

	reg [COUNTER_SIZE-1:0] counter;

	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			counter <= {COUNTER_SIZE{1'b0}};
      else if (load_en | (counter == SIZE_LS - 1))
         counter <= {COUNTER_SIZE{1'b0}};
      else if (enable)
         counter <= counter + 1'b1;

	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			buffer2 <= {SIZE_LS{1'b0}};
      else if (load_en)
         buffer2 <= buffer;
      else if (enable) begin
			for (j = 0; j < SIZE_LS - 1; j = j + 1) begin
                buffer2[j+1] <= buffer2[j];
         end
         buffer2[0] <= 1'b0;
		end

	assign out = buffer2[SIZE_LS-1];
	assign finished = (counter == SIZE_LS - 1);
	//LSHIFT_REG++++++++++++++++++++++++++++++++++++++++++++++++++

	integer i;
	always @* begin
		for (i = 0; i < SIZE; i = i + 1) begin
         buffer[(SIZE - i) * 16 - 1 -: 8] = address[(SIZE - i - 1) * 8 + 8 - 1 -: 8];
         buffer[(SIZE - i) * 16 - 8 - 1 -: 8] = data[(SIZE - i - 1) * 8 + 8 - 1 -: 8];
		end
	end

	// fsm
   localparam  IDLE   = 2'b00,
               START  = 2'b01,
               SEND   = 2'b10,
               FINISH = 2'b11;

   reg [1:0] state, nextState;

   always @(posedge clk or negedge rst_n)
       if (~rst_n)
			state <= IDLE;
       else
         state <= nextState;

	always @* begin
		nextState = state;
		cs = 1;
      load_en = 0;
      mosi = 0;
      enable = 0;

      case (state)
			IDLE: begin
				cs = 1;
            load_en = 0;
            mosi = 0;
            if (start)
					nextState = START;
         end
         START: begin
            nextState = SEND;
            mosi = 0;
            cs = 1;
            load_en = 1;
            enable = 0;
         end
         SEND: begin
            cs = 0;
            load_en = 0;
            mosi = out;
            enable = 1;
            if (finished)
					nextState = FINISH;
            end
         FINISH: begin
            cs = 1;
            mosi = 0;
            load_en = 0;
            enable = 0;
            nextState = START;
         end
         default: begin
				nextState = IDLE;
         end
		endcase
	end
	
endmodule
