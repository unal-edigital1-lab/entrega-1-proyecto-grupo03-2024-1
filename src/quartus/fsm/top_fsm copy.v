`timescale 1ns / 1ps

module top_fsm_copy(
    input clk,
    input btn_reset,
    input btn_cancel,
    input btn_test,
    input btn_action,
    input echo,
    input enable,
    inout wire scl_display,
    inout wire sda_display,
    inout wire scl_converter,
    inout wire sda_converter,
    output led_left,
    output led_middle,
    output led_right,
    output led_action,
	output led_reset,
	output led_cancel,
	output led_test,
    output trigger,
    output level1,
    output level2
);

top_ads1115 UTT_joystick (
    .clk(clk),
	.sw(btn_action),
    .sda(sda_converter),
    .scl(scl_converter),
    .led1(led_left),
    .led2(led_middle),
    .led3(led_right),
	.led4(led_action)
);

top_hcsr04 UTT_ultrasonido (
    .clk(clk),
    .echo(echo),
    .enable(enable),
    .trigger(trigger),
    .level1(level1),
    .level2(level2)
);

top_oled UUT_oled (
	.clk(clk),
	.send_pixels(send_pixels),
	.sda(sda_display), 
	.scl(scl_display)
);

reg [6:0] life = 7'd100;
reg [6:0] food = 7'd100;
reg [6:0] fun = 7'd100;
reg [6:0] rest = 7'd100;
reg [6:0] medicines = 0;
reg disease = 0;
reg death = 0;

reg [7:0] pixels_oled [511:0];
reg [7:0] pixels_default [511:0];
reg [7:0] pixels_main [511:0];
reg [7:0] pixels_eat_menu [511:0];
reg [7:0] pixels_play_menu [511:0];

assign led_reset = ~btn_reset;
assign led_cancel = ~btn_cancel;
assign led_test = ~btn_test;

initial begin
    $readmemh("D:/Personal/1-Universidad nacional/Semestre 6/Digital 1/Github/entrega-1-proyecto-grupo03-2024-1/src/quartus/fsm/pixels_oled.men", pixels_oled, 0, 511);
	 $readmemh("D:/Personal/1-Universidad nacional/Semestre 6/Digital 1/Github/entrega-1-proyecto-grupo03-2024-1/src/quartus/fsm/pixels_main.men", pixels_main, 0, 511);
    $readmemh("D:/Personal/1-Universidad nacional/Semestre 6/Digital 1/Github/entrega-1-proyecto-grupo03-2024-1/src/quartus/fsm/pixels_default.men", pixels_default, 0, 511);
	 $readmemh("D:/Personal/1-Universidad nacional/Semestre 6/Digital 1/Github/entrega-1-proyecto-grupo03-2024-1/src/quartus/fsm/pixels_eat_menu.men", pixels_eat_menu, 0, 511);
	 $readmemh("D:/Personal/1-Universidad nacional/Semestre 6/Digital 1/Github/entrega-1-proyecto-grupo03-2024-1/src/quartus/fsm/pixels_play_menu.men", pixels_play_menu, 0, 511);
end

// clocks

reg [25:0] cont_clk_1s = 0;
reg clk_1s = 0;

always @(posedge clk) begin
    if (cont_clk_1s == 26'd50000000/10) begin
        clk_1s <= ~clk_1s;
        cont_clk_1s <= 0;
    end
    else begin
        cont_clk_1s <= cont_clk_1s + 1'd1;
    end
end

// manage needs values

localparam LIFE_PLUS = 7'd70;
localparam LIFE_MINUS = 5'd30;

reg [5:0] cont_food = 0;
reg [5:0] cont_fun = 0;
reg [5:0] cont_rest = 0;

always @(negedge clk_1s) begin
    cont_food = cont_food + 1'b1;
    cont_fun = cont_fun + 1'b1;
    cont_rest = cont_rest + 1'b1;

    if (cont_food >= 5'd1 && food > 0) begin
        food <= food - 1'b1;
        cont_food <= 0;
    end

    if (cont_fun >= 5'd1 && fun > 0) begin
        fun <= fun - 1'b1;
        cont_fun <= 0;
    end

    if (cont_rest >= 5'd1 && rest > 0) begin
        rest <= rest - 1'b1;
        cont_rest <= 0;
    end

    //life minus

    if (food <= LIFE_MINUS && life > 0) begin
        life = life - 1'b1;
    end

    if (fun <= LIFE_MINUS && life > 0) begin
        life = life - 1'b1;
    end

    if (rest <= LIFE_MINUS && life > 0) begin
        life = life - 1'b1;
    end

    //life plus

    if (food >= LIFE_PLUS && life < 100) begin
        life = life + 1'b1;
    end

    if (fun >= LIFE_PLUS && life < 100) begin
        life = life + 1'b1;
    end

    if (rest >= LIFE_PLUS && life < 100) begin
        life = life + 1'b1;
    end
end

// verify disease and death

always @(posedge clk) begin 
    if (life <= 20) begin
        disease <= 1;
    end
    else begin
        disease <= 0;
    end

    if (life == 0) begin
        death = 1;
    end
    else begin
        death = 0;
    end
end

// fsm

localparam START = 4'd0;
localparam MAIN = 4'd1;
localparam PLAY = 4'd2;
localparam SLEEP = 4'd3;
localparam EAT = 4'd4;
localparam HEAL = 4'd5;
localparam DEATH = 4'd6;

reg [3:0] state = MAIN;

localparam IND_PLAY = 4'd0;
localparam IND_EAT = 4'd1;
localparam IND_SLEEP = 4'd2;
localparam IND_HEAL = 4'd3;

reg [3:0] ind_select = IND_EAT;
integer i;

reg [4095:0] send_pixels;
reg [7:0] oled_column;

always @(posedge clk) begin

	for (i=0; i<=511; i=i+1) begin
		oled_column = pixels_oled[i];
		send_pixels[4095 - i * 8 -: 8] = oled_column;
	end

    case (state)
        START: begin
        end

        MAIN: begin
		  
				//setting life indicator
		  
				if(life> 7'd83 && life <= 7'd100)begin
                pixels_oled[483] = 8'hE;
					 pixels_oled[484] = 8'h1D;
					 pixels_oled[485] = 8'h3F;
					 pixels_oled[486] = 8'h7E;
					 pixels_oled[487] = 8'h3F;
					 pixels_oled[488] = 8'h1F;
					 pixels_oled[489] = 8'hE;
					 
					 pixels_oled[492] = 8'hE;
					 pixels_oled[493] = 8'h1D;
					 pixels_oled[494] = 8'h3F;
					 pixels_oled[495] = 8'h7E;
					 pixels_oled[496] = 8'h3F;
					 pixels_oled[497] = 8'h1F;
					 pixels_oled[498] = 8'hE;

					 pixels_oled[501] = 8'hE;
					 pixels_oled[502] = 8'h1D;
					 pixels_oled[503] = 8'h3F;
					 pixels_oled[504] = 8'h7E;
					 pixels_oled[505] = 8'h3F;
					 pixels_oled[506] = 8'h1F;
					 pixels_oled[507] = 8'hE;

            end
            else if(life> 7'd67 && life <= 7'd83)begin
				
					 pixels_oled[483] = 8'hE;
					 pixels_oled[484] = 8'h1D;
					 pixels_oled[485] = 8'h3F;
					 pixels_oled[486] = 8'h7E;
					 pixels_oled[487] = 8'h3F;
					 pixels_oled[488] = 8'h1F;
					 pixels_oled[489] = 8'hE;
					 
					 pixels_oled[492] = 8'hE;
					 pixels_oled[493] = 8'h1D;
					 pixels_oled[494] = 8'h3F;
					 pixels_oled[495] = 8'h7E;
					 pixels_oled[496] = 8'h3F;
					 pixels_oled[497] = 8'h1F;
					 pixels_oled[498] = 8'hE;
				
                pixels_oled[501] = 8'hE;
					 pixels_oled[502] = 8'h1D;
					 pixels_oled[503] = 8'h3F;
					 pixels_oled[504] = 8'h7E;
					 pixels_oled[505] = 8'h0;
					 pixels_oled[506] = 8'h0;
					 pixels_oled[507] = 8'h0;    
            end
            else if(life> 7'd50 && life <= 7'd67)begin
                pixels_oled[483] = 8'hE;
					 pixels_oled[484] = 8'h1D;
					 pixels_oled[485] = 8'h3F;
					 pixels_oled[486] = 8'h7E;
					 pixels_oled[487] = 8'h3F;
					 pixels_oled[488] = 8'h1F;
					 pixels_oled[489] = 8'hE;
					 
					 pixels_oled[492] = 8'hE;
					 pixels_oled[493] = 8'h1D;
					 pixels_oled[494] = 8'h3F;
					 pixels_oled[495] = 8'h7E;
					 pixels_oled[496] = 8'h3F;
					 pixels_oled[497] = 8'h1F;
					 pixels_oled[498] = 8'hE;
				
                pixels_oled[501] = 8'h0;
					 pixels_oled[502] = 8'h0;
					 pixels_oled[503] = 8'h0;
					 pixels_oled[504] = 8'h0;
					 pixels_oled[505] = 8'h0;
					 pixels_oled[506] = 8'h0;
					 pixels_oled[507] = 8'h0;
            end
            else if(life> 7'd33 && life <= 7'd50)begin
                pixels_oled[483] = 8'hE;
					 pixels_oled[484] = 8'h1D;
					 pixels_oled[485] = 8'h3F;
					 pixels_oled[486] = 8'h7E;
					 pixels_oled[487] = 8'h3F;
					 pixels_oled[488] = 8'h1F;
					 pixels_oled[489] = 8'hE;
					 
					 pixels_oled[492] = 8'hE;
					 pixels_oled[493] = 8'h1D;
					 pixels_oled[494] = 8'h3F;
					 pixels_oled[495] = 8'h7E;
					 pixels_oled[496] = 8'h0;
					 pixels_oled[497] = 8'h0;
					 pixels_oled[498] = 8'h0;
				
                pixels_oled[501] = 8'h0;
					 pixels_oled[502] = 8'h0;
					 pixels_oled[503] = 8'h0;
					 pixels_oled[504] = 8'h0;
					 pixels_oled[505] = 8'h0;
					 pixels_oled[506] = 8'h0;
					 pixels_oled[507] = 8'h0;
            end
            else if(life> 7'd16 && life <= 7'd33)begin
                pixels_oled[483] = 8'hE;
					 pixels_oled[484] = 8'h1D;
					 pixels_oled[485] = 8'h3F;
					 pixels_oled[486] = 8'h7E;
					 pixels_oled[487] = 8'h3F;
					 pixels_oled[488] = 8'h1F;
					 pixels_oled[489] = 8'hE;
					 
					 pixels_oled[492] = 8'h0;
					 pixels_oled[493] = 8'h0;
					 pixels_oled[494] = 8'h0;
					 pixels_oled[495] = 8'h0;
					 pixels_oled[496] = 8'h0;
					 pixels_oled[497] = 8'h0;
					 pixels_oled[498] = 8'h0;
				
                pixels_oled[501] = 8'h0;
					 pixels_oled[502] = 8'h0;
					 pixels_oled[503] = 8'h0;
					 pixels_oled[504] = 8'h0;
					 pixels_oled[505] = 8'h0;
					 pixels_oled[506] = 8'h0;
					 pixels_oled[507] = 8'h0;
            end
            else if(life> 7'd0 && life <= 7'd16)begin
                pixels_oled[483] = 8'hE;
					 pixels_oled[484] = 8'h1D;
					 pixels_oled[485] = 8'h3F;
					 pixels_oled[486] = 8'h7E;
					 pixels_oled[487] = 8'h0;
					 pixels_oled[488] = 8'h0;
					 pixels_oled[489] = 8'h0;
					 
					 pixels_oled[492] = 8'h0;
					 pixels_oled[493] = 8'h0;
					 pixels_oled[494] = 8'h0;
					 pixels_oled[495] = 8'h0;
					 pixels_oled[496] = 8'h0;
					 pixels_oled[497] = 8'h0;
					 pixels_oled[498] = 8'h0;
				
                pixels_oled[501] = 8'h0;
					 pixels_oled[502] = 8'h0;
					 pixels_oled[503] = 8'h0;
					 pixels_oled[504] = 8'h0;
					 pixels_oled[505] = 8'h0;
					 pixels_oled[506] = 8'h0;
					 pixels_oled[507] = 8'h0;
            end
				
				//setting food indicator
				
				if(food> 7'd67 && food <= 7'd100)begin
                pixels_oled[31] = 8'h70;
                pixels_oled[32] = 8'h88;
                pixels_oled[33] = 8'h8;
                pixels_oled[34] = 8'h6;
                pixels_oled[35] = 8'hB;
                pixels_oled[36] = 8'h89; 
                pixels_oled[37] = 8'h70;
;
                pixels_oled[41] = 8'h70;
                pixels_oled[42] = 8'h88; 
                pixels_oled[43] = 8'h8;
                pixels_oled[44] = 8'h6;
                pixels_oled[45] = 8'hB; 
                pixels_oled[46] = 8'h89;
                pixels_oled[47] = 8'h70;

                pixels_oled[51] = 8'h70; 
                pixels_oled[52] = 8'h88;
                pixels_oled[53] = 8'h8;
                pixels_oled[54] = 8'h6;  
                pixels_oled[55] = 8'hB;
                pixels_oled[56] = 8'h89;
                pixels_oled[57] = 8'h70;
					 
                pixels_oled[161] = 8'h1;
                pixels_oled[162] = 8'h1;
                pixels_oled[163] = 8'h1;
					 
                pixels_oled[171] = 8'h1;
                pixels_oled[172] = 8'h1;
                pixels_oled[173] = 8'h1;
					 
                pixels_oled[181] = 8'h1;
                pixels_oled[182] = 8'h1;
                pixels_oled[183] = 8'h1;

            end
            else if (food> 7'd33 && food <= 7'd67)begin
                pixels_oled[31] = 8'h70;
                pixels_oled[32] = 8'h88;
                pixels_oled[33] = 8'h8;
                pixels_oled[34] = 8'h6;
                pixels_oled[35] = 8'hB;
                pixels_oled[36] = 8'h89; 
                pixels_oled[37] = 8'h70;

                pixels_oled[41] = 8'h70;
                pixels_oled[42] = 8'h88; 
                pixels_oled[43] = 8'h8;
                pixels_oled[44] = 8'h6;
                pixels_oled[45] = 8'hB; 
                pixels_oled[46] = 8'h89;
                pixels_oled[47] = 8'h70;

                pixels_oled[51] = 8'h0; 
                pixels_oled[52] = 8'h0;
                pixels_oled[53] = 8'h0;
                pixels_oled[54] = 8'h0;  
                pixels_oled[55] = 8'h0;
                pixels_oled[56] = 8'h0;
                pixels_oled[57] = 8'h0;
					 
                pixels_oled[161] = 8'h1;
                pixels_oled[162] = 8'h1;
                pixels_oled[163] = 8'h1;
					 
                pixels_oled[171] = 8'h1;
                pixels_oled[172] = 8'h1;
                pixels_oled[173] = 8'h1;
					 
                pixels_oled[181] = 8'h0;
                pixels_oled[182] = 8'h0;
                pixels_oled[183] = 8'h0; 
            end
            else if (food> 7'd0 && food <= 7'd33)begin
                pixels_oled[31] = 8'h70;
                pixels_oled[32] = 8'h88;
                pixels_oled[33] = 8'h8;
                pixels_oled[34] = 8'h6;
                pixels_oled[35] = 8'hB;
                pixels_oled[36] = 8'h89; 
                pixels_oled[37] = 8'h70;
                
                pixels_oled[41] = 8'h0;
                pixels_oled[42] = 8'h0; 
                pixels_oled[43] = 8'h0;
                pixels_oled[44] = 8'h0;
                pixels_oled[45] = 8'h0; 
                pixels_oled[46] = 8'h0;
                pixels_oled[47] = 8'h0;
                
                pixels_oled[51] = 8'h0; 
                pixels_oled[52] = 8'h0;
                pixels_oled[53] = 8'h0;
                pixels_oled[54] = 8'h0;  
                pixels_oled[55] = 8'h0;
                pixels_oled[56] = 8'h0;
                pixels_oled[57] = 8'h0;
					 
                pixels_oled[161] = 8'h1;
                pixels_oled[162] = 8'h1;
                pixels_oled[163] = 8'h1;
					 
                pixels_oled[171] = 8'h0;
                pixels_oled[172] = 8'h0;
                pixels_oled[173] = 8'h0;
					 
                pixels_oled[181] = 8'h0;
                pixels_oled[182] = 8'h0;
                pixels_oled[183] = 8'h0; 
            end
				
				//setting fun indicator
				
				if(fun> 7'd67 && fun <= 7'd100)begin
                pixels_oled[14] = 8'h6D;
                pixels_oled[15] = 8'h41; 
                pixels_oled[16] = 8'h6D;
            end
            if(fun> 7'd33 && fun <= 7'd67)begin
                pixels_oled[14] = 8'h4D;
                pixels_oled[15] = 8'h41; 
                pixels_oled[16] = 8'h4D;
            end
            if(fun> 7'd0 && fun <= 7'd33)begin
                pixels_oled[14] = 8'h6D;
                pixels_oled[15] = 8'h21; 
                pixels_oled[16] = 8'h6D;
            end
				
				//setting rest indicator
				
				if(rest> 7'd67 && rest <= 7'd100)begin
                pixels_oled[67] = 8'h90;
                pixels_oled[68] = 8'h50;
                pixels_oled[69] = 8'h30;
                pixels_oled[70] = 8'h0;
                pixels_oled[71] = 8'h31;
                pixels_oled[72] = 8'h29; 
                pixels_oled[73] = 8'h25;
                pixels_oled[74] = 8'h23;

                pixels_oled[77] = 8'h90;
                pixels_oled[78] = 8'h50; 
                pixels_oled[79] = 8'h30;
                pixels_oled[80] = 8'h0;
                pixels_oled[81] = 8'h31; 
                pixels_oled[82] = 8'h29;
                pixels_oled[83] = 8'h25;
                pixels_oled[84] = 8'h23; 

                pixels_oled[87] = 8'h90; 
                pixels_oled[88] = 8'h50;
                pixels_oled[89] = 8'h30;
                pixels_oled[90] = 8'h0;  
                pixels_oled[91] = 8'h31;
                pixels_oled[92] = 8'h29;
                pixels_oled[93] = 8'h25;  
                pixels_oled[94] = 8'h23;
					 
                pixels_oled[195] = 8'h1;
                pixels_oled[196] = 8'h1;
                pixels_oled[197] = 8'h1;
                pixels_oled[205] = 8'h1;
                pixels_oled[206] = 8'h1;
                pixels_oled[207] = 8'h1;
                pixels_oled[215] = 8'h1;
                pixels_oled[216] = 8'h1;
                pixels_oled[217] = 8'h1;
            end
            else if(rest> 7'd33 && rest <= 7'd67)begin
                pixels_oled[67] = 8'h90;
                pixels_oled[68] = 8'h50;
                pixels_oled[69] = 8'h30;
                pixels_oled[70] = 8'h0;
                pixels_oled[71] = 8'h31;
                pixels_oled[72] = 8'h29; 
                pixels_oled[73] = 8'h25;
                pixels_oled[74] = 8'h23;
					 
                pixels_oled[77] = 8'h90;
                pixels_oled[78] = 8'h50; 
                pixels_oled[79] = 8'h30;
                pixels_oled[80] = 8'h0;
                pixels_oled[81] = 8'h31; 
                pixels_oled[82] = 8'h29;
                pixels_oled[83] = 8'h25;
                pixels_oled[84] = 8'h23; 

                pixels_oled[87] = 8'h0; 
                pixels_oled[88] = 8'h0;
                pixels_oled[89] = 8'h0;
                pixels_oled[90] = 8'h0;  
                pixels_oled[91] = 8'h0;
                pixels_oled[92] = 8'h0;
                pixels_oled[93] = 8'h0;  
                pixels_oled[94] = 8'h0;
					 
                pixels_oled[195] = 8'h1;
                pixels_oled[196] = 8'h1;
                pixels_oled[197] = 8'h1;
                pixels_oled[205] = 8'h1;
                pixels_oled[206] = 8'h1;
                pixels_oled[207] = 8'h1;
                pixels_oled[215] = 8'h0;
                pixels_oled[216] = 8'h0;
                pixels_oled[217] = 8'h0;
            end
            else if(rest> 7'd0 && rest <= 7'd33)begin
                pixels_oled[67] = 8'h90;
                pixels_oled[68] = 8'h50;
                pixels_oled[69] = 8'h30;
                pixels_oled[70] = 8'h0;
                pixels_oled[71] = 8'h31;
                pixels_oled[72] = 8'h29; 
                pixels_oled[73] = 8'h25;
                pixels_oled[74] = 8'h23;

                pixels_oled[77] = 8'h0;
                pixels_oled[78] = 8'h0; 
                pixels_oled[79] = 8'h0;
                pixels_oled[80] = 8'h0;
                pixels_oled[81] = 8'h0; 
                pixels_oled[82] = 8'h0;
                pixels_oled[83] = 8'h0;
                pixels_oled[84] = 8'h0; 

                pixels_oled[87] = 8'h0; 
                pixels_oled[88] = 8'h0;
                pixels_oled[89] = 8'h0;
                pixels_oled[90] = 8'h0;  
                pixels_oled[91] = 8'h0;
                pixels_oled[92] = 8'h0;
                pixels_oled[93] = 8'h0;  
                pixels_oled[94] = 8'h0;
					 
                pixels_oled[195] = 8'h1;
                pixels_oled[196] = 8'h1;
                pixels_oled[197] = 8'h1;
                pixels_oled[205] = 8'h0;
                pixels_oled[206] = 8'h0;
                pixels_oled[207] = 8'h0;
                pixels_oled[215] = 8'h0;
                pixels_oled[216] = 8'h0;
                pixels_oled[217] = 8'h0;
            end
				
				//setting heal indicator
				
				if (disease) begin
					pixels_oled[106] = 8'hF8;
					pixels_oled[107] = 8'hFC;
					pixels_oled[108] = 8'hFC;
					pixels_oled[109] = 8'hFE;
					pixels_oled[110] = 8'hDD;
					pixels_oled[111] = 8'h8D;
					pixels_oled[112] = 8'hDD;
					pixels_oled[113] = 8'hFE;
					pixels_oled[114] = 8'hFC;
					pixels_oled[115] = 8'hFC;
					pixels_oled[116] = 8'hF8;
					
					pixels_oled[235] = 8'h1;
					pixels_oled[236] = 8'h1;
					pixels_oled[237] = 8'h1;
					pixels_oled[238] = 8'h1;
					pixels_oled[239] = 8'h1;
					pixels_oled[240] = 8'h1;
					pixels_oled[241] = 8'h1;
					pixels_oled[242] = 8'h1;
					pixels_oled[243] = 8'h1;
				end else
				begin
					pixels_oled[106] = 8'h0;
					pixels_oled[107] = 8'h0;
					pixels_oled[108] = 8'h0;
					pixels_oled[109] = 8'h0;
					pixels_oled[110] = 8'h0;
					pixels_oled[111] = 8'h0;
					pixels_oled[112] = 8'h0;
					pixels_oled[113] = 8'h0;
					pixels_oled[114] = 8'h0;
					pixels_oled[115] = 8'h0;
					pixels_oled[116] = 8'h0;
					
					pixels_oled[235] = 8'h0;
					pixels_oled[236] = 8'h0;
					pixels_oled[237] = 8'h0;
					pixels_oled[238] = 8'h0;
					pixels_oled[239] = 8'h0;
					pixels_oled[240] = 8'h0;
					pixels_oled[241] = 8'h0;
					pixels_oled[242] = 8'h0;
					pixels_oled[243] = 8'h0;
				end

            case (ind_select) 
                IND_PLAY: begin
						for (i=128; i<138; i=i+1) begin
							pixels_oled[i][3] = 0;
						end
						for (i=138; i<149; i=i+1) begin
							pixels_oled[i][3] = 1;
						end
						for (i=149; i<256; i=i+1) begin
							pixels_oled[i][3] = 0;
						end
                end
					 
                IND_EAT: begin
						for (i=128; i<159; i=i+1) begin
							pixels_oled[i][3] = 0;
						end
						for (i=159; i<186; i=i+1) begin
							pixels_oled[i][3] = 1;
						end
						for (i=186; i<256; i=i+1) begin
							pixels_oled[i][3] = 0;
						end
                end
					 
					 IND_SLEEP: begin
						for (i=128; i<195; i=i+1) begin
							pixels_oled[i][3] = 0;
						end
						for (i=195; i<223; i=i+1) begin
							pixels_oled[i][3] = 1;
						end
						for (i=223; i<256; i=i+1) begin
							pixels_oled[i][3] = 0;
						end
                end
					 
                IND_HEAL: begin
                  for (i=128; i<234; i=i+1) begin
							pixels_oled[i][3] = 0;
						end
						for (i=234; i<245; i=i+1) begin
							pixels_oled[i][3] = 1;
						end
						for (i=245; i<256; i=i+1) begin
							pixels_oled[i][3] = 0;
						end
                end
            endcase
        end

        PLAY: begin
				for (i = 0; i < 512; i = i + 1) begin
					pixels_oled[i] <= pixels_play_menu[i];
				end
			end

        SLEEP: begin
        end

        EAT: begin
        end

        HEAL: begin
        end

        DEATH: begin
        end
    endcase
end

reg btn_left;
reg btn_middle;
reg btn_right;

reg enable_btn_joystick = 1;
reg [26:0] cont_enable_btn_joystick = 0;

reg enable_btn_action = 1;
reg [26:0] cont_enable_btn_action = 0;

reg band = 0;

localparam DELAY_TIME_BUTTONS = 26'd25000000;

always @(posedge clk) begin

	btn_left <= ~led_left;
	btn_right <= ~led_right;

    if (state == MAIN) begin

        if (!enable_btn_joystick) begin
            if (cont_enable_btn_joystick == DELAY_TIME_BUTTONS) begin
                enable_btn_joystick <= 1;
                cont_enable_btn_joystick <= 0;
            end
            else begin
                cont_enable_btn_joystick <= cont_enable_btn_joystick + 1;
            end
        end
		  
		  if (band) begin
				state <= 2;
		  end
		  

			if (btn_left == 1 && enable_btn_joystick) begin
            enable_btn_joystick <= 0;
            if (ind_select != IND_PLAY) begin
                ind_select <= ind_select - 1'b1;
            end
        end

        if (btn_right == 1 && enable_btn_joystick) begin
            enable_btn_joystick <= 0;
            if (ind_select == IND_SLEEP && disease == 1) begin
                ind_select <= ind_select + 1'b1;
            end
            else if (ind_select != IND_HEAL && ind_select != IND_SLEEP) begin
                ind_select <= ind_select + 1'b1;
            end
        end
        
    end
end

endmodule