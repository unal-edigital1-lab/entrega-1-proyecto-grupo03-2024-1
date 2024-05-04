module top(
	input clk,
	input sw_rst_n,
	output sck,
	output dout,
	output cs
);

	wire [127:0] rpixels;
	
//SYNC1-------------------------------------------------------sync_inst
	//Sincroniza la señal de reinicio (sw_rst_n) con el reloj del sistema (clk)
	
	wire reset_n;
	reg [1:0] sync_reg1;

   always @(posedge clk)
   begin
		sync_reg1[0] <= sw_rst_n;
      sync_reg1[1] <= sync_reg1[0];
   end

   assign reset_n = sync_reg1[1];
//SYNC1+++++++++++++++++++++++++++++++++++++++++++++++++++++++

//PLL---------------------------------------------------------pll_inst
	pll pll_inst
	(
		.inclk0(clk),
		.c0(sck)
	);
//PLL+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	localparam DISPLAY_PAUSE = 6250000; // 78125; // 390625; // 781250; // 3125000; // 6250000;
	localparam DISPLAY_PAUSE_W = $clog2(DISPLAY_PAUSE); //#bits necesarios para representar DISPLAY_PAUSE

	reg [DISPLAY_PAUSE_W-1:0] cnt_period; //Cuenta el tiempo durante la pausa de visualización

	always @(posedge clk or negedge reset_n)
		if (!reset_n)//Reset presionado
			cnt_period <= 0;
		else if (cnt_period == (DISPLAY_PAUSE - 1))
			cnt_period <= 0;
		else
			cnt_period <= cnt_period + 1'b1;

	reg enable; //Habilita la visualización durante el tiempo de pausa DISPLAY_PAUSE
	always @(posedge clk or negedge reset_n)
		begin
			if (!reset_n)//Reset presionado
				enable <= 1'b0;
			else if (cnt_period == (DISPLAY_PAUSE - 1))
				enable <= 1'b1;
			else
				enable <= 1'b0;
			end

	//Cables y registros para almacenar los píxeles de la pantalla y las columnas
	wire [63:0] pixels1, pixels2;
	reg [7:0] col, shifted_col;
	wire [127:0] display = {pixels1, pixels2};

