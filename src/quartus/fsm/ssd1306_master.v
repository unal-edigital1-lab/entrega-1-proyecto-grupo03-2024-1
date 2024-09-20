module ssd1306_master (
    input clk,
    input [3:0] state,
    input [9:0] data_counter,
	input [8:0] screen_param,
	input [32:0] needs_values,
    output reg [6:0] addr_byte_in,
    output reg read_write,
    output reg [7:0] control_byte_in,
    output reg [7:0] data_byte_in,
    output reg continue_bit
);

    // Co + D/C# + Control byte

    localparam IDLE = 4'd0;
    localparam START = 4'd1;
    localparam RECOGNITION = 4'd2;
    localparam WRITE_CONTROL = 4'd3;
    localparam WRITE_DATA = 4'd4;
    localparam READ = 4'd5;
    localparam ACKNOWLEDGE = 4'd6;
    localparam RECOGNITION_ACK = 4'd7;
    localparam STOP = 4'd8;
    localparam DELAY = 4'd9;

	wire [3:0] state_fsm;
	assign state_fsm = screen_param[3:0];

	wire test;
	assign test = screen_param[8];

	wire act_eat;
	assign act_eat = screen_param[7];

	wire act_heal;
	assign act_heal = screen_param[6];

	wire act_play;
	assign act_play = screen_param[5];

	wire act_sleep;
	assign act_sleep = screen_param[4];

	wire disease;
	assign disease = needs_values[32];
	 
	wire [6:0] life;
	assign life = needs_values[31:25];
	
	wire [6:0] food;
	assign food = needs_values[24:18];
	
	wire [6:0] fun;
	assign fun = needs_values[17:11];
	
	wire [6:0] rest;
	assign rest = needs_values[10:4];
	 
	 reg [7:0] SCREEN_START [511:0];
	 reg [7:0] SCREEN_MAIN [511:0];
	 reg [7:0] SCREEN_EAT [511:0];
	 reg [7:0] SCREEN_PLAY[511:0];
	 reg [7:0] SCREEN_HEAL [511:0];
	 reg [7:0] SCREEN_SLEEP [511:0];
	 reg [7:0] SCREEN_DEATH [511:0];

	 initial begin
		  $readmemh("D:/Personal/1-Universidad nacional/Semestre 6/Digital 1/Github/entrega-1-proyecto-grupo03-2024-1/src/quartus/fsm/SCREEN_MAIN.men", SCREEN_MAIN, 0, 511);
		  $readmemh("D:/Personal/1-Universidad nacional/Semestre 6/Digital 1/Github/entrega-1-proyecto-grupo03-2024-1/src/quartus/fsm/SCREEN_START.men", SCREEN_START, 0, 511);
		  $readmemh("D:/Personal/1-Universidad nacional/Semestre 6/Digital 1/Github/entrega-1-proyecto-grupo03-2024-1/src/quartus/fsm/SCREEN_EAT.men", SCREEN_EAT, 0, 511);
		  $readmemh("D:/Personal/1-Universidad nacional/Semestre 6/Digital 1/Github/entrega-1-proyecto-grupo03-2024-1/src/quartus/fsm/SCREEN_PLAY.men", SCREEN_PLAY, 0, 511);
		  $readmemh("D:/Personal/1-Universidad nacional/Semestre 6/Digital 1/Github/entrega-1-proyecto-grupo03-2024-1/src/quartus/fsm/SCREEN_HEAL.men", SCREEN_HEAL, 0, 511);
		  $readmemh("D:/Personal/1-Universidad nacional/Semestre 6/Digital 1/Github/entrega-1-proyecto-grupo03-2024-1/src/quartus/fsm/SCREEN_SLEEP.men", SCREEN_SLEEP, 0, 511);
		  $readmemh("D:/Personal/1-Universidad nacional/Semestre 6/Digital 1/Github/entrega-1-proyecto-grupo03-2024-1/src/quartus/fsm/SCREEN_DEATH.men", SCREEN_DEATH, 0, 511);
	 end

    initial begin
        addr_byte_in = 7'b0111100;
        read_write = 0;
        control_byte_in = 8'b00000000;
        data_byte_in = 8'hAE;
        continue_bit = 1;
    end
	 
	 integer i;

    always @ (posedge clk) begin
			
        case (state)
            //START: begin
            //        
            //    end
            ACKNOWLEDGE: begin
                    case (data_counter)

                        // block 1

                        8'd0: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'hAE;
                            continue_bit = 1;
                        end

                        8'd1: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'hD5;
                            continue_bit = 1;
                        end

                        8'd2: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'h80;
                            continue_bit = 1;
                        end

                        8'd3: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'hA8;
                            continue_bit = 0;
                        end

                        // block 2

                        8'd4: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'h1F;
                            continue_bit = 0;
                        end

                        // block 3

                        8'd5: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'hD3;
                            continue_bit = 1;
                        end

                        8'd6: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'h00;
                            continue_bit = 1;
                        end

                        8'd7: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'h40;
                            continue_bit = 1;
                        end

                        8'd8: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'h8D;
                            continue_bit = 0;
                        end

                        // block 4

                        8'd9: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'h14;
                            continue_bit = 0;
                        end

                        // block 5

                        8'd10: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'h20;
                            continue_bit = 1;
                        end

                        8'd11: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'h00;
                            continue_bit = 1;
                        end

                        8'd12: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'hA1;
                            continue_bit = 1;
                        end

                        8'd13: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'hC8;
                            continue_bit = 0;
                        end

                        // block 6

                        8'd14: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'hDA;
                            continue_bit = 0;
                        end

                        // block 7

                        8'd15: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'h02;
                            continue_bit = 0;
                        end

                        // block 8

                        8'd16: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'h81;
                            continue_bit = 0;
                        end

                        // block 9

                        8'd17: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'h8F;
                            continue_bit = 0;
                        end

                        // block 10

                        8'd18: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'hD9;
                            continue_bit = 0;
                        end

                        // block 11

                        8'd19: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'hF1;
                            continue_bit = 0;
                        end

                        // block 12

                        8'd20: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'hDB;
                            continue_bit = 1;
                        end

                        8'd21: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'h40;
                            continue_bit = 1;
                        end

                        8'd22: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'hA4;
                            continue_bit = 1;
                        end

                        8'd23: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'hA6;
                            continue_bit = 1;
                        end

                        8'd24: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'h2E;
                            continue_bit = 1;
                        end
                        
                        8'd25: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'hAF;
                            continue_bit = 0;
                        end

                        // block 12 - set write location

                        8'd26: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'h22;
                            continue_bit = 1;
                        end

                        8'd27: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'h00;
                            continue_bit = 1;
                        end

                        8'd28: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'hFF;
                            continue_bit = 1;
                        end

                        8'd29: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'h21;
                            continue_bit = 1;
                        end

                        8'd30: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'h00;
                            continue_bit = 0;
                        end

                        // block 13

                        8'd31: begin
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b00000000;
                            data_byte_in = 8'h7F;
                            continue_bit = 0;
                        end

                        default: begin
								
							if (state_fsm == 0) begin
								data_byte_in = SCREEN_START[data_counter-32];
							end
							else if (state_fsm == 1) begin
								data_byte_in = SCREEN_MAIN[data_counter-32];

								if (test == 1) begin
									SCREEN_MAIN[386] = 8'h1;
									SCREEN_MAIN[387] = 8'h1;
									SCREEN_MAIN[388] = 8'h7F;
									SCREEN_MAIN[389] = 8'h1;
									SCREEN_MAIN[390] = 8'h1;
									SCREEN_MAIN[391] = 8'h7C;
									SCREEN_MAIN[392] = 8'h54;
									SCREEN_MAIN[393] = 8'h5C;
									SCREEN_MAIN[394] = 8'h0;
									SCREEN_MAIN[395] = 8'h5C;
									SCREEN_MAIN[396] = 8'h54;
									SCREEN_MAIN[397] = 8'h74;
									SCREEN_MAIN[398] = 8'h0;
									SCREEN_MAIN[399] = 8'h4;
									SCREEN_MAIN[400] = 8'h7E;
									SCREEN_MAIN[401] = 8'h44;
								end
								else begin
									SCREEN_MAIN[386] = 8'h0;
									SCREEN_MAIN[387] = 8'h0;
									SCREEN_MAIN[388] = 8'h0;
									SCREEN_MAIN[389] = 8'h0;
									SCREEN_MAIN[390] = 8'h0;
									SCREEN_MAIN[391] = 8'h0;
									SCREEN_MAIN[392] = 8'h0;
									SCREEN_MAIN[393] = 8'h0;
									SCREEN_MAIN[394] = 8'h0;
									SCREEN_MAIN[395] = 8'h0;
									SCREEN_MAIN[396] = 8'h0;
									SCREEN_MAIN[397] = 8'h0;
									SCREEN_MAIN[398] = 8'h0;
									SCREEN_MAIN[399] = 8'h0;
									SCREEN_MAIN[400] = 8'h0;
									SCREEN_MAIN[401] = 8'h0;
								end

								//setting character aspect
									
								if (life >= 7'd0 && life <= 7'd100) begin
									SCREEN_MAIN[183] = 8'h0;
									SCREEN_MAIN[184] = 8'h0;
									SCREEN_MAIN[185] = 8'h0;
									SCREEN_MAIN[186] = 8'h0;
									SCREEN_MAIN[187] = 8'h0;
									SCREEN_MAIN[188] = 8'h80;
									SCREEN_MAIN[189] = 8'h80;
									SCREEN_MAIN[190] = 8'h80;
									SCREEN_MAIN[191] = 8'h80;
									SCREEN_MAIN[192] = 8'h80;
									SCREEN_MAIN[193] = 8'h80;
									SCREEN_MAIN[194] = 8'h80;
									SCREEN_MAIN[195] = 8'h0;
									SCREEN_MAIN[196] = 8'h0;
									SCREEN_MAIN[197] = 8'h0;
									SCREEN_MAIN[198] = 8'h0;
									SCREEN_MAIN[199] = 8'h0;
									
									SCREEN_MAIN[311] = 8'h18;
									SCREEN_MAIN[312] = 8'h34;
									SCREEN_MAIN[313] = 8'h54;
									SCREEN_MAIN[314] = 8'h52;
									SCREEN_MAIN[315] = 8'hC3;
									SCREEN_MAIN[316] = 8'hC0;
									SCREEN_MAIN[317] = 8'h4A;
									SCREEN_MAIN[318] = 8'h4A;
									SCREEN_MAIN[319] = 8'hE;
									SCREEN_MAIN[320] = 8'hC;
									SCREEN_MAIN[321] = 8'h0;
									SCREEN_MAIN[322] = 8'h80;
									SCREEN_MAIN[323] = 8'h1;
									SCREEN_MAIN[324] = 8'hC6;
									SCREEN_MAIN[325] = 8'h38;
									SCREEN_MAIN[326] = 8'h0;
									SCREEN_MAIN[327] = 8'h0;

									SCREEN_MAIN[439] = 8'h0;
									SCREEN_MAIN[440] = 8'h0;
									SCREEN_MAIN[441] = 8'h60;
									SCREEN_MAIN[442] = 8'h53;
									SCREEN_MAIN[443] = 8'h72;
									SCREEN_MAIN[444] = 8'h4F;
									SCREEN_MAIN[445] = 8'h4C;
									SCREEN_MAIN[446] = 8'h78;
									SCREEN_MAIN[447] = 8'h10;
									SCREEN_MAIN[448] = 8'h10;
									SCREEN_MAIN[449] = 8'h73;
									SCREEN_MAIN[450] = 8'h42;
									SCREEN_MAIN[451] = 8'h66;
									SCREEN_MAIN[452] = 8'h40;
									SCREEN_MAIN[453] = 8'h67;
									SCREEN_MAIN[454] = 8'h58;
									SCREEN_MAIN[455] = 8'h60;
								end

								//setting life indicator

								if (life > 7'd83 && life <= 7'd100) begin
									SCREEN_MAIN[483] = 8'hE;
									SCREEN_MAIN[484] = 8'h1D;
									SCREEN_MAIN[485] = 8'h3F;
									SCREEN_MAIN[486] = 8'h7E;
									SCREEN_MAIN[487] = 8'h3F;
									SCREEN_MAIN[488] = 8'h1F;
									SCREEN_MAIN[489] = 8'hE;
									
									SCREEN_MAIN[492] = 8'hE;
									SCREEN_MAIN[493] = 8'h1D;
									SCREEN_MAIN[494] = 8'h3F;
									SCREEN_MAIN[495] = 8'h7E;
									SCREEN_MAIN[496] = 8'h3F;
									SCREEN_MAIN[497] = 8'h1F;
									SCREEN_MAIN[498] = 8'hE;

									SCREEN_MAIN[501] = 8'hE;
									SCREEN_MAIN[502] = 8'h1D;
									SCREEN_MAIN[503] = 8'h3F;
									SCREEN_MAIN[504] = 8'h7E;
									SCREEN_MAIN[505] = 8'h3F;
									SCREEN_MAIN[506] = 8'h1F;
									SCREEN_MAIN[507] = 8'hE;
								end
								else if (life > 7'd67 && life <= 7'd83) begin
									SCREEN_MAIN[483] = 8'hE;
									SCREEN_MAIN[484] = 8'h1D;
									SCREEN_MAIN[485] = 8'h3F;
									SCREEN_MAIN[486] = 8'h7E;
									SCREEN_MAIN[487] = 8'h3F;
									SCREEN_MAIN[488] = 8'h1F;
									SCREEN_MAIN[489] = 8'hE;
									
									SCREEN_MAIN[492] = 8'hE;
									SCREEN_MAIN[493] = 8'h1D;
									SCREEN_MAIN[494] = 8'h3F;
									SCREEN_MAIN[495] = 8'h7E;
									SCREEN_MAIN[496] = 8'h3F;
									SCREEN_MAIN[497] = 8'h1F;
									SCREEN_MAIN[498] = 8'hE;
							
									SCREEN_MAIN[501] = 8'hE;
									SCREEN_MAIN[502] = 8'h1D;
									SCREEN_MAIN[503] = 8'h3F;
									SCREEN_MAIN[504] = 8'h7E;
									SCREEN_MAIN[505] = 8'h0;
									SCREEN_MAIN[506] = 8'h0;
									SCREEN_MAIN[507] = 8'h0;    
								end
								else if (life > 7'd50 && life <= 7'd67) begin
									SCREEN_MAIN[483] = 8'hE;
									SCREEN_MAIN[484] = 8'h1D;
									SCREEN_MAIN[485] = 8'h3F;
									SCREEN_MAIN[486] = 8'h7E;
									SCREEN_MAIN[487] = 8'h3F;
									SCREEN_MAIN[488] = 8'h1F;
									SCREEN_MAIN[489] = 8'hE;
									
									SCREEN_MAIN[492] = 8'hE;
									SCREEN_MAIN[493] = 8'h1D;
									SCREEN_MAIN[494] = 8'h3F;
									SCREEN_MAIN[495] = 8'h7E;
									SCREEN_MAIN[496] = 8'h3F;
									SCREEN_MAIN[497] = 8'h1F;
									SCREEN_MAIN[498] = 8'hE;
							
									SCREEN_MAIN[501] = 8'h0;
									SCREEN_MAIN[502] = 8'h0;
									SCREEN_MAIN[503] = 8'h0;
									SCREEN_MAIN[504] = 8'h0;
									SCREEN_MAIN[505] = 8'h0;
									SCREEN_MAIN[506] = 8'h0;
									SCREEN_MAIN[507] = 8'h0;
								end
								else if (life > 7'd33 && life <= 7'd50) begin
									SCREEN_MAIN[483] = 8'hE;
									SCREEN_MAIN[484] = 8'h1D;
									SCREEN_MAIN[485] = 8'h3F;
									SCREEN_MAIN[486] = 8'h7E;
									SCREEN_MAIN[487] = 8'h3F;
									SCREEN_MAIN[488] = 8'h1F;
									SCREEN_MAIN[489] = 8'hE;
									
									SCREEN_MAIN[492] = 8'hE;
									SCREEN_MAIN[493] = 8'h1D;
									SCREEN_MAIN[494] = 8'h3F;
									SCREEN_MAIN[495] = 8'h7E;
									SCREEN_MAIN[496] = 8'h0;
									SCREEN_MAIN[497] = 8'h0;
									SCREEN_MAIN[498] = 8'h0;
							
									SCREEN_MAIN[501] = 8'h0;
									SCREEN_MAIN[502] = 8'h0;
									SCREEN_MAIN[503] = 8'h0;
									SCREEN_MAIN[504] = 8'h0;
									SCREEN_MAIN[505] = 8'h0;
									SCREEN_MAIN[506] = 8'h0;
									SCREEN_MAIN[507] = 8'h0;
								end
								else if (life > 7'd16 && life <= 7'd33) begin
									SCREEN_MAIN[483] = 8'hE;
									SCREEN_MAIN[484] = 8'h1D;
									SCREEN_MAIN[485] = 8'h3F;
									SCREEN_MAIN[486] = 8'h7E;
									SCREEN_MAIN[487] = 8'h3F;
									SCREEN_MAIN[488] = 8'h1F;
									SCREEN_MAIN[489] = 8'hE;
									
									SCREEN_MAIN[492] = 8'h0;
									SCREEN_MAIN[493] = 8'h0;
									SCREEN_MAIN[494] = 8'h0;
									SCREEN_MAIN[495] = 8'h0;
									SCREEN_MAIN[496] = 8'h0;
									SCREEN_MAIN[497] = 8'h0;
									SCREEN_MAIN[498] = 8'h0;
							
									SCREEN_MAIN[501] = 8'h0;
									SCREEN_MAIN[502] = 8'h0;
									SCREEN_MAIN[503] = 8'h0;
									SCREEN_MAIN[504] = 8'h0;
									SCREEN_MAIN[505] = 8'h0;
									SCREEN_MAIN[506] = 8'h0;
									SCREEN_MAIN[507] = 8'h0;
								end
								else if (life >= 7'd0 && life <= 7'd16) begin
									SCREEN_MAIN[483] = 8'hE;
									SCREEN_MAIN[484] = 8'h1D;
									SCREEN_MAIN[485] = 8'h3F;
									SCREEN_MAIN[486] = 8'h7E;
									SCREEN_MAIN[487] = 8'h0;
									SCREEN_MAIN[488] = 8'h0;
									SCREEN_MAIN[489] = 8'h0;
									
									SCREEN_MAIN[492] = 8'h0;
									SCREEN_MAIN[493] = 8'h0;
									SCREEN_MAIN[494] = 8'h0;
									SCREEN_MAIN[495] = 8'h0;
									SCREEN_MAIN[496] = 8'h0;
									SCREEN_MAIN[497] = 8'h0;
									SCREEN_MAIN[498] = 8'h0;
							
									SCREEN_MAIN[501] = 8'h0;
									SCREEN_MAIN[502] = 8'h0;
									SCREEN_MAIN[503] = 8'h0;
									SCREEN_MAIN[504] = 8'h0;
									SCREEN_MAIN[505] = 8'h0;
									SCREEN_MAIN[506] = 8'h0;
									SCREEN_MAIN[507] = 8'h0;
								end

								//setting food indicator

								if (food > 7'd67 && food <= 7'd100) begin
									SCREEN_MAIN[31] = 8'h70;
									SCREEN_MAIN[32] = 8'h88;
									SCREEN_MAIN[33] = 8'h88;
									SCREEN_MAIN[34] = 8'h86;
									SCREEN_MAIN[35] = 8'h8B;
									SCREEN_MAIN[36] = 8'h89; 
									SCREEN_MAIN[37] = 8'h70;

									SCREEN_MAIN[41] = 8'h70;
									SCREEN_MAIN[42] = 8'h88; 
									SCREEN_MAIN[43] = 8'h88;
									SCREEN_MAIN[44] = 8'h86;
									SCREEN_MAIN[45] = 8'h8B; 
									SCREEN_MAIN[46] = 8'h89;
									SCREEN_MAIN[47] = 8'h70;

									SCREEN_MAIN[51] = 8'h70; 
									SCREEN_MAIN[52] = 8'h88;
									SCREEN_MAIN[53] = 8'h88;
									SCREEN_MAIN[54] = 8'h86;  
									SCREEN_MAIN[55] = 8'h8B;
									SCREEN_MAIN[56] = 8'h89;
									SCREEN_MAIN[57] = 8'h70;
								end
								else if (food > 7'd33 && food <= 7'd67) begin
									SCREEN_MAIN[31] = 8'h70;
									SCREEN_MAIN[32] = 8'h88;
									SCREEN_MAIN[33] = 8'h88;
									SCREEN_MAIN[34] = 8'h86;
									SCREEN_MAIN[35] = 8'h8B;
									SCREEN_MAIN[36] = 8'h89; 
									SCREEN_MAIN[37] = 8'h70;

									SCREEN_MAIN[41] = 8'h70;
									SCREEN_MAIN[42] = 8'h88; 
									SCREEN_MAIN[43] = 8'h88;
									SCREEN_MAIN[44] = 8'h86;
									SCREEN_MAIN[45] = 8'h8B; 
									SCREEN_MAIN[46] = 8'h89;
									SCREEN_MAIN[47] = 8'h70;

									SCREEN_MAIN[51] = 8'h0; 
									SCREEN_MAIN[52] = 8'h0;
									SCREEN_MAIN[53] = 8'h0;
									SCREEN_MAIN[54] = 8'h0;  
									SCREEN_MAIN[55] = 8'h0;
									SCREEN_MAIN[56] = 8'h0;
									SCREEN_MAIN[57] = 8'h0;
								end
								else if (food >= 7'd0 && food <= 7'd33) begin
									SCREEN_MAIN[31] = 8'h70;
									SCREEN_MAIN[32] = 8'h88;
									SCREEN_MAIN[33] = 8'h88;
									SCREEN_MAIN[34] = 8'h86;
									SCREEN_MAIN[35] = 8'h8B;
									SCREEN_MAIN[36] = 8'h89; 
									SCREEN_MAIN[37] = 8'h70;
									
									SCREEN_MAIN[41] = 8'h0;
									SCREEN_MAIN[42] = 8'h0; 
									SCREEN_MAIN[43] = 8'h0;
									SCREEN_MAIN[44] = 8'h0;
									SCREEN_MAIN[45] = 8'h0; 
									SCREEN_MAIN[46] = 8'h0;
									SCREEN_MAIN[47] = 8'h0;
									
									SCREEN_MAIN[51] = 8'h0; 
									SCREEN_MAIN[52] = 8'h0;
									SCREEN_MAIN[53] = 8'h0;
									SCREEN_MAIN[54] = 8'h0;  
									SCREEN_MAIN[55] = 8'h0;
									SCREEN_MAIN[56] = 8'h0;
									SCREEN_MAIN[57] = 8'h0;
								end

								//setting fun indicator

								if (fun > 7'd67 && fun <= 7'd100) begin
									SCREEN_MAIN[12] = 8'h30;
									SCREEN_MAIN[13] = 8'h40;
									SCREEN_MAIN[14] = 8'h8F;
									SCREEN_MAIN[15] = 8'h80;
									SCREEN_MAIN[16] = 8'h8F;
									SCREEN_MAIN[17] = 8'h40;
									SCREEN_MAIN[18] = 8'h30;
								end
								if (fun > 7'd33 && fun <= 7'd67) begin
									SCREEN_MAIN[12] = 8'h40;
									SCREEN_MAIN[13] = 8'h40;
									SCREEN_MAIN[14] = 8'h4F;
									SCREEN_MAIN[15] = 8'h40;
									SCREEN_MAIN[16] = 8'h4F;
									SCREEN_MAIN[17] = 8'h40;
									SCREEN_MAIN[18] = 8'h40;
								end
								if (fun >= 7'd0 && fun <= 7'd33) begin
									SCREEN_MAIN[12] = 8'hC0;
									SCREEN_MAIN[13] = 8'h20;
									SCREEN_MAIN[14] = 8'h2F;
									SCREEN_MAIN[15] = 8'h20;
									SCREEN_MAIN[16] = 8'h2F;
									SCREEN_MAIN[17] = 8'h20;
									SCREEN_MAIN[18] = 8'hC0;
								end
								
								//setting rest indicator

								if (rest > 7'd67 && rest <= 7'd100) begin
									SCREEN_MAIN[67] = 8'hC8;
									SCREEN_MAIN[68] = 8'hA8;
									SCREEN_MAIN[69] = 8'h98;
									SCREEN_MAIN[70] = 8'h0;
									SCREEN_MAIN[71] = 8'h31;
									SCREEN_MAIN[72] = 8'h29; 
									SCREEN_MAIN[73] = 8'h25;
									SCREEN_MAIN[74] = 8'h23;

									SCREEN_MAIN[77] = 8'hC8;
									SCREEN_MAIN[78] = 8'hA8; 
									SCREEN_MAIN[79] = 8'h98;
									SCREEN_MAIN[80] = 8'h0;
									SCREEN_MAIN[81] = 8'h31; 
									SCREEN_MAIN[82] = 8'h29;
									SCREEN_MAIN[83] = 8'h25;
									SCREEN_MAIN[84] = 8'h23; 

									SCREEN_MAIN[87] = 8'hC8; 
									SCREEN_MAIN[88] = 8'hA8;
									SCREEN_MAIN[89] = 8'h98;
									SCREEN_MAIN[90] = 8'h0;  
									SCREEN_MAIN[91] = 8'h31;
									SCREEN_MAIN[92] = 8'h29;
									SCREEN_MAIN[93] = 8'h25;  
									SCREEN_MAIN[94] = 8'h23;
								end
								else if (rest > 7'd33 && rest <= 7'd67) begin
									SCREEN_MAIN[67] = 8'hC8;
									SCREEN_MAIN[68] = 8'hA8;
									SCREEN_MAIN[69] = 8'h98;
									SCREEN_MAIN[70] = 8'h0;
									SCREEN_MAIN[71] = 8'h31;
									SCREEN_MAIN[72] = 8'h29; 
									SCREEN_MAIN[73] = 8'h25;
									SCREEN_MAIN[74] = 8'h23;

									SCREEN_MAIN[77] = 8'hC8;
									SCREEN_MAIN[78] = 8'hA8; 
									SCREEN_MAIN[79] = 8'h98;
									SCREEN_MAIN[80] = 8'h0;
									SCREEN_MAIN[81] = 8'h31; 
									SCREEN_MAIN[82] = 8'h29;
									SCREEN_MAIN[83] = 8'h25;
									SCREEN_MAIN[84] = 8'h23; 

									SCREEN_MAIN[87] = 8'h0; 
									SCREEN_MAIN[88] = 8'h0;
									SCREEN_MAIN[89] = 8'h0;
									SCREEN_MAIN[90] = 8'h0;  
									SCREEN_MAIN[91] = 8'h0;
									SCREEN_MAIN[92] = 8'h0;
									SCREEN_MAIN[93] = 8'h0;  
									SCREEN_MAIN[94] = 8'h0;
								end
								else if (rest >= 7'd0 && rest <= 7'd33) begin
									SCREEN_MAIN[67] = 8'hC8;
									SCREEN_MAIN[68] = 8'hA8;
									SCREEN_MAIN[69] = 8'h98;
									SCREEN_MAIN[70] = 8'h0;
									SCREEN_MAIN[71] = 8'h31;
									SCREEN_MAIN[72] = 8'h29; 
									SCREEN_MAIN[73] = 8'h25;
									SCREEN_MAIN[74] = 8'h23;

									SCREEN_MAIN[77] = 8'h0;
									SCREEN_MAIN[78] = 8'h0; 
									SCREEN_MAIN[79] = 8'h0;
									SCREEN_MAIN[80] = 8'h0;
									SCREEN_MAIN[81] = 8'h0; 
									SCREEN_MAIN[82] = 8'h0;
									SCREEN_MAIN[83] = 8'h0;
									SCREEN_MAIN[84] = 8'h0; 

									SCREEN_MAIN[87] = 8'h0; 
									SCREEN_MAIN[88] = 8'h0;
									SCREEN_MAIN[89] = 8'h0;
									SCREEN_MAIN[90] = 8'h0;  
									SCREEN_MAIN[91] = 8'h0;
									SCREEN_MAIN[92] = 8'h0;
									SCREEN_MAIN[93] = 8'h0;  
									SCREEN_MAIN[94] = 8'h0;
								end

								//setting heal indicator

								if (disease) begin
									SCREEN_MAIN[106] = 8'h78;
									SCREEN_MAIN[107] = 8'hFC;
									SCREEN_MAIN[108] = 8'hFC;
									SCREEN_MAIN[109] = 8'hFE;
									SCREEN_MAIN[110] = 8'hED;
									SCREEN_MAIN[111] = 8'hC5;
									SCREEN_MAIN[112] = 8'hED;
									SCREEN_MAIN[113] = 8'hFE;
									SCREEN_MAIN[114] = 8'hFC;
									SCREEN_MAIN[115] = 8'hFC;
									SCREEN_MAIN[116] = 8'hF8;
								end 
								else begin
									SCREEN_MAIN[106] = 8'h0;
									SCREEN_MAIN[107] = 8'h0;
									SCREEN_MAIN[108] = 8'h0;
									SCREEN_MAIN[109] = 8'h0;
									SCREEN_MAIN[110] = 8'h0;
									SCREEN_MAIN[111] = 8'h0;
									SCREEN_MAIN[112] = 8'h0;
									SCREEN_MAIN[113] = 8'h0;
									SCREEN_MAIN[114] = 8'h0;
									SCREEN_MAIN[115] = 8'h0;
									SCREEN_MAIN[116] = 8'h0;
								end

								//setting ind select
								if (test == 0) begin
									case (needs_values[3:0]) 
										0: begin
											for (i=128; i<138; i=i+1) begin
												SCREEN_MAIN[i][2] = 0;
											end
											for (i=138; i<149; i=i+1) begin
												SCREEN_MAIN[i][2] = 1;
											end
											for (i=149; i<256; i=i+1) begin
												SCREEN_MAIN[i][2] = 0;
											end
										end
										
										1: begin
											for (i=128; i<159; i=i+1) begin
												SCREEN_MAIN[i][2] = 0;
											end
											for (i=159; i<186; i=i+1) begin
												SCREEN_MAIN[i][2] = 1;
											end
											for (i=186; i<256; i=i+1) begin
												SCREEN_MAIN[i][2] = 0;
											end
										end
										
										2: begin
											for (i=128; i<195; i=i+1) begin
												SCREEN_MAIN[i][2] = 0;
											end
											for (i=195; i<223; i=i+1) begin
												SCREEN_MAIN[i][2] = 1;
											end
											for (i=223; i<256; i=i+1) begin
												SCREEN_MAIN[i][2] = 0;
											end
										end
										
										3: begin
											for (i=128; i<234; i=i+1) begin
												SCREEN_MAIN[i][2] = 0;
											end
											for (i=234; i<245; i=i+1) begin
												SCREEN_MAIN[i][2] = 1;
											end
											for (i=245; i<256; i=i+1) begin
												SCREEN_MAIN[i][2] = 0;
											end
										end
									endcase
								end
								else begin
									for (i=128; i<256; i=i+1) begin
										SCREEN_MAIN[i][2] = 0;
									end
								end
							end
							else if (state_fsm == 2) begin
								data_byte_in = SCREEN_PLAY[data_counter-32];

								//setting character aspect

								if (act_play) begin
									SCREEN_PLAY[184] = 8'h0;
									SCREEN_PLAY[185] = 8'h0;
									SCREEN_PLAY[186] = 8'h0;
									SCREEN_PLAY[187] = 8'h0;
									SCREEN_PLAY[188] = 8'h80;
									SCREEN_PLAY[189] = 8'h80;
									SCREEN_PLAY[190] = 8'h80;
									SCREEN_PLAY[191] = 8'h80;
									SCREEN_PLAY[192] = 8'h80;
									SCREEN_PLAY[193] = 8'h0;
									SCREEN_PLAY[194] = 8'h0;
									SCREEN_PLAY[195] = 8'h0;
									SCREEN_PLAY[196] = 8'h0;
									SCREEN_PLAY[197] = 8'h0;
									SCREEN_PLAY[198] = 8'h0;
									SCREEN_PLAY[199] = 8'h0;
									SCREEN_PLAY[200] = 8'h0;
									SCREEN_PLAY[201] = 8'h0;
									SCREEN_PLAY[202] = 8'h0;
									SCREEN_PLAY[203] = 8'h0;
									SCREEN_PLAY[204] = 8'h0;
									
									SCREEN_PLAY[311] = 8'h2;
									SCREEN_PLAY[312] = 8'h45;
									SCREEN_PLAY[313] = 8'hA5;
									SCREEN_PLAY[314] = 8'hA5;
									SCREEN_PLAY[315] = 8'hb9;
									SCREEN_PLAY[316] = 8'h80;
									SCREEN_PLAY[317] = 8'h84;
									SCREEN_PLAY[318] = 8'h2;
									SCREEN_PLAY[319] = 8'h2;
									SCREEN_PLAY[320] = 8'h4;
									SCREEN_PLAY[321] = 8'h1;
									SCREEN_PLAY[322] = 8'h86;
									SCREEN_PLAY[323] = 8'h78;
									SCREEN_PLAY[324] = 8'h10;
									SCREEN_PLAY[325] = 8'h0;
									SCREEN_PLAY[326] = 8'h0;
									SCREEN_PLAY[327] = 8'h0;
									SCREEN_PLAY[328] = 8'h0;

									SCREEN_PLAY[439] = 8'h80;
									SCREEN_PLAY[440] = 8'hE0;
									SCREEN_PLAY[441] = 8'hD6;
									SCREEN_PLAY[442] = 8'hF5;
									SCREEN_PLAY[443] = 8'hCF;
									SCREEN_PLAY[444] = 8'hC8;
									SCREEN_PLAY[445] = 8'hF0;
									SCREEN_PLAY[446] = 8'h90;
									SCREEN_PLAY[447] = 8'hF6;
									SCREEN_PLAY[448] = 8'hD5;
									SCREEN_PLAY[449] = 8'hEC;
									SCREEN_PLAY[450] = 8'hC1;
									SCREEN_PLAY[451] = 8'hE6;
									SCREEN_PLAY[452] = 8'hD8;
									SCREEN_PLAY[453] = 8'hE0;
									SCREEN_PLAY[454] = 8'h80;
									SCREEN_PLAY[455] = 8'h80;
								end 
                                    
                                    
                                    else begin 
                                    SCREEN_PLAY[184] = 8'h0;
									SCREEN_PLAY[185] = 8'h0;
									SCREEN_PLAY[186] = 8'h0;
									SCREEN_PLAY[187] = 8'h0;
									SCREEN_PLAY[188] = 8'h80;
									SCREEN_PLAY[189] = 8'h80;
									SCREEN_PLAY[190] = 8'h80;
									SCREEN_PLAY[191] = 8'h80;
									SCREEN_PLAY[192] = 8'h80;
									SCREEN_PLAY[193] = 8'h80;
									SCREEN_PLAY[194] = 8'h80;
									SCREEN_PLAY[195] = 8'h0;
									SCREEN_PLAY[196] = 8'h0;
									SCREEN_PLAY[197] = 8'h0;
									SCREEN_PLAY[198] = 8'h0;
									SCREEN_PLAY[199] = 8'h0;
									SCREEN_PLAY[200] = 8'h0;
									SCREEN_PLAY[201] = 8'h0;
									SCREEN_PLAY[202] = 8'h0;
									SCREEN_PLAY[203] = 8'h0;
									SCREEN_PLAY[204] = 8'h0;
									
									SCREEN_PLAY[311] = 8'h18;
									SCREEN_PLAY[312] = 8'h34;
									SCREEN_PLAY[313] = 8'h54;
									SCREEN_PLAY[314] = 8'h52;
									SCREEN_PLAY[315] = 8'hC3;
									SCREEN_PLAY[316] = 8'hC0;
									SCREEN_PLAY[317] = 8'h4A;
									SCREEN_PLAY[318] = 8'h4A;
									SCREEN_PLAY[319] = 8'hE;
									SCREEN_PLAY[320] = 8'hC;
									SCREEN_PLAY[321] = 8'h0;
									SCREEN_PLAY[322] = 8'h80;
									SCREEN_PLAY[323] = 8'h1;
									SCREEN_PLAY[324] = 8'hC6;
									SCREEN_PLAY[325] = 8'h38;
									SCREEN_PLAY[326] = 8'h0;
									SCREEN_PLAY[327] = 8'h0;
									SCREEN_PLAY[328] = 8'h0;

									SCREEN_PLAY[439] = 8'h80;
									SCREEN_PLAY[440] = 8'h80;
									SCREEN_PLAY[441] = 8'hE0;
									SCREEN_PLAY[442] = 8'hD3;
									SCREEN_PLAY[443] = 8'hF2;
									SCREEN_PLAY[444] = 8'hCF;
									SCREEN_PLAY[445] = 8'hCC;
									SCREEN_PLAY[446] = 8'hF8;
									SCREEN_PLAY[447] = 8'h90;
									SCREEN_PLAY[448] = 8'h90;
									SCREEN_PLAY[449] = 8'hF3;
									SCREEN_PLAY[450] = 8'hC2;
									SCREEN_PLAY[451] = 8'hE6;
									SCREEN_PLAY[452] = 8'hC0;
									SCREEN_PLAY[453] = 8'hE7;
									SCREEN_PLAY[454] = 8'hD8;
									SCREEN_PLAY[455] = 8'hE0;
								end

								//setting food indicator

								if (food > 7'd67 && food <= 7'd100) begin
									SCREEN_PLAY[31] = 8'h70;
									SCREEN_PLAY[32] = 8'h88;
									SCREEN_PLAY[33] = 8'h88;
									SCREEN_PLAY[34] = 8'h86;
									SCREEN_PLAY[35] = 8'h8B;
									SCREEN_PLAY[36] = 8'h89; 
									SCREEN_PLAY[37] = 8'h70;

									SCREEN_PLAY[41] = 8'h70;
									SCREEN_PLAY[42] = 8'h88; 
									SCREEN_PLAY[43] = 8'h88;
									SCREEN_PLAY[44] = 8'h86;
									SCREEN_PLAY[45] = 8'h8B; 
									SCREEN_PLAY[46] = 8'h89;
									SCREEN_PLAY[47] = 8'h70;

									SCREEN_PLAY[51] = 8'h70; 
									SCREEN_PLAY[52] = 8'h88;
									SCREEN_PLAY[53] = 8'h88;
									SCREEN_PLAY[54] = 8'h86;  
									SCREEN_PLAY[55] = 8'h8B;
									SCREEN_PLAY[56] = 8'h89;
									SCREEN_PLAY[57] = 8'h70;
								end
								else if (food > 7'd33 && food <= 7'd67) begin
									SCREEN_PLAY[31] = 8'h70;
									SCREEN_PLAY[32] = 8'h88;
									SCREEN_PLAY[33] = 8'h88;
									SCREEN_PLAY[34] = 8'h86;
									SCREEN_PLAY[35] = 8'h8B;
									SCREEN_PLAY[36] = 8'h89; 
									SCREEN_PLAY[37] = 8'h70;

									SCREEN_PLAY[41] = 8'h70;
									SCREEN_PLAY[42] = 8'h88; 
									SCREEN_PLAY[43] = 8'h88;
									SCREEN_PLAY[44] = 8'h86;
									SCREEN_PLAY[45] = 8'h8B; 
									SCREEN_PLAY[46] = 8'h89;
									SCREEN_PLAY[47] = 8'h70;

									SCREEN_PLAY[51] = 8'h0; 
									SCREEN_PLAY[52] = 8'h0;
									SCREEN_PLAY[53] = 8'h0;
									SCREEN_PLAY[54] = 8'h0;  
									SCREEN_PLAY[55] = 8'h0;
									SCREEN_PLAY[56] = 8'h0;
									SCREEN_PLAY[57] = 8'h0;
								end
								else if (food >= 7'd0 && food <= 7'd33) begin
									SCREEN_PLAY[31] = 8'h70;
									SCREEN_PLAY[32] = 8'h88;
									SCREEN_PLAY[33] = 8'h88;
									SCREEN_PLAY[34] = 8'h86;
									SCREEN_PLAY[35] = 8'h8B;
									SCREEN_PLAY[36] = 8'h89; 
									SCREEN_PLAY[37] = 8'h70;
									
									SCREEN_PLAY[41] = 8'h0;
									SCREEN_PLAY[42] = 8'h0; 
									SCREEN_PLAY[43] = 8'h0;
									SCREEN_PLAY[44] = 8'h0;
									SCREEN_PLAY[45] = 8'h0; 
									SCREEN_PLAY[46] = 8'h0;
									SCREEN_PLAY[47] = 8'h0;
									
									SCREEN_PLAY[51] = 8'h0; 
									SCREEN_PLAY[52] = 8'h0;
									SCREEN_PLAY[53] = 8'h0;
									SCREEN_PLAY[54] = 8'h0;  
									SCREEN_PLAY[55] = 8'h0;
									SCREEN_PLAY[56] = 8'h0;
									SCREEN_PLAY[57] = 8'h0;
								end

								//setting fun indicator

								if (fun > 7'd67 && fun <= 7'd100) begin
									SCREEN_PLAY[12] = 8'h30;
									SCREEN_PLAY[13] = 8'h40;
									SCREEN_PLAY[14] = 8'h8F;
									SCREEN_PLAY[15] = 8'h80;
									SCREEN_PLAY[16] = 8'h8F;
									SCREEN_PLAY[17] = 8'h40;
									SCREEN_PLAY[18] = 8'h30;
								end
								if (fun > 7'd33 && fun <= 7'd67) begin
									SCREEN_PLAY[12] = 8'h40;
									SCREEN_PLAY[13] = 8'h40;
									SCREEN_PLAY[14] = 8'h4F;
									SCREEN_PLAY[15] = 8'h40;
									SCREEN_PLAY[16] = 8'h4F;
									SCREEN_PLAY[17] = 8'h40;
									SCREEN_PLAY[18] = 8'h40;
								end
								if (fun >= 7'd0 && fun <= 7'd33) begin
									SCREEN_PLAY[12] = 8'hC0;
									SCREEN_PLAY[13] = 8'h20;
									SCREEN_PLAY[14] = 8'h2F;
									SCREEN_PLAY[15] = 8'h20;
									SCREEN_PLAY[16] = 8'h2F;
									SCREEN_PLAY[17] = 8'h20;
									SCREEN_PLAY[18] = 8'hC0;
								end
								
								//setting rest indicator

								if (rest > 7'd67 && rest <= 7'd100) begin
									SCREEN_PLAY[67] = 8'hC8;
									SCREEN_PLAY[68] = 8'hA8;
									SCREEN_PLAY[69] = 8'h98;
									SCREEN_PLAY[70] = 8'h0;
									SCREEN_PLAY[71] = 8'h31;
									SCREEN_PLAY[72] = 8'h29; 
									SCREEN_PLAY[73] = 8'h25;
									SCREEN_PLAY[74] = 8'h23;

									SCREEN_PLAY[77] = 8'hC8;
									SCREEN_PLAY[78] = 8'hA8; 
									SCREEN_PLAY[79] = 8'h98;
									SCREEN_PLAY[80] = 8'h0;
									SCREEN_PLAY[81] = 8'h31; 
									SCREEN_PLAY[82] = 8'h29;
									SCREEN_PLAY[83] = 8'h25;
									SCREEN_PLAY[84] = 8'h23; 

									SCREEN_PLAY[87] = 8'hC8; 
									SCREEN_PLAY[88] = 8'hA8;
									SCREEN_PLAY[89] = 8'h98;
									SCREEN_PLAY[90] = 8'h0;  
									SCREEN_PLAY[91] = 8'h31;
									SCREEN_PLAY[92] = 8'h29;
									SCREEN_PLAY[93] = 8'h25;  
									SCREEN_PLAY[94] = 8'h23;
								end
								else if (rest > 7'd33 && rest <= 7'd67) begin
									SCREEN_PLAY[67] = 8'hC8;
									SCREEN_PLAY[68] = 8'hA8;
									SCREEN_PLAY[69] = 8'h98;
									SCREEN_PLAY[70] = 8'h0;
									SCREEN_PLAY[71] = 8'h31;
									SCREEN_PLAY[72] = 8'h29; 
									SCREEN_PLAY[73] = 8'h25;
									SCREEN_PLAY[74] = 8'h23;

									SCREEN_PLAY[77] = 8'hC8;
									SCREEN_PLAY[78] = 8'hA8; 
									SCREEN_PLAY[79] = 8'h98;
									SCREEN_PLAY[80] = 8'h0;
									SCREEN_PLAY[81] = 8'h31; 
									SCREEN_PLAY[82] = 8'h29;
									SCREEN_PLAY[83] = 8'h25;
									SCREEN_PLAY[84] = 8'h23; 

									SCREEN_PLAY[87] = 8'h0; 
									SCREEN_PLAY[88] = 8'h0;
									SCREEN_PLAY[89] = 8'h0;
									SCREEN_PLAY[90] = 8'h0;  
									SCREEN_PLAY[91] = 8'h0;
									SCREEN_PLAY[92] = 8'h0;
									SCREEN_PLAY[93] = 8'h0;  
									SCREEN_PLAY[94] = 8'h0;
								end
								else if (rest >= 7'd0 && rest <= 7'd33) begin
									SCREEN_PLAY[67] = 8'hC8;
									SCREEN_PLAY[68] = 8'hA8;
									SCREEN_PLAY[69] = 8'h98;
									SCREEN_PLAY[70] = 8'h0;
									SCREEN_PLAY[71] = 8'h31;
									SCREEN_PLAY[72] = 8'h29; 
									SCREEN_PLAY[73] = 8'h25;
									SCREEN_PLAY[74] = 8'h23;

									SCREEN_PLAY[77] = 8'h0;
									SCREEN_PLAY[78] = 8'h0; 
									SCREEN_PLAY[79] = 8'h0;
									SCREEN_PLAY[80] = 8'h0;
									SCREEN_PLAY[81] = 8'h0; 
									SCREEN_PLAY[82] = 8'h0;
									SCREEN_PLAY[83] = 8'h0;
									SCREEN_PLAY[84] = 8'h0; 

									SCREEN_PLAY[87] = 8'h0; 
									SCREEN_PLAY[88] = 8'h0;
									SCREEN_PLAY[89] = 8'h0;
									SCREEN_PLAY[90] = 8'h0;  
									SCREEN_PLAY[91] = 8'h0;
									SCREEN_PLAY[92] = 8'h0;
									SCREEN_PLAY[93] = 8'h0;  
									SCREEN_PLAY[94] = 8'h0;
								end

								//setting heal indicator

								if (disease) begin
									SCREEN_PLAY[106] = 8'h78;
									SCREEN_PLAY[107] = 8'hFC;
									SCREEN_PLAY[108] = 8'hFC;
									SCREEN_PLAY[109] = 8'hFE;
									SCREEN_PLAY[110] = 8'hED;
									SCREEN_PLAY[111] = 8'hC5;
									SCREEN_PLAY[112] = 8'hED;
									SCREEN_PLAY[113] = 8'hFE;
									SCREEN_PLAY[114] = 8'hFC;
									SCREEN_PLAY[115] = 8'hFC;
									SCREEN_PLAY[116] = 8'hF8;
								end 
								else begin
									SCREEN_PLAY[106] = 8'h0;
									SCREEN_PLAY[107] = 8'h0;
									SCREEN_PLAY[108] = 8'h0;
									SCREEN_PLAY[109] = 8'h0;
									SCREEN_PLAY[110] = 8'h0;
									SCREEN_PLAY[111] = 8'h0;
									SCREEN_PLAY[112] = 8'h0;
									SCREEN_PLAY[113] = 8'h0;
									SCREEN_PLAY[114] = 8'h0;
									SCREEN_PLAY[115] = 8'h0;
									SCREEN_PLAY[116] = 8'h0;
								end
							end
							else if (state_fsm == 3) begin
								data_byte_in = SCREEN_SLEEP[data_counter-32];

								//setting character aspect

								if (act_sleep) begin
									SCREEN_SLEEP[184] = 8'h0;
									SCREEN_SLEEP[185] = 8'h0;
									SCREEN_SLEEP[186] = 8'h0;
									SCREEN_SLEEP[187] = 8'h0;
									SCREEN_SLEEP[188] = 8'h0;
									SCREEN_SLEEP[189] = 8'h0;
									SCREEN_SLEEP[190] = 8'h0;
									SCREEN_SLEEP[191] = 8'h0;
									SCREEN_SLEEP[192] = 8'h0;
									SCREEN_SLEEP[193] = 8'h0;
									SCREEN_SLEEP[194] = 8'h0;
									SCREEN_SLEEP[195] = 8'h0;
									SCREEN_SLEEP[196] = 8'h0;
									SCREEN_SLEEP[197] = 8'h0;
									SCREEN_SLEEP[198] = 8'h40;
									SCREEN_SLEEP[199] = 8'h40;
									SCREEN_SLEEP[200] = 8'hC0;
									SCREEN_SLEEP[201] = 8'h0;
									SCREEN_SLEEP[202] = 8'hC8;
									SCREEN_SLEEP[203] = 8'hA8;
									SCREEN_SLEEP[204] = 8'h98;
									
									SCREEN_SLEEP[311] = 8'h0;
									SCREEN_SLEEP[312] = 8'h0;
									SCREEN_SLEEP[313] = 8'h60;
									SCREEN_SLEEP[314] = 8'h90;
									SCREEN_SLEEP[315] = 8'h90;
									SCREEN_SLEEP[316] = 8'h90;
									SCREEN_SLEEP[317] = 8'h88;
									SCREEN_SLEEP[318] = 8'h04;
									SCREEN_SLEEP[319] = 8'h24;
									SCREEN_SLEEP[320] = 8'h24;
									SCREEN_SLEEP[321] = 8'h44;
									SCREEN_SLEEP[322] = 8'h04;
									SCREEN_SLEEP[323] = 8'h08;
									SCREEN_SLEEP[324] = 8'h10;
									SCREEN_SLEEP[325] = 8'hE0;
									SCREEN_SLEEP[326] = 8'h06;
									SCREEN_SLEEP[327] = 8'h05;
									SCREEN_SLEEP[328] = 8'h04;

									SCREEN_SLEEP[439] = 8'h80;
									SCREEN_SLEEP[440] = 8'h80;
									SCREEN_SLEEP[441] = 8'h80;
									SCREEN_SLEEP[442] = 8'h99;
									SCREEN_SLEEP[443] = 8'hEA;
									SCREEN_SLEEP[444] = 8'hCA;
									SCREEN_SLEEP[445] = 8'hD6;
									SCREEN_SLEEP[446] = 8'hFA;
									SCREEN_SLEEP[447] = 8'hC0;
									SCREEN_SLEEP[448] = 8'hC0;
									SCREEN_SLEEP[449] = 8'hF8;
									SCREEN_SLEEP[450] = 8'hE4;
									SCREEN_SLEEP[451] = 8'hF0;
									SCREEN_SLEEP[452] = 8'hCB;
									SCREEN_SLEEP[453] = 8'hCC;
									SCREEN_SLEEP[454] = 8'hF8;
									SCREEN_SLEEP[455] = 8'h80;
								end
								else begin
									SCREEN_SLEEP[184] = 8'h0;
									SCREEN_SLEEP[185] = 8'h0;
									SCREEN_SLEEP[186] = 8'h0;
									SCREEN_SLEEP[187] = 8'h0;
									SCREEN_SLEEP[188] = 8'h80;
									SCREEN_SLEEP[189] = 8'h80;
									SCREEN_SLEEP[190] = 8'h80;
									SCREEN_SLEEP[191] = 8'h80;
									SCREEN_SLEEP[192] = 8'h80;
									SCREEN_SLEEP[193] = 8'h80;
									SCREEN_SLEEP[194] = 8'h80;
									SCREEN_SLEEP[195] = 8'h0;
									SCREEN_SLEEP[196] = 8'h0;
									SCREEN_SLEEP[197] = 8'h0;
									SCREEN_SLEEP[198] = 8'h0;
									SCREEN_SLEEP[199] = 8'h0;
									SCREEN_SLEEP[200] = 8'h0;
									SCREEN_SLEEP[201] = 8'h0;
									SCREEN_SLEEP[202] = 8'h0;
									SCREEN_SLEEP[203] = 8'h0;
									SCREEN_SLEEP[204] = 8'h0;
									
									SCREEN_SLEEP[311] = 8'h18;
									SCREEN_SLEEP[312] = 8'h34;
									SCREEN_SLEEP[313] = 8'h54;
									SCREEN_SLEEP[314] = 8'h52;
									SCREEN_SLEEP[315] = 8'hC3;
									SCREEN_SLEEP[316] = 8'hC0;
									SCREEN_SLEEP[317] = 8'h4A;
									SCREEN_SLEEP[318] = 8'h4A;
									SCREEN_SLEEP[319] = 8'hE;
									SCREEN_SLEEP[320] = 8'hC;
									SCREEN_SLEEP[321] = 8'h0;
									SCREEN_SLEEP[322] = 8'h80;
									SCREEN_SLEEP[323] = 8'h1;
									SCREEN_SLEEP[324] = 8'hC6;
									SCREEN_SLEEP[325] = 8'h38;
									SCREEN_SLEEP[326] = 8'h0;
									SCREEN_SLEEP[327] = 8'h0;
									SCREEN_SLEEP[328] = 8'h0;

									SCREEN_SLEEP[439] = 8'h80;
									SCREEN_SLEEP[440] = 8'h80;
									SCREEN_SLEEP[441] = 8'hE0;
									SCREEN_SLEEP[442] = 8'hD3;
									SCREEN_SLEEP[443] = 8'hF2;
									SCREEN_SLEEP[444] = 8'hCF;
									SCREEN_SLEEP[445] = 8'hCC;
									SCREEN_SLEEP[446] = 8'hF8;
									SCREEN_SLEEP[447] = 8'h90;
									SCREEN_SLEEP[448] = 8'h90;
									SCREEN_SLEEP[449] = 8'hF3;
									SCREEN_SLEEP[450] = 8'hC2;
									SCREEN_SLEEP[451] = 8'hE6;
									SCREEN_SLEEP[452] = 8'hC0;
									SCREEN_SLEEP[453] = 8'hE7;
									SCREEN_SLEEP[454] = 8'hD8;
									SCREEN_SLEEP[455] = 8'hE0;
								end

								//setting food indicator

								if (food > 7'd67 && food <= 7'd100) begin
									SCREEN_SLEEP[31] = 8'h70;
									SCREEN_SLEEP[32] = 8'h88;
									SCREEN_SLEEP[33] = 8'h88;
									SCREEN_SLEEP[34] = 8'h86;
									SCREEN_SLEEP[35] = 8'h8B;
									SCREEN_SLEEP[36] = 8'h89; 
									SCREEN_SLEEP[37] = 8'h70;

									SCREEN_SLEEP[41] = 8'h70;
									SCREEN_SLEEP[42] = 8'h88; 
									SCREEN_SLEEP[43] = 8'h88;
									SCREEN_SLEEP[44] = 8'h86;
									SCREEN_SLEEP[45] = 8'h8B; 
									SCREEN_SLEEP[46] = 8'h89;
									SCREEN_SLEEP[47] = 8'h70;

									SCREEN_SLEEP[51] = 8'h70; 
									SCREEN_SLEEP[52] = 8'h88;
									SCREEN_SLEEP[53] = 8'h88;
									SCREEN_SLEEP[54] = 8'h86;  
									SCREEN_SLEEP[55] = 8'h8B;
									SCREEN_SLEEP[56] = 8'h89;
									SCREEN_SLEEP[57] = 8'h70;
								end
								else if (food > 7'd33 && food <= 7'd67) begin
									SCREEN_SLEEP[31] = 8'h70;
									SCREEN_SLEEP[32] = 8'h88;
									SCREEN_SLEEP[33] = 8'h88;
									SCREEN_SLEEP[34] = 8'h86;
									SCREEN_SLEEP[35] = 8'h8B;
									SCREEN_SLEEP[36] = 8'h89; 
									SCREEN_SLEEP[37] = 8'h70;

									SCREEN_SLEEP[41] = 8'h70;
									SCREEN_SLEEP[42] = 8'h88; 
									SCREEN_SLEEP[43] = 8'h88;
									SCREEN_SLEEP[44] = 8'h86;
									SCREEN_SLEEP[45] = 8'h8B; 
									SCREEN_SLEEP[46] = 8'h89;
									SCREEN_SLEEP[47] = 8'h70;

									SCREEN_SLEEP[51] = 8'h0; 
									SCREEN_SLEEP[52] = 8'h0;
									SCREEN_SLEEP[53] = 8'h0;
									SCREEN_SLEEP[54] = 8'h0;  
									SCREEN_SLEEP[55] = 8'h0;
									SCREEN_SLEEP[56] = 8'h0;
									SCREEN_SLEEP[57] = 8'h0;
								end
								else if (food >= 7'd0 && food <= 7'd33) begin
									SCREEN_SLEEP[31] = 8'h70;
									SCREEN_SLEEP[32] = 8'h88;
									SCREEN_SLEEP[33] = 8'h88;
									SCREEN_SLEEP[34] = 8'h86;
									SCREEN_SLEEP[35] = 8'h8B;
									SCREEN_SLEEP[36] = 8'h89; 
									SCREEN_SLEEP[37] = 8'h70;
									
									SCREEN_SLEEP[41] = 8'h0;
									SCREEN_SLEEP[42] = 8'h0; 
									SCREEN_SLEEP[43] = 8'h0;
									SCREEN_SLEEP[44] = 8'h0;
									SCREEN_SLEEP[45] = 8'h0; 
									SCREEN_SLEEP[46] = 8'h0;
									SCREEN_SLEEP[47] = 8'h0;
									
									SCREEN_SLEEP[51] = 8'h0; 
									SCREEN_SLEEP[52] = 8'h0;
									SCREEN_SLEEP[53] = 8'h0;
									SCREEN_SLEEP[54] = 8'h0;  
									SCREEN_SLEEP[55] = 8'h0;
									SCREEN_SLEEP[56] = 8'h0;
									SCREEN_SLEEP[57] = 8'h0;
								end

								//setting fun indicator

								if (fun > 7'd67 && fun <= 7'd100) begin
									SCREEN_SLEEP[12] = 8'h30;
									SCREEN_SLEEP[13] = 8'h40;
									SCREEN_SLEEP[14] = 8'h8F;
									SCREEN_SLEEP[15] = 8'h80;
									SCREEN_SLEEP[16] = 8'h8F;
									SCREEN_SLEEP[17] = 8'h40;
									SCREEN_SLEEP[18] = 8'h30;
								end
								if (fun > 7'd33 && fun <= 7'd67) begin
									SCREEN_SLEEP[12] = 8'h40;
									SCREEN_SLEEP[13] = 8'h40;
									SCREEN_SLEEP[14] = 8'h4F;
									SCREEN_SLEEP[15] = 8'h40;
									SCREEN_SLEEP[16] = 8'h4F;
									SCREEN_SLEEP[17] = 8'h40;
									SCREEN_SLEEP[18] = 8'h40;
								end
								if (fun >= 7'd0 && fun <= 7'd33) begin
									SCREEN_SLEEP[12] = 8'hC0;
									SCREEN_SLEEP[13] = 8'h20;
									SCREEN_SLEEP[14] = 8'h2F;
									SCREEN_SLEEP[15] = 8'h20;
									SCREEN_SLEEP[16] = 8'h2F;
									SCREEN_SLEEP[17] = 8'h20;
									SCREEN_SLEEP[18] = 8'hC0;
								end
								
								//setting rest indicator

								if (rest > 7'd67 && rest <= 7'd100) begin
									SCREEN_SLEEP[67] = 8'hC8;
									SCREEN_SLEEP[68] = 8'hA8;
									SCREEN_SLEEP[69] = 8'h98;
									SCREEN_SLEEP[70] = 8'h0;
									SCREEN_SLEEP[71] = 8'h31;
									SCREEN_SLEEP[72] = 8'h29; 
									SCREEN_SLEEP[73] = 8'h25;
									SCREEN_SLEEP[74] = 8'h23;

									SCREEN_SLEEP[77] = 8'hC8;
									SCREEN_SLEEP[78] = 8'hA8; 
									SCREEN_SLEEP[79] = 8'h98;
									SCREEN_SLEEP[80] = 8'h0;
									SCREEN_SLEEP[81] = 8'h31; 
									SCREEN_SLEEP[82] = 8'h29;
									SCREEN_SLEEP[83] = 8'h25;
									SCREEN_SLEEP[84] = 8'h23; 

									SCREEN_SLEEP[87] = 8'hC8; 
									SCREEN_SLEEP[88] = 8'hA8;
									SCREEN_SLEEP[89] = 8'h98;
									SCREEN_SLEEP[90] = 8'h0;  
									SCREEN_SLEEP[91] = 8'h31;
									SCREEN_SLEEP[92] = 8'h29;
									SCREEN_SLEEP[93] = 8'h25;  
									SCREEN_SLEEP[94] = 8'h23;
								end
								else if (rest > 7'd33 && rest <= 7'd67) begin
									SCREEN_SLEEP[67] = 8'hC8;
									SCREEN_SLEEP[68] = 8'hA8;
									SCREEN_SLEEP[69] = 8'h98;
									SCREEN_SLEEP[70] = 8'h0;
									SCREEN_SLEEP[71] = 8'h31;
									SCREEN_SLEEP[72] = 8'h29; 
									SCREEN_SLEEP[73] = 8'h25;
									SCREEN_SLEEP[74] = 8'h23;

									SCREEN_SLEEP[77] = 8'hC8;
									SCREEN_SLEEP[78] = 8'hA8; 
									SCREEN_SLEEP[79] = 8'h98;
									SCREEN_SLEEP[80] = 8'h0;
									SCREEN_SLEEP[81] = 8'h31; 
									SCREEN_SLEEP[82] = 8'h29;
									SCREEN_SLEEP[83] = 8'h25;
									SCREEN_SLEEP[84] = 8'h23; 

									SCREEN_SLEEP[87] = 8'h0; 
									SCREEN_SLEEP[88] = 8'h0;
									SCREEN_SLEEP[89] = 8'h0;
									SCREEN_SLEEP[90] = 8'h0;  
									SCREEN_SLEEP[91] = 8'h0;
									SCREEN_SLEEP[92] = 8'h0;
									SCREEN_SLEEP[93] = 8'h0;  
									SCREEN_SLEEP[94] = 8'h0;
								end
								else if (rest >= 7'd0 && rest <= 7'd33) begin
									SCREEN_SLEEP[67] = 8'hC8;
									SCREEN_SLEEP[68] = 8'hA8;
									SCREEN_SLEEP[69] = 8'h98;
									SCREEN_SLEEP[70] = 8'h0;
									SCREEN_SLEEP[71] = 8'h31;
									SCREEN_SLEEP[72] = 8'h29; 
									SCREEN_SLEEP[73] = 8'h25;
									SCREEN_SLEEP[74] = 8'h23;

									SCREEN_SLEEP[77] = 8'h0;
									SCREEN_SLEEP[78] = 8'h0; 
									SCREEN_SLEEP[79] = 8'h0;
									SCREEN_SLEEP[80] = 8'h0;
									SCREEN_SLEEP[81] = 8'h0; 
									SCREEN_SLEEP[82] = 8'h0;
									SCREEN_SLEEP[83] = 8'h0;
									SCREEN_SLEEP[84] = 8'h0; 

									SCREEN_SLEEP[87] = 8'h0; 
									SCREEN_SLEEP[88] = 8'h0;
									SCREEN_SLEEP[89] = 8'h0;
									SCREEN_SLEEP[90] = 8'h0;  
									SCREEN_SLEEP[91] = 8'h0;
									SCREEN_SLEEP[92] = 8'h0;
									SCREEN_SLEEP[93] = 8'h0;  
									SCREEN_SLEEP[94] = 8'h0;
								end

								//setting heal indicator

								if (disease) begin
									SCREEN_SLEEP[106] = 8'h78;
									SCREEN_SLEEP[107] = 8'hFC;
									SCREEN_SLEEP[108] = 8'hFC;
									SCREEN_SLEEP[109] = 8'hFE;
									SCREEN_SLEEP[110] = 8'hED;
									SCREEN_SLEEP[111] = 8'hC5;
									SCREEN_SLEEP[112] = 8'hED;
									SCREEN_SLEEP[113] = 8'hFE;
									SCREEN_SLEEP[114] = 8'hFC;
									SCREEN_SLEEP[115] = 8'hFC;
									SCREEN_SLEEP[116] = 8'hF8;
								end 
								else begin
									SCREEN_SLEEP[106] = 8'h0;
									SCREEN_SLEEP[107] = 8'h0;
									SCREEN_SLEEP[108] = 8'h0;
									SCREEN_SLEEP[109] = 8'h0;
									SCREEN_SLEEP[110] = 8'h0;
									SCREEN_SLEEP[111] = 8'h0;
									SCREEN_SLEEP[112] = 8'h0;
									SCREEN_SLEEP[113] = 8'h0;
									SCREEN_SLEEP[114] = 8'h0;
									SCREEN_SLEEP[115] = 8'h0;
									SCREEN_SLEEP[116] = 8'h0;
								end

							end
							else if (state_fsm == 4) begin
								data_byte_in = SCREEN_EAT[data_counter-32];

								//setting food indicator

								if (food > 7'd67 && food <= 7'd100) begin
									SCREEN_EAT[31] = 8'h70;
									SCREEN_EAT[32] = 8'h88;
									SCREEN_EAT[33] = 8'h88;
									SCREEN_EAT[34] = 8'h86;
									SCREEN_EAT[35] = 8'h8B;
									SCREEN_EAT[36] = 8'h89; 
									SCREEN_EAT[37] = 8'h70;

									SCREEN_EAT[41] = 8'h70;
									SCREEN_EAT[42] = 8'h88; 
									SCREEN_EAT[43] = 8'h88;
									SCREEN_EAT[44] = 8'h86;
									SCREEN_EAT[45] = 8'h8B; 
									SCREEN_EAT[46] = 8'h89;
									SCREEN_EAT[47] = 8'h70;

									SCREEN_EAT[51] = 8'h70; 
									SCREEN_EAT[52] = 8'h88;
									SCREEN_EAT[53] = 8'h88;
									SCREEN_EAT[54] = 8'h86;  
									SCREEN_EAT[55] = 8'h8B;
									SCREEN_EAT[56] = 8'h89;
									SCREEN_EAT[57] = 8'h70;
								end
								else if (food > 7'd33 && food <= 7'd67) begin
									SCREEN_EAT[31] = 8'h70;
									SCREEN_EAT[32] = 8'h88;
									SCREEN_EAT[33] = 8'h88;
									SCREEN_EAT[34] = 8'h86;
									SCREEN_EAT[35] = 8'h8B;
									SCREEN_EAT[36] = 8'h89; 
									SCREEN_EAT[37] = 8'h70;

									SCREEN_EAT[41] = 8'h70;
									SCREEN_EAT[42] = 8'h88; 
									SCREEN_EAT[43] = 8'h88;
									SCREEN_EAT[44] = 8'h86;
									SCREEN_EAT[45] = 8'h8B; 
									SCREEN_EAT[46] = 8'h89;
									SCREEN_EAT[47] = 8'h70;

									SCREEN_EAT[51] = 8'h0; 
									SCREEN_EAT[52] = 8'h0;
									SCREEN_EAT[53] = 8'h0;
									SCREEN_EAT[54] = 8'h0;  
									SCREEN_EAT[55] = 8'h0;
									SCREEN_EAT[56] = 8'h0;
									SCREEN_EAT[57] = 8'h0;
								end
								else if (food >= 7'd0 && food <= 7'd33) begin
									SCREEN_EAT[31] = 8'h70;
									SCREEN_EAT[32] = 8'h88;
									SCREEN_EAT[33] = 8'h88;
									SCREEN_EAT[34] = 8'h86;
									SCREEN_EAT[35] = 8'h8B;
									SCREEN_EAT[36] = 8'h89; 
									SCREEN_EAT[37] = 8'h70;
									
									SCREEN_EAT[41] = 8'h0;
									SCREEN_EAT[42] = 8'h0; 
									SCREEN_EAT[43] = 8'h0;
									SCREEN_EAT[44] = 8'h0;
									SCREEN_EAT[45] = 8'h0; 
									SCREEN_EAT[46] = 8'h0;
									SCREEN_EAT[47] = 8'h0;
									
									SCREEN_EAT[51] = 8'h0; 
									SCREEN_EAT[52] = 8'h0;
									SCREEN_EAT[53] = 8'h0;
									SCREEN_EAT[54] = 8'h0;  
									SCREEN_EAT[55] = 8'h0;
									SCREEN_EAT[56] = 8'h0;
									SCREEN_EAT[57] = 8'h0;
								end

								//setting fun indicator

								if (fun > 7'd67 && fun <= 7'd100) begin
									SCREEN_EAT[12] = 8'h30;
									SCREEN_EAT[13] = 8'h40;
									SCREEN_EAT[14] = 8'h8F;
									SCREEN_EAT[15] = 8'h80;
									SCREEN_EAT[16] = 8'h8F;
									SCREEN_EAT[17] = 8'h40;
									SCREEN_EAT[18] = 8'h30;
								end
								if (fun > 7'd33 && fun <= 7'd67) begin
									SCREEN_EAT[12] = 8'h40;
									SCREEN_EAT[13] = 8'h40;
									SCREEN_EAT[14] = 8'h4F;
									SCREEN_EAT[15] = 8'h40;
									SCREEN_EAT[16] = 8'h4F;
									SCREEN_EAT[17] = 8'h40;
									SCREEN_EAT[18] = 8'h40;
								end
								if (fun >= 7'd0 && fun <= 7'd33) begin
									SCREEN_EAT[12] = 8'hC0;
									SCREEN_EAT[13] = 8'h20;
									SCREEN_EAT[14] = 8'h2F;
									SCREEN_EAT[15] = 8'h20;
									SCREEN_EAT[16] = 8'h2F;
									SCREEN_EAT[17] = 8'h20;
									SCREEN_EAT[18] = 8'hC0;
								end
								
								//setting rest indicator

								if (rest > 7'd67 && rest <= 7'd100) begin
									SCREEN_EAT[67] = 8'hC8;
									SCREEN_EAT[68] = 8'hA8;
									SCREEN_EAT[69] = 8'h98;
									SCREEN_EAT[70] = 8'h0;
									SCREEN_EAT[71] = 8'h31;
									SCREEN_EAT[72] = 8'h29; 
									SCREEN_EAT[73] = 8'h25;
									SCREEN_EAT[74] = 8'h23;

									SCREEN_EAT[77] = 8'hC8;
									SCREEN_EAT[78] = 8'hA8; 
									SCREEN_EAT[79] = 8'h98;
									SCREEN_EAT[80] = 8'h0;
									SCREEN_EAT[81] = 8'h31; 
									SCREEN_EAT[82] = 8'h29;
									SCREEN_EAT[83] = 8'h25;
									SCREEN_EAT[84] = 8'h23; 

									SCREEN_EAT[87] = 8'hC8; 
									SCREEN_EAT[88] = 8'hA8;
									SCREEN_EAT[89] = 8'h98;
									SCREEN_EAT[90] = 8'h0;  
									SCREEN_EAT[91] = 8'h31;
									SCREEN_EAT[92] = 8'h29;
									SCREEN_EAT[93] = 8'h25;  
									SCREEN_EAT[94] = 8'h23;
								end
								else if (rest > 7'd33 && rest <= 7'd67) begin
									SCREEN_EAT[67] = 8'hC8;
									SCREEN_EAT[68] = 8'hA8;
									SCREEN_EAT[69] = 8'h98;
									SCREEN_EAT[70] = 8'h0;
									SCREEN_EAT[71] = 8'h31;
									SCREEN_EAT[72] = 8'h29; 
									SCREEN_EAT[73] = 8'h25;
									SCREEN_EAT[74] = 8'h23;

									SCREEN_EAT[77] = 8'hC8;
									SCREEN_EAT[78] = 8'hA8; 
									SCREEN_EAT[79] = 8'h98;
									SCREEN_EAT[80] = 8'h0;
									SCREEN_EAT[81] = 8'h31; 
									SCREEN_EAT[82] = 8'h29;
									SCREEN_EAT[83] = 8'h25;
									SCREEN_EAT[84] = 8'h23; 

									SCREEN_EAT[87] = 8'h0; 
									SCREEN_EAT[88] = 8'h0;
									SCREEN_EAT[89] = 8'h0;
									SCREEN_EAT[90] = 8'h0;  
									SCREEN_EAT[91] = 8'h0;
									SCREEN_EAT[92] = 8'h0;
									SCREEN_EAT[93] = 8'h0;  
									SCREEN_EAT[94] = 8'h0;
								end
								else if (rest >= 7'd0 && rest <= 7'd33) begin
									SCREEN_EAT[67] = 8'hC8;
									SCREEN_EAT[68] = 8'hA8;
									SCREEN_EAT[69] = 8'h98;
									SCREEN_EAT[70] = 8'h0;
									SCREEN_EAT[71] = 8'h31;
									SCREEN_EAT[72] = 8'h29; 
									SCREEN_EAT[73] = 8'h25;
									SCREEN_EAT[74] = 8'h23;

									SCREEN_EAT[77] = 8'h0;
									SCREEN_EAT[78] = 8'h0; 
									SCREEN_EAT[79] = 8'h0;
									SCREEN_EAT[80] = 8'h0;
									SCREEN_EAT[81] = 8'h0; 
									SCREEN_EAT[82] = 8'h0;
									SCREEN_EAT[83] = 8'h0;
									SCREEN_EAT[84] = 8'h0; 

									SCREEN_EAT[87] = 8'h0; 
									SCREEN_EAT[88] = 8'h0;
									SCREEN_EAT[89] = 8'h0;
									SCREEN_EAT[90] = 8'h0;  
									SCREEN_EAT[91] = 8'h0;
									SCREEN_EAT[92] = 8'h0;
									SCREEN_EAT[93] = 8'h0;  
									SCREEN_EAT[94] = 8'h0;
								end

								//setting heal indicator

								if (disease) begin
									SCREEN_EAT[106] = 8'h78;
									SCREEN_EAT[107] = 8'hFC;
									SCREEN_EAT[108] = 8'hFC;
									SCREEN_EAT[109] = 8'hFE;
									SCREEN_EAT[110] = 8'hED;
									SCREEN_EAT[111] = 8'hC5;
									SCREEN_EAT[112] = 8'hED;
									SCREEN_EAT[113] = 8'hFE;
									SCREEN_EAT[114] = 8'hFC;
									SCREEN_EAT[115] = 8'hFC;
									SCREEN_EAT[116] = 8'hF8;
								end 
								else begin
									SCREEN_EAT[106] = 8'h0;
									SCREEN_EAT[107] = 8'h0;
									SCREEN_EAT[108] = 8'h0;
									SCREEN_EAT[109] = 8'h0;
									SCREEN_EAT[110] = 8'h0;
									SCREEN_EAT[111] = 8'h0;
									SCREEN_EAT[112] = 8'h0;
									SCREEN_EAT[113] = 8'h0;
									SCREEN_EAT[114] = 8'h0;
									SCREEN_EAT[115] = 8'h0;
									SCREEN_EAT[116] = 8'h0;
								end

								//setting character aspect

								if (act_eat) begin
									SCREEN_EAT[184] = 8'h0;
									SCREEN_EAT[185] = 8'h0;
									SCREEN_EAT[186] = 8'h0;
									SCREEN_EAT[187] = 8'h0;
									SCREEN_EAT[188] = 8'h0;
									SCREEN_EAT[189] = 8'h80;
									SCREEN_EAT[190] = 8'h80;
									SCREEN_EAT[191] = 8'h80;
									SCREEN_EAT[192] = 8'h80;
									SCREEN_EAT[193] = 8'h80;
									SCREEN_EAT[194] = 8'h80;
									SCREEN_EAT[195] = 8'h0;
									SCREEN_EAT[196] = 8'h0;
									SCREEN_EAT[197] = 8'h0;
									SCREEN_EAT[198] = 8'h0;
									SCREEN_EAT[199] = 8'h0;
									SCREEN_EAT[200] = 8'h0;
									SCREEN_EAT[201] = 8'h0;
									SCREEN_EAT[202] = 8'h0;
									SCREEN_EAT[203] = 8'h0;
									SCREEN_EAT[204] = 8'h0;
									
									SCREEN_EAT[311] = 8'h0;
									SCREEN_EAT[312] = 8'hE;
									SCREEN_EAT[313] = 8'hC9;
									SCREEN_EAT[314] = 8'h79;
									SCREEN_EAT[315] = 8'h79;
									SCREEN_EAT[316] = 8'h79;
									SCREEN_EAT[317] = 8'h78;
									SCREEN_EAT[318] = 8'h38;
									SCREEN_EAT[319] = 8'h80;
									SCREEN_EAT[320] = 8'h84;
									SCREEN_EAT[321] = 8'h2;
									SCREEN_EAT[322] = 8'h4;
									SCREEN_EAT[323] = 8'h81;
									SCREEN_EAT[324] = 8'h7E;
									SCREEN_EAT[325] = 8'h40;
									SCREEN_EAT[326] = 8'hC0;
									SCREEN_EAT[327] = 8'h0;
									SCREEN_EAT[328] = 8'h0;

									SCREEN_EAT[439] = 8'h80;
									SCREEN_EAT[440] = 8'h80;
									SCREEN_EAT[441] = 8'hE1;
									SCREEN_EAT[442] = 8'hD3;
									SCREEN_EAT[443] = 8'hF5;
									SCREEN_EAT[444] = 8'hCF;
									SCREEN_EAT[445] = 8'hC9;
									SCREEN_EAT[446] = 8'hF1;
									SCREEN_EAT[447] = 8'h90;
									SCREEN_EAT[448] = 8'hF0;
									SCREEN_EAT[449] = 8'hD1;
									SCREEN_EAT[450] = 8'hE8;
									SCREEN_EAT[451] = 8'hC2;
									SCREEN_EAT[452] = 8'hE6;
									SCREEN_EAT[453] = 8'hD9;
									SCREEN_EAT[454] = 8'hE0;
									SCREEN_EAT[455] = 8'h80;
								end
								else begin
									SCREEN_EAT[184] = 8'h0;
									SCREEN_EAT[185] = 8'h0;
									SCREEN_EAT[186] = 8'h0;
									SCREEN_EAT[187] = 8'h0;
									SCREEN_EAT[188] = 8'h80;
									SCREEN_EAT[189] = 8'h80;
									SCREEN_EAT[190] = 8'h80;
									SCREEN_EAT[191] = 8'h80;
									SCREEN_EAT[192] = 8'h80;
									SCREEN_EAT[193] = 8'h80;
									SCREEN_EAT[194] = 8'h80;
									SCREEN_EAT[195] = 8'h0;
									SCREEN_EAT[196] = 8'h0;
									SCREEN_EAT[197] = 8'h0;
									SCREEN_EAT[198] = 8'h0;
									SCREEN_EAT[199] = 8'h0;
									SCREEN_EAT[200] = 8'h0;
									SCREEN_EAT[201] = 8'h0;
									SCREEN_EAT[202] = 8'h0;
									SCREEN_EAT[203] = 8'h0;
									SCREEN_EAT[204] = 8'h0;
									
									SCREEN_EAT[311] = 8'h18;
									SCREEN_EAT[312] = 8'h34;
									SCREEN_EAT[313] = 8'h54;
									SCREEN_EAT[314] = 8'h52;
									SCREEN_EAT[315] = 8'hC3;
									SCREEN_EAT[316] = 8'hC0;
									SCREEN_EAT[317] = 8'h4A;
									SCREEN_EAT[318] = 8'h4A;
									SCREEN_EAT[319] = 8'hE;
									SCREEN_EAT[320] = 8'hC;
									SCREEN_EAT[321] = 8'h0;
									SCREEN_EAT[322] = 8'h80;
									SCREEN_EAT[323] = 8'h1;
									SCREEN_EAT[324] = 8'hC6;
									SCREEN_EAT[325] = 8'h38;
									SCREEN_EAT[326] = 8'h0;
									SCREEN_EAT[327] = 8'h0;
									SCREEN_EAT[328] = 8'h0;

									SCREEN_EAT[439] = 8'h80;
									SCREEN_EAT[440] = 8'h80;
									SCREEN_EAT[441] = 8'hE0;
									SCREEN_EAT[442] = 8'hD3;
									SCREEN_EAT[443] = 8'hF2;
									SCREEN_EAT[444] = 8'hCF;
									SCREEN_EAT[445] = 8'hCC;
									SCREEN_EAT[446] = 8'hF8;
									SCREEN_EAT[447] = 8'h90;
									SCREEN_EAT[448] = 8'h90;
									SCREEN_EAT[449] = 8'hF3;
									SCREEN_EAT[450] = 8'hC2;
									SCREEN_EAT[451] = 8'hE6;
									SCREEN_EAT[452] = 8'hC0;
									SCREEN_EAT[453] = 8'hE7;
									SCREEN_EAT[454] = 8'hD8;
									SCREEN_EAT[455] = 8'hE0;
								end
							end
							else if (state_fsm == 5) begin
								data_byte_in = SCREEN_HEAL[data_counter-32];

								//setting character aspect

								if (act_heal) begin
									SCREEN_HEAL[184] = 8'h0;
									SCREEN_HEAL[185] = 8'h0;
									SCREEN_HEAL[186] = 8'h0;
									SCREEN_HEAL[187] = 8'h0;
									SCREEN_HEAL[188] = 8'h80;
									SCREEN_HEAL[189] = 8'h80;
									SCREEN_HEAL[190] = 8'h80;
									SCREEN_HEAL[191] = 8'h80;
									SCREEN_HEAL[192] = 8'h80;
									SCREEN_HEAL[193] = 8'h80;
									SCREEN_HEAL[194] = 8'h0;
									SCREEN_HEAL[195] = 8'h0;
									SCREEN_HEAL[196] = 8'h0;
									SCREEN_HEAL[197] = 8'h0;
									SCREEN_HEAL[198] = 8'h0;
									SCREEN_HEAL[199] = 8'h0;
									SCREEN_HEAL[200] = 8'h0;
									SCREEN_HEAL[201] = 8'h0;
									SCREEN_HEAL[202] = 8'h0;
									SCREEN_HEAL[203] = 8'h0;
									SCREEN_HEAL[204] = 8'h0;
									
									SCREEN_HEAL[311] = 8'h2;
									SCREEN_HEAL[312] = 8'hC5;
									SCREEN_HEAL[313] = 8'h7D;
									SCREEN_HEAL[314] = 8'h7D;
									SCREEN_HEAL[315] = 8'h5D;
									SCREEN_HEAL[316] = 8'h5C;
									SCREEN_HEAL[317] = 8'h38;
									SCREEN_HEAL[318] = 8'h0;
									SCREEN_HEAL[319] = 8'hC;
									SCREEN_HEAL[320] = 8'h8E;
									SCREEN_HEAL[321] = 8'h2;
									SCREEN_HEAL[322] = 8'hB1;
									SCREEN_HEAL[323] = 8'h5E;
									SCREEN_HEAL[324] = 8'h10;
									SCREEN_HEAL[325] = 8'hF0;
									SCREEN_HEAL[326] = 8'h0;
									SCREEN_HEAL[327] = 8'h0;
									SCREEN_HEAL[328] = 8'h0;

									SCREEN_HEAL[439] = 8'h80;
									SCREEN_HEAL[440] = 8'hE1;
									SCREEN_HEAL[441] = 8'hD3;
									SCREEN_HEAL[442] = 8'hF5;
									SCREEN_HEAL[443] = 8'hCF;
									SCREEN_HEAL[444] = 8'hC9;
									SCREEN_HEAL[445] = 8'hF1;
									SCREEN_HEAL[446] = 8'h91;
									SCREEN_HEAL[447] = 8'hF1;
									SCREEN_HEAL[448] = 8'hD0;
									SCREEN_HEAL[449] = 8'hE8;
									SCREEN_HEAL[450] = 8'hC2;
									SCREEN_HEAL[451] = 8'hE6;
									SCREEN_HEAL[452] = 8'hD9;
									SCREEN_HEAL[453] = 8'hE0;
									SCREEN_HEAL[454] = 8'h80;
									SCREEN_HEAL[455] = 8'h80;
								end 
                                else begin 
                                    SCREEN_HEAL[184] = 8'h0;
									SCREEN_HEAL[185] = 8'h0;
									SCREEN_HEAL[186] = 8'h0;
									SCREEN_HEAL[187] = 8'h0;
									SCREEN_HEAL[188] = 8'h80;
									SCREEN_HEAL[189] = 8'h80;
									SCREEN_HEAL[190] = 8'h80;
									SCREEN_HEAL[191] = 8'h80;
									SCREEN_HEAL[192] = 8'h80;
									SCREEN_HEAL[193] = 8'h80;
									SCREEN_HEAL[194] = 8'h80;
									SCREEN_HEAL[195] = 8'h0;
									SCREEN_HEAL[196] = 8'h0;
									SCREEN_HEAL[197] = 8'h0;
									SCREEN_HEAL[198] = 8'h0;
									SCREEN_HEAL[199] = 8'h0;
									SCREEN_HEAL[200] = 8'h0;
									SCREEN_HEAL[201] = 8'h0;
									SCREEN_HEAL[202] = 8'h0;
									SCREEN_HEAL[203] = 8'h0;
									SCREEN_HEAL[204] = 8'h0;
									
									SCREEN_HEAL[311] = 8'h18;
									SCREEN_HEAL[312] = 8'h34;
									SCREEN_HEAL[313] = 8'h54;
									SCREEN_HEAL[314] = 8'h52;
									SCREEN_HEAL[315] = 8'hC3;
									SCREEN_HEAL[316] = 8'hC0;
									SCREEN_HEAL[317] = 8'h4A;
									SCREEN_HEAL[318] = 8'h4A;
									SCREEN_HEAL[319] = 8'hE;
									SCREEN_HEAL[320] = 8'hC;
									SCREEN_HEAL[321] = 8'h0;
									SCREEN_HEAL[322] = 8'h80;
									SCREEN_HEAL[323] = 8'h1;
									SCREEN_HEAL[324] = 8'hC6;
									SCREEN_HEAL[325] = 8'h38;
									SCREEN_HEAL[326] = 8'h0;
									SCREEN_HEAL[327] = 8'h0;
									SCREEN_HEAL[328] = 8'h0;

									SCREEN_HEAL[439] = 8'h80;
									SCREEN_HEAL[440] = 8'h80;
									SCREEN_HEAL[441] = 8'hE0;
									SCREEN_HEAL[442] = 8'hD3;
									SCREEN_HEAL[443] = 8'hF2;
									SCREEN_HEAL[444] = 8'hCF;
									SCREEN_HEAL[445] = 8'hCC;
									SCREEN_HEAL[446] = 8'hF8;
									SCREEN_HEAL[447] = 8'h90;
									SCREEN_HEAL[448] = 8'h90;
									SCREEN_HEAL[449] = 8'hF3;
									SCREEN_HEAL[450] = 8'hC2;
									SCREEN_HEAL[451] = 8'hE6;
									SCREEN_HEAL[452] = 8'hC0;
									SCREEN_HEAL[453] = 8'hE7;
									SCREEN_HEAL[454] = 8'hD8;
									SCREEN_HEAL[455] = 8'hE0;
								end

								//setting food indicator

								if (food > 7'd67 && food <= 7'd100) begin
									SCREEN_HEAL[31] = 8'h70;
									SCREEN_HEAL[32] = 8'h88;
									SCREEN_HEAL[33] = 8'h88;
									SCREEN_HEAL[34] = 8'h86;
									SCREEN_HEAL[35] = 8'h8B;
									SCREEN_HEAL[36] = 8'h89; 
									SCREEN_HEAL[37] = 8'h70;

									SCREEN_HEAL[41] = 8'h70;
									SCREEN_HEAL[42] = 8'h88; 
									SCREEN_HEAL[43] = 8'h88;
									SCREEN_HEAL[44] = 8'h86;
									SCREEN_HEAL[45] = 8'h8B; 
									SCREEN_HEAL[46] = 8'h89;
									SCREEN_HEAL[47] = 8'h70;

									SCREEN_HEAL[51] = 8'h70; 
									SCREEN_HEAL[52] = 8'h88;
									SCREEN_HEAL[53] = 8'h88;
									SCREEN_HEAL[54] = 8'h86;  
									SCREEN_HEAL[55] = 8'h8B;
									SCREEN_HEAL[56] = 8'h89;
									SCREEN_HEAL[57] = 8'h70;
								end
								else if (food > 7'd33 && food <= 7'd67) begin
									SCREEN_HEAL[31] = 8'h70;
									SCREEN_HEAL[32] = 8'h88;
									SCREEN_HEAL[33] = 8'h88;
									SCREEN_HEAL[34] = 8'h86;
									SCREEN_HEAL[35] = 8'h8B;
									SCREEN_HEAL[36] = 8'h89; 
									SCREEN_HEAL[37] = 8'h70;

									SCREEN_HEAL[41] = 8'h70;
									SCREEN_HEAL[42] = 8'h88; 
									SCREEN_HEAL[43] = 8'h88;
									SCREEN_HEAL[44] = 8'h86;
									SCREEN_HEAL[45] = 8'h8B; 
									SCREEN_HEAL[46] = 8'h89;
									SCREEN_HEAL[47] = 8'h70;

									SCREEN_HEAL[51] = 8'h0; 
									SCREEN_HEAL[52] = 8'h0;
									SCREEN_HEAL[53] = 8'h0;
									SCREEN_HEAL[54] = 8'h0;  
									SCREEN_HEAL[55] = 8'h0;
									SCREEN_HEAL[56] = 8'h0;
									SCREEN_HEAL[57] = 8'h0;
								end
								else if (food >= 7'd0 && food <= 7'd33) begin
									SCREEN_HEAL[31] = 8'h70;
									SCREEN_HEAL[32] = 8'h88;
									SCREEN_HEAL[33] = 8'h88;
									SCREEN_HEAL[34] = 8'h86;
									SCREEN_HEAL[35] = 8'h8B;
									SCREEN_HEAL[36] = 8'h89; 
									SCREEN_HEAL[37] = 8'h70;
									
									SCREEN_HEAL[41] = 8'h0;
									SCREEN_HEAL[42] = 8'h0; 
									SCREEN_HEAL[43] = 8'h0;
									SCREEN_HEAL[44] = 8'h0;
									SCREEN_HEAL[45] = 8'h0; 
									SCREEN_HEAL[46] = 8'h0;
									SCREEN_HEAL[47] = 8'h0;
									
									SCREEN_HEAL[51] = 8'h0; 
									SCREEN_HEAL[52] = 8'h0;
									SCREEN_HEAL[53] = 8'h0;
									SCREEN_HEAL[54] = 8'h0;  
									SCREEN_HEAL[55] = 8'h0;
									SCREEN_HEAL[56] = 8'h0;
									SCREEN_HEAL[57] = 8'h0;
								end

								//setting fun indicator

								if (fun > 7'd67 && fun <= 7'd100) begin
									SCREEN_HEAL[12] = 8'h30;
									SCREEN_HEAL[13] = 8'h40;
									SCREEN_HEAL[14] = 8'h8F;
									SCREEN_HEAL[15] = 8'h80;
									SCREEN_HEAL[16] = 8'h8F;
									SCREEN_HEAL[17] = 8'h40;
									SCREEN_HEAL[18] = 8'h30;
								end
								if (fun > 7'd33 && fun <= 7'd67) begin
									SCREEN_HEAL[12] = 8'h40;
									SCREEN_HEAL[13] = 8'h40;
									SCREEN_HEAL[14] = 8'h4F;
									SCREEN_HEAL[15] = 8'h40;
									SCREEN_HEAL[16] = 8'h4F;
									SCREEN_HEAL[17] = 8'h40;
									SCREEN_HEAL[18] = 8'h40;
								end
								if (fun >= 7'd0 && fun <= 7'd33) begin
									SCREEN_HEAL[12] = 8'hC0;
									SCREEN_HEAL[13] = 8'h20;
									SCREEN_HEAL[14] = 8'h2F;
									SCREEN_HEAL[15] = 8'h20;
									SCREEN_HEAL[16] = 8'h2F;
									SCREEN_HEAL[17] = 8'h20;
									SCREEN_HEAL[18] = 8'hC0;
								end
								
								//setting rest indicator

								if (rest > 7'd67 && rest <= 7'd100) begin
									SCREEN_HEAL[67] = 8'hC8;
									SCREEN_HEAL[68] = 8'hA8;
									SCREEN_HEAL[69] = 8'h98;
									SCREEN_HEAL[70] = 8'h0;
									SCREEN_HEAL[71] = 8'h31;
									SCREEN_HEAL[72] = 8'h29; 
									SCREEN_HEAL[73] = 8'h25;
									SCREEN_HEAL[74] = 8'h23;

									SCREEN_HEAL[77] = 8'hC8;
									SCREEN_HEAL[78] = 8'hA8; 
									SCREEN_HEAL[79] = 8'h98;
									SCREEN_HEAL[80] = 8'h0;
									SCREEN_HEAL[81] = 8'h31; 
									SCREEN_HEAL[82] = 8'h29;
									SCREEN_HEAL[83] = 8'h25;
									SCREEN_HEAL[84] = 8'h23; 

									SCREEN_HEAL[87] = 8'hC8; 
									SCREEN_HEAL[88] = 8'hA8;
									SCREEN_HEAL[89] = 8'h98;
									SCREEN_HEAL[90] = 8'h0;  
									SCREEN_HEAL[91] = 8'h31;
									SCREEN_HEAL[92] = 8'h29;
									SCREEN_HEAL[93] = 8'h25;  
									SCREEN_HEAL[94] = 8'h23;
								end
								else if (rest > 7'd33 && rest <= 7'd67) begin
									SCREEN_HEAL[67] = 8'hC8;
									SCREEN_HEAL[68] = 8'hA8;
									SCREEN_HEAL[69] = 8'h98;
									SCREEN_HEAL[70] = 8'h0;
									SCREEN_HEAL[71] = 8'h31;
									SCREEN_HEAL[72] = 8'h29; 
									SCREEN_HEAL[73] = 8'h25;
									SCREEN_HEAL[74] = 8'h23;

									SCREEN_HEAL[77] = 8'hC8;
									SCREEN_HEAL[78] = 8'hA8; 
									SCREEN_HEAL[79] = 8'h98;
									SCREEN_HEAL[80] = 8'h0;
									SCREEN_HEAL[81] = 8'h31; 
									SCREEN_HEAL[82] = 8'h29;
									SCREEN_HEAL[83] = 8'h25;
									SCREEN_HEAL[84] = 8'h23; 

									SCREEN_HEAL[87] = 8'h0; 
									SCREEN_HEAL[88] = 8'h0;
									SCREEN_HEAL[89] = 8'h0;
									SCREEN_HEAL[90] = 8'h0;  
									SCREEN_HEAL[91] = 8'h0;
									SCREEN_HEAL[92] = 8'h0;
									SCREEN_HEAL[93] = 8'h0;  
									SCREEN_HEAL[94] = 8'h0;
								end
								else if (rest >= 7'd0 && rest <= 7'd33) begin
									SCREEN_HEAL[67] = 8'hC8;
									SCREEN_HEAL[68] = 8'hA8;
									SCREEN_HEAL[69] = 8'h98;
									SCREEN_HEAL[70] = 8'h0;
									SCREEN_HEAL[71] = 8'h31;
									SCREEN_HEAL[72] = 8'h29; 
									SCREEN_HEAL[73] = 8'h25;
									SCREEN_HEAL[74] = 8'h23;

									SCREEN_HEAL[77] = 8'h0;
									SCREEN_HEAL[78] = 8'h0; 
									SCREEN_HEAL[79] = 8'h0;
									SCREEN_HEAL[80] = 8'h0;
									SCREEN_HEAL[81] = 8'h0; 
									SCREEN_HEAL[82] = 8'h0;
									SCREEN_HEAL[83] = 8'h0;
									SCREEN_HEAL[84] = 8'h0; 

									SCREEN_HEAL[87] = 8'h0; 
									SCREEN_HEAL[88] = 8'h0;
									SCREEN_HEAL[89] = 8'h0;
									SCREEN_HEAL[90] = 8'h0;  
									SCREEN_HEAL[91] = 8'h0;
									SCREEN_HEAL[92] = 8'h0;
									SCREEN_HEAL[93] = 8'h0;  
									SCREEN_HEAL[94] = 8'h0;
								end

								//setting heal indicator

								if (disease) begin
									SCREEN_HEAL[106] = 8'h78;
									SCREEN_HEAL[107] = 8'hFC;
									SCREEN_HEAL[108] = 8'hFC;
									SCREEN_HEAL[109] = 8'hFE;
									SCREEN_HEAL[110] = 8'hED;
									SCREEN_HEAL[111] = 8'hC5;
									SCREEN_HEAL[112] = 8'hED;
									SCREEN_HEAL[113] = 8'hFE;
									SCREEN_HEAL[114] = 8'hFC;
									SCREEN_HEAL[115] = 8'hFC;
									SCREEN_HEAL[116] = 8'hF8;
								end 
								else begin
									SCREEN_HEAL[106] = 8'h0;
									SCREEN_HEAL[107] = 8'h0;
									SCREEN_HEAL[108] = 8'h0;
									SCREEN_HEAL[109] = 8'h0;
									SCREEN_HEAL[110] = 8'h0;
									SCREEN_HEAL[111] = 8'h0;
									SCREEN_HEAL[112] = 8'h0;
									SCREEN_HEAL[113] = 8'h0;
									SCREEN_HEAL[114] = 8'h0;
									SCREEN_HEAL[115] = 8'h0;
									SCREEN_HEAL[116] = 8'h0;
								end

							end
							else if (state_fsm == 6) begin
								data_byte_in = SCREEN_DEATH[data_counter-32];
							end
								
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b01000000;
                            continue_bit = 0;
                        end
                    endcase
                end
        endcase
    end

endmodule