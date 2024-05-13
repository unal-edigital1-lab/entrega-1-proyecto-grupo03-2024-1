module max7219_spi
#(parameter SIZE = 2)
(
    input clk,
    input reset_n,
    input [8*SIZE-1:0] address,//Registro de 8 bits
    input [8*SIZE-1:0] data,//Registro de 8 bits
    output finished,
    output reg mosi, cs
);
    
	reg [(16*SIZE)-1:0] buffer;//Registro de 16 bits
	reg load_en;
   reg enable;
   wire out;
	
	//LSHIFT_REG--------------------------------------------------lshift_reg_inst
	localparam COUNTER_SIZE = $clog2(16*SIZE);//4

	integer k;
	reg [(16*SIZE-1):0] buffer2;
	reg [COUNTER_SIZE-1:0] counter;

	always @(posedge clk or negedge reset_n)
		if (~reset_n)
			counter <= {(COUNTER_SIZE){1'b0}};
      else if (load_en)
         counter <= {(COUNTER_SIZE){1'b0}};
      else if (enable)
         counter <= counter + 1'b1;

	always @(posedge clk or negedge reset_n)
		if (~reset_n)
			buffer2 <= {(16*SIZE){1'b0}};
      else if (load_en)
         buffer2 <= buffer;
      else if (enable) begin
			for (k = 0; k < (16*SIZE-1); k = k + 1) begin
				buffer2[k+1] <= buffer2[k];
         end
         buffer2[0] <= 1'b0;
		end

	assign out = buffer2[16*SIZE-1];
	assign finished = (counter == (16*SIZE-1));
	//LSHIFT_REG++++++++++++++++++++++++++++++++++++++++++++++++++

	integer i;
	always @* begin
		//buffer[15 -: 8] = address[7 -: 8];
      //buffer[7 -: 8] = data[7 -: 8];
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

   always @(posedge clk or negedge reset_n)
       if (~reset_n)
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
		
			IDLE: begin //Inactividad o espera
				cs = 1;
            load_en = 0;
            mosi = 0;
            if (1'b1)
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
