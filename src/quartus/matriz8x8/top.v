module top(
	input clk,
	input rst,
	output sck,
	output din,
	output cs
);
	
	//Sincroniza la señal de reinicio (rst) con el reloj del sistema (clk
	wire reset_n;
	reg [1:0] sync_reg;

   always @(posedge clk)
   begin
		sync_reg[0] <= rst;
      sync_reg[1] <= sync_reg[0];
   end

   assign reset_n = sync_reg[1];

	//Crea un relog (sck) sincronizado con (clk) a un rate especifica
	pll pll_inst
	(
		.inclk0(clk),
		.c0(sck)
	);
	
	localparam DISPLAY_PAUSE = 6250000; // 78125; // 390625; // 781250; // 3125000; // 6250000;
	localparam DISPLAY_PAUSE_W = $clog2(DISPLAY_PAUSE); //#bits necesarios para representar DISPLAY_PAUSE

	reg [DISPLAY_PAUSE_W-1:0] cnt_period; //Cuenta el tiempo durante la pausa de visualización

	always @(posedge clk or negedge reset_n)
		if (!reset_n)
			cnt_period <= 0;
		else if (cnt_period == (DISPLAY_PAUSE - 1))
			cnt_period <= 0;
		else
			cnt_period <= cnt_period + 1'b1;

	reg enable; //Habilita el cambio de columna durante el tiempo de pausa DISPLAY_PAUSE
	always @(posedge clk or negedge reset_n)
		begin
			if (!reset_n)
				enable <= 1'b0;
			else if (cnt_period == (DISPLAY_PAUSE - 1))
				enable <= 1'b1;
			else
				enable <= 1'b0;
			end

//PROVIDER----------------------------------------------------provider_inst
	
	reg [7:0] col;
	reg [7:0] address, next_address;
	reg [2:0] row_cnt;//7 columnas -> desplazamiento col
	reg [3:0] state, next_state;//fsm -> 15 estados
	reg [63:0] pixels;
	
	//Estados para la maquina de estados
	localparam  S0 = 4'd0,
               S1 = 4'd1,
               S2 = 4'd2,
               S3 = 4'd3,
               S4 = 4'd4,
               S5 = 4'd5,
               S6 = 4'd6,
               S7 = 4'd7,
               S8 = 4'd8,
               S9 = 4'd9,
               S10 = 4'd10,
               S11 = 4'd11,
               S12 = 4'd12,
               S13 = 4'd13,
               S14 = 4'd14,
               S15 = 4'd15;

	initial begin
		state = S0;
		next_state = S1;
		address = 8'd127;
		next_address = 8'd127;
		row_cnt = 0;
	end

	always @(posedge clk or negedge reset_n)
		if (~reset_n) begin
			address <= 8'd127;
         row_cnt <= 0;
         state <= S0;
      end
      else if (enable) begin
			row_cnt <= row_cnt + 1'b1;
         if (row_cnt == 3'b111) begin
				address <= next_address;
            state <= next_state;
			end
		end

	always @* begin
      case(state)
			S0: begin next_state = S1; next_address = 8'd65; end //H
         S1: begin next_state = S2; next_address = 8'd66; end //E
         S2: begin next_state = S3; next_address = 8'd67; end //L
         S3: begin next_state = S4; next_address = 8'd68; end //L
         S4: begin next_state = S5; next_address = 8'd69; end //O
         S5: begin next_state = S6; next_address = 8'd70; end //,
         S6: begin next_state = S7; next_address = 8'd71; end // 
         S7: begin next_state = S8; next_address = 8'd72; end //W
         S8: begin next_state = S9; next_address = 8'd73; end //O
         S9: begin next_state = S10; next_address = 8'd74; end //R
         S10: begin next_state = S11; next_address = 8'd75; end //L
         S11: begin next_state = S12; next_address = 8'd76; end //D
         S12: begin next_state = S13; next_address = 8'd77; end //!
         S13: begin next_state = S14; next_address = 8'd78; end //! 
         S14: begin next_state = S15; next_address = 8'd32; end // 
         S15: begin next_state = S0; next_address = 8'd32; end // 
		endcase
	end

	//ROM---------------------------------------------------------
	
	parameter LENGTH = 128;//Cantidad registros
	parameter WIDTH = 64;//Longitud de cada registro
	
	reg [WIDTH-1:0] mem[LENGTH-1:0];//Banco con 128 registros de tamaño 64

	initial begin
		$readmemh("ascii.hex", mem);
	end

	always @(posedge clk) begin
		pixels <= mem[address];
	end
	
	//ROM+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	always @* begin
		case (row_cnt)
			3'd0: begin
				col = {pixels[56], pixels[48],  pixels[40], pixels[32], pixels[24], pixels[16], pixels[8], pixels[0]};
			end
			3'd1: begin
				col = {pixels[57], pixels[49],  pixels[41], pixels[33], pixels[25], pixels[17], pixels[9], pixels[1]};
			end
			3'd2: begin
				col = {pixels[58], pixels[50], pixels[42], pixels[34], pixels[26], pixels[18], pixels[10], pixels[2]};
			end
			3'd3: begin
				col = {pixels[59], pixels[51], pixels[43], pixels[35], pixels[27], pixels[19], pixels[11], pixels[3]};
			end
			3'd4: begin
				col = {pixels[60], pixels[52], pixels[44], pixels[36], pixels[28], pixels[20], pixels[12], pixels[4]};
			end
			3'd5: begin
				col = {pixels[61], pixels[53], pixels[45], pixels[37], pixels[29], pixels[21], pixels[13], pixels[5]};
			end
			3'd6: begin
				col = {pixels[62], pixels[54], pixels[46], pixels[38], pixels[30], pixels[22], pixels[14], pixels[6]};
			end
			3'd7: begin
				col = {pixels[63], pixels[55], pixels[47], pixels[39], pixels[31], pixels[23], pixels[15], pixels[7]};
			end
		endcase
	end
//PROVIDER+++++++++++++++++++++++++++++++++++++++++++++++++++

	parameter dir = 1'b1;
	
	wire [63:0] pixels_SC1;
	wire [63:0] pixels_SC2;
	wire [63:0] pixels_SC3;
	wire [63:0] pixels_SC4;
	
	wire [7:0] shifted_col1, shifted_col2, shifted_col3;
	
	desp desp1_inst(
		.clk(clk),
		.dir(dir),
		.reset_n(reset_n),
		.enable(enable),
		.col(col),
		.repl_col(shifted_col1),
		.out(pixels_SC1),
	);
	
	desp desp2_inst(
		.clk(clk),
		.dir(dir),
		.reset_n(reset_n),
		.enable(enable),
		.col(shifted_col1),
		.repl_col(shifted_col2),
		.out(pixels_SC2),
	);
	
	desp desp3_inst(
		.clk(clk),
		.dir(dir),
		.reset_n(reset_n),
		.enable(enable),
		.col(shifted_col2),
		.repl_col(shifted_col3),
		.out(pixels_SC3),
	);
	
	desp desp4_inst(
		.clk(clk),
		.dir(dir),
		.reset_n(reset_n),
		.enable(enable),
		.col(shifted_col3),
		.out(pixels_SC4),
	);
	
	localparam SCREEN_NUM = 4;
	
	wire [64*SCREEN_NUM-1:0] display = {pixels_SC1, pixels_SC2, pixels_SC3, pixels_SC4};
	
	max7219_display #(.SIZE(SCREEN_NUM)) max7219_display_inst
	(
		.clk(sck),
      .reset_n(reset_n),
      .pixels(display),
      .mosi(din),
      .cs(cs)
	);
	 
endmodule