//PROVIDER----------------------------------------------------provider_inst
	//Controla el generador de píxeles, actualiza las direcciones de memoria y los contadores de fila.
	
	reg [7:0] address, next_address;
	reg [2:0] row_cnt;//Contador de filas = 7 filas de la matriz
	reg [3:0] state, next_state;//15 estados
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
		address = 8'h20;
		next_address = 8'h48;
		row_cnt = 0;
	end

	always @(posedge clk or negedge reset_n)
		if (~reset_n) begin
			address <= 127;//1111111
         row_cnt <= 0;
         state <= S0;
      end
      else if (enable) begin
			row_cnt <= row_cnt + 1'b1;
         if (row_cnt == 3'b111) begin
				address <= next_address; // address + 1'b1;
            state <= next_state;
			end
		end

    // hello, world!
    // 8'h68, 8'h65, 8'h6c, 8'h6c, 8'h6f, 8'h2c, 8'h20, 8'h77, 8'h6f, 8'h72, 8'h6c, 8'h64, 8'h21
    // 8'h48, 8'h45, 8'h4c, 8'h4c, 8'h4f, 8'h2c, 8'h20, 8'h57, 8'h4f, 8'h52, 8'h4c, 8'h44, 8'h21

	always @* begin
      case(state)
			S0: begin next_state = S1; next_address = 8'd72; end //H
         S1: begin next_state = S2; next_address = 8'd69; end //E
         S2: begin next_state = S3; next_address = 8'd76; end //L
         S3: begin next_state = S4; next_address = 8'd76; end //L
         S4: begin next_state = S5; next_address = 8'd79; end //O
         S5: begin next_state = S6; next_address = 8'd44; end //,
         S6: begin next_state = S7; next_address = 8'd32; end // 
         S7: begin next_state = S8; next_address = 8'd87; end //W
         S8: begin next_state = S9; next_address = 8'd79; end //O
         S9: begin next_state = S10; next_address = 8'd82; end //R
         S10: begin next_state = S11; next_address = 8'd76; end //L
         S11: begin next_state = S12; next_address = 8'd68; end //D
         S12: begin next_state = S13; next_address = 8'd33; end //!
         S13: begin next_state = S14; next_address = 8'd32; end // 
         S14: begin next_state = S15; next_address = 8'd32; end // 
         S15: begin next_state = S0; next_address = 8'd32; end // 
		endcase
	end

	//ROM---------------------------------------------------------rom_inst
	parameter LENGTH = 128;//Cantidad de ubicaciones en memoria
	parameter WIDTH = 64;//Longitud de cada ubicacion
	
	reg [WIDTH-1:0] mem[LENGTH-1:0];//Banco con 128 registros de tamaño 64

	initial begin
		$readmemh("icons.hex", mem);
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

	
//SHIFT_COL--------------------------------------------------shift_col1_inst
	//Selecciona una columna especifica de la "matriz" de pixeles
	parameter dir = 1'b1;
	reg [63:0] pixels_SC1;
	reg [63:0] next_out1;
	
	initial begin
		pixels_SC1 = 0;
		next_out1 = 0;
	end

	always @(posedge clk)
		if (!reset_n)
			pixels_SC1 <= 0;
		else if (enable)
			pixels_SC1 <= next_out1;

	always @* begin
		case (dir)
			0: begin //desplazamiento izquierda
				next_out1 = {{pixels_SC1[62:56], col[7]},
								{pixels_SC1[54:48], col[6]},
								{pixels_SC1[46:40], col[5]},
								{pixels_SC1[38:32], col[4]},
								{pixels_SC1[30:24], col[3]},
								{pixels_SC1[22:16], col[2]},
								{pixels_SC1[14:8],  col[1]},
								{pixels_SC1[6:0],   col[0]}};
				shifted_col = {pixels_SC1[63], pixels_SC1[55], pixels_SC1[47], pixels_SC1[39], pixels_SC1[31], pixels_SC1[23], pixels_SC1[15], pixels_SC1[7]};
			end
         1: begin
				next_out1 = {{col[7], pixels_SC1[63:57]},
                        {col[6], pixels_SC1[55:49]},
                        {col[5], pixels_SC1[47:41]},
                        {col[4], pixels_SC1[39:33]},
                        {col[3], pixels_SC1[31:25]},
                        {col[2], pixels_SC1[23:17]},
                        {col[1], pixels_SC1[15:9]},
                        {col[0], pixels_SC1[7:1]}};
            shifted_col = {pixels_SC1[56], pixels_SC1[48], pixels_SC1[40], pixels_SC1[32], pixels_SC1[24], pixels_SC1[16], pixels_SC1[8], pixels_SC1[0]};
			end
		endcase
	end

	assign pixels1 = pixels_SC1;
//SHIFT_COL++++++++++++++++++++++++++++++++++++++++++++++++++

//SHIFT_COL--------------------------------------------------shift_col2_inst
	reg [63:0] pixels_SC2;
	reg [63:0] next_out2;

	always @(posedge clk)
		if (!reset_n)
			pixels_SC2 <= 0;
		else if (enable)
			pixels_SC2 <= next_out2;

	always @* begin
		case (dir)
			0: begin //desplazamiento izquierda
				next_out2 = {{pixels_SC2[62:56], col[7]},
								{pixels_SC2[54:48], col[6]},
								{pixels_SC2[46:40], col[5]},
								{pixels_SC2[38:32], col[4]},
								{pixels_SC2[30:24], col[3]},
								{pixels_SC2[22:16], col[2]},
								{pixels_SC2[14:8],  col[1]},
								{pixels_SC2[6:0],   col[0]}};
				shifted_col = {pixels_SC2[63], pixels_SC2[55], pixels_SC2[47], pixels_SC2[39], pixels_SC2[31], pixels_SC2[23], pixels_SC2[15], pixels_SC2[7]};
			end
         1: begin
				next_out2 = {{col[7], pixels_SC2[63:57]},
                        {col[6], pixels_SC2[55:49]},
                        {col[5], pixels_SC2[47:41]},
                        {col[4], pixels_SC2[39:33]},
                        {col[3], pixels_SC2[31:25]},
                        {col[2], pixels_SC2[23:17]},
                        {col[1], pixels_SC2[15:9]},
                        {col[0], pixels_SC2[7:1]}};
            shifted_col = {pixels_SC2[56], pixels_SC2[48], pixels_SC2[40], pixels_SC2[32], pixels_SC2[24], pixels_SC2[16], pixels_SC2[8], pixels_SC2[0]};
			end
		endcase
	end

	assign pixels2 = pixels_SC2;
//SHIFT_COL++++++++++++++++++++++++++++++++++++++++++++++++++

	wire started;
	parameter DSIZE = 128;
	parameter ASIZE = 8;
	parameter I_WR = 1'b1;
	
	//Posibles indicadores de los buffers de memoria
	reg afifo_full;
	reg afifo_empty;
	wire afifo_not_empty = ~afifo_empty;

//AFIFO_INST-------------------------------------------------afifo_inst
	localparam DW = DSIZE, AW = ASIZE;

	wire wfull_next, rempty_next;
	
	//Registros de 8 bits
	wire [AW-1:0] waddr, raddr;
	
   //Registros de 9 bits
	reg [AW:0] wgray, wbin, wq2_rgray, wq1_rgray;
	reg [AW:0] rgray, rbin, rq2_wgray, rq1_wgray;

	wire [AW:0] wgraynext, wbinnext;//Registros de 9 bits
	wire [AW:0] rgraynext, rbinnext;//Registros de 9 bits

	reg [DW-1:0] mem_AFIFO [((2**AW)-1):0]; //Banco con 128 registros de tamaño 128

		////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////
		//
		// Write logic
		//
		////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////
		// Cross clock domains
		// Cross the read Gray pointer into the write clock domain
	
	initial { wq2_rgray,  wq1_rgray } = 0;
	
   always @(posedge clk or negedge reset_n)
		if (!reset_n)
			{ wq2_rgray, wq1_rgray } <= 0;
		else
			{ wq2_rgray, wq1_rgray } <= { wq1_rgray, rgray };

		// Calculate the next write address, and the next graycode pointer.
	assign wbinnext  = wbin + { 8'd0, ((I_WR) && (!afifo_full)) };
   assign wgraynext = (wbinnext >> 1) ^ wbinnext;

   assign waddr = wbin[AW-1:0];

		// Register these two values--the address and its Gray code representation
   initial { wbin, wgray } = 0;
   always @(posedge clk or negedge reset_n)
		if (!reset_n)
			{ wbin, wgray } <= 0;
		else
			{ wbin, wgray } <= { wbinnext, wgraynext };

	assign wfull_next = (wgraynext == { ~wq2_rgray[AW:AW-1],
                                       wq2_rgray[AW-2:0] });

		// Calculate whether or not the register will be full on the next clock.
	initial afifo_full = 0;
   always @(posedge clk or negedge reset_n)
		if (!reset_n)
			afifo_full <= 1'b0;
		else
			afifo_full <= wfull_next;

		// Write to the FIFO on a clock
   always @(posedge clk)
		if ((I_WR)&&(!afifo_full))
		mem_AFIFO[waddr] <= display;

		////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////
		//
		// Read logic
		//
		////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////
		// Cross clock domains
		// Cross the write Gray pointer into the read clock domain
	initial { rq2_wgray,  rq1_wgray } = 0;
   	always @(posedge sck or negedge reset_n)
		if (!reset_n)
			{ rq2_wgray, rq1_wgray } <= 0;
		else
			{ rq2_wgray, rq1_wgray } <= { rq1_wgray, wgray };


		// Calculate the next read address,
	assign  rbinnext  = rbin + { {(AW){1'b0}}, ((started)&&(!afifo_empty)) };
		// and the next Gray code version associated with it
	assign  rgraynext = (rbinnext >> 1) ^ rbinnext;

		// Register these two values, the read address and the Gray code version
		// of it, on the next read clock
		//
   	initial { rbin, rgray } = 0;
   	always @(posedge sck or negedge reset_n)
		if (!reset_n)
			{ rbin, rgray } <= 0;
		else
			{ rbin, rgray } <= { rbinnext, rgraynext };

		// mem_AFIFOory read address Gray code and pointer calculation
   	assign  raddr = rbin[AW-1:0];

		// Determine if we'll be empty on the next clock
   	assign  rempty_next = (rgraynext == rq2_wgray);

   	initial afifo_empty = 1;
   	always @(posedge sck or negedge reset_n)
		if (!reset_n)
			afifo_empty <= 1'b1;
		else
			afifo_empty <= rempty_next;

		//
		// Read from the mem_AFIFOory--a clockless read here, clocked by the next
		// read FLOP in the next processing stage (somewhere else)
		//
	assign  rpixels = mem_AFIFO[raddr];
//AFIFO_INST+++++++++++++++++++++++++++++++++++++++++++++++++
	
//MAX7219_display--------------------------------------------
    max7219_display #(.SIZE(2)) max7219_display_inst
    (
        .clk(sck),
        .rst_n(reset_n),
        .enable(afifo_not_empty),
        .pixels(display),
		  .started(started),
        .mosi(dout),
        .cs(cs)
    );
//MAX7219_display++++++++++++++++++++++++++++++++++++++++++++
	 
endmodule
