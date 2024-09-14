`timescale 1ns / 1ps

module top (
    input clk,
    input btn_reset,
    input btn_cancel,
    input btn_test,
    input btn_action,
    inout wire scl_display,
    inout wire sda_display,
    inout wire scl_converter,
    inout wire sda_converter,
    inout wire buzzer,
    output wire trigger
);

reg btn_left;
reg btn_right;

reg [6:0] life = 7'd100;
reg [6:0] food = 7'd50;
reg [6:0] fun = 7'd50;
reg [6:0] rest = 7'd50;
reg [6:0] medicines = 0;
reg [15:0] random_medicine = 0;
reg disease = 0;
reg death = 0;

reg [7:0] pixels_oled [511:0];
reg [7:0] pixels_default [511:0];

initial begin
    $readmemh("D:/Personal/1-Universidad nacional/Semestre 6/Digital 1/Github/entrega-1-proyecto-grupo03-2024-1/src/fsm/pixels_oled.men", pixels_oled, 0, 511);
    $readmemh("D:/Personal/1-Universidad nacional/Semestre 6/Digital 1/Github/entrega-1-proyecto-grupo03-2024-1/src/fsm/pixels_default.men", pixels_default, 0, 511);
end

reg [25:0] cont_clk_1s = 0;
reg clk_1s = 0;

// clocks

always @(posedge clk) begin
    if (cont_clk_1s == 26'd50000000/100000) begin
        clk_1s <= ~clk_1s;
        cont_clk_1s <= 0;
    end
    else begin
        cont_clk_1s <= cont_clk_1s + 1'd1;
    end
end

reg [26:0] cont_clk_2s = 0;
reg clk_2s = 0;

always @(posedge clk) begin
    if (cont_clk_2s == 27'd100000000) begin
        clk_2s <= ~clk_2s;
        cont_clk_2s <= 0;
    end
    else begin
        cont_clk_2s <= cont_clk_2s + 1'd1;
    end
end

// manage needs values

localparam LIFE_PLUS = 7'd70;
localparam LIFE_MINUS = 5'd30;

reg [5:0] cont_food = 0;
reg [27:0] cont_food2 = 28'd150000000;
reg [5:0] cont_fun = 0;
reg [27:0] cont_fun2 = 28'd150000000;
reg [5:0] cont_rest = 0;
reg [27:0] cont_rest2= 28'd150000000;
reg [27:0] cont_heal2 = 28'd150000000;

always @(negedge clk_1s) begin
    cont_food = cont_food + 1'b1;
    cont_fun = cont_fun + 1'b1;
    cont_rest = cont_rest + 1'b1;

    if (cont_food >= 5'd3) begin
        food <= food - 1'b1;
        cont_food <= 0;
    end

    if (cont_fun >= 5'd4) begin
        fun <= fun - 1'b1;
        cont_fun <= 0;
    end

    if (cont_rest >= 5'd5) begin
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
        //TODO mostrar indicador de heal
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
localparam DEATH = 5'd6;

reg [3:0] state = START;

localparam IND_PLAY = 4'd0;
localparam IND_SLEEP = 4'd1;
localparam IND_EAT = 4'd2;
localparam IND_HEAL = 4'd3;

reg [3:0] ind_select = IND_PLAY;
integer i;

always @(posedge clk) begin
    random_medicine = random_medicine + 1'd1;
    case (state)
        START: begin
        end

        MAIN: begin
            // introducir la imagen principal, sin heal
            for (i=128; i<256; i = i + 1) begin
                pixels_oled[i][4] = 0;
            end
            if(fun> 7'd67 && fun <= 7'd100)begin
                pixels_oled[10] = 8'h38;
                pixels_oled[11] = 8'h44;
                pixels_oled[12] = 8'h82;
                pixels_oled[13] = 8'h82;
                pixels_oled[14] = 8'h6D;
                pixels_oled[15] = 8'h41; 
                pixels_oled[16] = 8'h6D;
                pixels_oled[17] = 8'h82;
                pixels_oled[18] = 8'h82; 
                pixels_oled[19] = 8'h44;
                pixels_oled[20] = 8'h38;
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

            if(rest> 7'd67 && rest <= 7'd100)begin
                pixels_oled[67] = 8'h90;
                pixels_oled[68] = 8'h50;
                pixels_oled[69] = 8'h30;
                pixels_oled[70] = 8'h0;
                pixels_oled[71] = 8'h31;
                pixels_oled[72] = 8'h29; 
                pixels_oled[73] = 8'h25;
                pixels_oled[74] = 8'h23;
                pixels_oled[75] = 8'h0; 
                pixels_oled[76] = 8'h0;
                pixels_oled[77] = 8'h90;
                pixels_oled[78] = 8'h50; 
                pixels_oled[79] = 8'h30;
                pixels_oled[80] = 8'h0;
                pixels_oled[81] = 8'h31; 
                pixels_oled[82] = 8'h29;
                pixels_oled[83] = 8'h25;
                pixels_oled[84] = 8'h23; 
                pixels_oled[85] = 8'h0;
                pixels_oled[86] = 8'h0;
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
                pixels_oled[75] = 8'h0; 
                pixels_oled[76] = 8'h0;
                pixels_oled[77] = 8'h90;
                pixels_oled[78] = 8'h50; 
                pixels_oled[79] = 8'h30;
                pixels_oled[80] = 8'h0;
                pixels_oled[81] = 8'h31; 
                pixels_oled[82] = 8'h29;
                pixels_oled[83] = 8'h25;
                pixels_oled[84] = 8'h23; 
                pixels_oled[85] = 8'h0;
                pixels_oled[86] = 8'h0;
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
                pixels_oled[75] = 8'h0; 
                pixels_oled[76] = 8'h0;
                pixels_oled[77] = 8'h0;
                pixels_oled[78] = 8'h0; 
                pixels_oled[79] = 8'h0;
                pixels_oled[80] = 8'h0;
                pixels_oled[81] = 8'h0; 
                pixels_oled[82] = 8'h0;
                pixels_oled[83] = 8'h0;
                pixels_oled[84] = 8'h0; 
                pixels_oled[85] = 8'h0;
                pixels_oled[86] = 8'h0;
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

            if(food> 7'd67 && food <= 7'd100)begin
                pixels_oled[31] = 8'h70;
                pixels_oled[32] = 8'h88;
                pixels_oled[33] = 8'h8;
                pixels_oled[34] = 8'h6;
                pixels_oled[35] = 8'hB;
                pixels_oled[36] = 8'h89; 
                pixels_oled[37] = 8'h70;
                pixels_oled[38] = 8'h0;
                pixels_oled[39] = 8'h0; 
                pixels_oled[40] = 8'h0;
                pixels_oled[41] = 8'h70;
                pixels_oled[42] = 8'h88; 
                pixels_oled[43] = 8'h8;
                pixels_oled[44] = 8'h6;
                pixels_oled[45] = 8'hB; 
                pixels_oled[46] = 8'h89;
                pixels_oled[47] = 8'h70;
                pixels_oled[48] = 8'h0; 
                pixels_oled[49] = 8'h0;
                pixels_oled[50] = 8'h0;
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
                pixels_oled[38] = 8'h0;
                pixels_oled[39] = 8'h0; 
                pixels_oled[40] = 8'h0;
                pixels_oled[41] = 8'h70;
                pixels_oled[42] = 8'h88; 
                pixels_oled[43] = 8'h8;
                pixels_oled[44] = 8'h6;
                pixels_oled[45] = 8'hB; 
                pixels_oled[46] = 8'h89;
                pixels_oled[47] = 8'h70;
                pixels_oled[48] = 8'h0; 
                pixels_oled[49] = 8'h0;
                pixels_oled[50] = 8'h0;
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
                pixels_oled[38] = 8'h0;
                pixels_oled[39] = 8'h0; 
                pixels_oled[40] = 8'h0;
                pixels_oled[41] = 8'h0;
                pixels_oled[42] = 8'h0; 
                pixels_oled[43] = 8'h0;
                pixels_oled[44] = 8'h0;
                pixels_oled[45] = 8'h0; 
                pixels_oled[46] = 8'h0;
                pixels_oled[47] = 8'h0;
                pixels_oled[48] = 8'h0; 
                pixels_oled[49] = 8'h0;
                pixels_oled[50] = 8'h0;
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
            

            if(life> 7'd83 && life <= 7'd100)begin
                pixels_oled[483] = 8'hE;pixels_oled[484] = 8'h1D;pixels_oled[485] = 8'h3F;pixels_oled[486] = 8'h7E;pixels_oled[487] = 8'h3F;pixels_oled[488] = 8'h1F;pixels_oled[489] = 8'hE;pixels_oled[490] = 8'h0;pixels_oled[491] = 8'h0;pixels_oled[492] = 8'hE;pixels_oled[493] = 8'h1D;pixels_oled[494] = 8'h3F;pixels_oled[495] = 8'h7E;pixels_oled[496] = 8'h3F;pixels_oled[497] = 8'h1F;pixels_oled[498] = 8'hE;pixels_oled[499] = 8'h0;pixels_oled[500] = 8'h0;pixels_oled[501] = 8'hE;pixels_oled[502] = 8'h1D;pixels_oled[503] = 8'h3F;pixels_oled[504] = 8'h7E;pixels_oled[505] = 8'h3F;pixels_oled[506] = 8'h1F;pixels_oled[507] = 8'hE;

            end
            else if(life> 7'd67 && life <= 7'd83)begin
                pixels_oled[483] = 8'hE;pixels_oled[484] = 8'h1D;pixels_oled[485] = 8'h3F;pixels_oled[486] = 8'h7E;pixels_oled[487] = 8'h3F;pixels_oled[488] = 8'h1F;pixels_oled[489] = 8'hE;pixels_oled[490] = 8'h0;pixels_oled[491] = 8'h0;pixels_oled[492] = 8'hE;pixels_oled[493] = 8'h1D;pixels_oled[494] = 8'h3F;pixels_oled[495] = 8'h7E;pixels_oled[496] = 8'h3F;pixels_oled[497] = 8'h1F;pixels_oled[498] = 8'hE;pixels_oled[499] = 8'h0;pixels_oled[500] = 8'h0;pixels_oled[501] = 8'hE;pixels_oled[502] = 8'h1D;pixels_oled[503] = 8'h3F;pixels_oled[504] = 8'h7E;
                pixels_oled[505] = 8'h0;
                pixels_oled[506] = 8'h0;
                pixels_oled[507] = 8'h0;    
            end
            else if(life> 7'd50 && life <= 7'd67)begin
                pixels_oled[483] = 8'hE;pixels_oled[484] = 8'h1D;pixels_oled[485] = 8'h3F;pixels_oled[486] = 8'h7E;pixels_oled[487] = 8'h3F;pixels_oled[488] = 8'h1F;pixels_oled[489] = 8'hE;pixels_oled[490] = 8'h0;pixels_oled[491] = 8'h0;pixels_oled[492] = 8'hE;pixels_oled[493] = 8'h1D;pixels_oled[494] = 8'h3F;pixels_oled[495] = 8'h7E;pixels_oled[496] = 8'h3F;pixels_oled[497] = 8'h1F;pixels_oled[498] = 8'hE;
                pixels_oled[499] = 8'h0;
                pixels_oled[500] = 8'h0;
                pixels_oled[501] = 8'h0;
                pixels_oled[502] = 8'h0;
                pixels_oled[503] = 8'h0;
                pixels_oled[504] = 8'h0;
                pixels_oled[505] = 8'h0;
                pixels_oled[506] = 8'h0;
                pixels_oled[507] = 8'h0; 
            end
            else if(life> 7'd33 && life <= 7'd50)begin
                pixels_oled[483] = 8'hE;pixels_oled[484] = 8'h1D;pixels_oled[485] = 8'h3F;pixels_oled[486] = 8'h7E;pixels_oled[487] = 8'h3F;pixels_oled[488] = 8'h1F;pixels_oled[489] = 8'hE;pixels_oled[490] = 8'h0;pixels_oled[491] = 8'h0;pixels_oled[492] = 8'hE;pixels_oled[493] = 8'h1D;pixels_oled[494] = 8'h3F;pixels_oled[495] = 8'h7E;pixels_oled[496] = 8'h3F;pixels_oled[497] = 8'h1F;pixels_oled[498] = 8'hE;
                pixels_oled[498] = 8'h0;
                pixels_oled[497] = 8'h0;
                pixels_oled[496] = 8'h0;
                pixels_oled[499] = 8'h0;
                pixels_oled[500] = 8'h0;
                pixels_oled[501] = 8'h0;
                pixels_oled[502] = 8'h0;
                pixels_oled[503] = 8'h0;
                pixels_oled[504] = 8'h0;
                pixels_oled[505] = 8'h0;
                pixels_oled[506] = 8'h0;
                pixels_oled[507] = 8'h0; 
            end
            else if(life> 7'd16 && life <= 7'd33)begin
                pixels_oled[483] = 8'hE;pixels_oled[484] = 8'h1D;pixels_oled[485] = 8'h3F;pixels_oled[486] = 8'h7E;pixels_oled[487] = 8'h3F;pixels_oled[488] = 8'h1F;pixels_oled[489] = 8'hE;pixels_oled[490] = 8'h0;
                pixels_oled[495] = 8'h0;
                pixels_oled[494] = 8'h0;
                pixels_oled[493] = 8'h0;
                pixels_oled[492] = 8'h0;
                pixels_oled[491] = 8'h0;
                pixels_oled[490] = 8'h0;
                pixels_oled[498] = 8'h0;
                pixels_oled[497] = 8'h0;
                pixels_oled[496] = 8'h0;
                pixels_oled[499] = 8'h0;
                pixels_oled[500] = 8'h0;
                pixels_oled[501] = 8'h0;
                pixels_oled[502] = 8'h0;
                pixels_oled[503] = 8'h0;
                pixels_oled[504] = 8'h0;
                pixels_oled[505] = 8'h0;
                pixels_oled[506] = 8'h0;
                pixels_oled[507] = 8'h0;
            end
            else if(life> 7'd0 && life <= 7'd16)begin
                pixels_oled[483] = 8'hE;pixels_oled[484] = 8'h1D;pixels_oled[485] = 8'h3F;pixels_oled[486] = 8'h7E;
                pixels_oled[489] = 8'h0;
                pixels_oled[488] = 8'h0;
                pixels_oled[487] = 8'h0;
                pixels_oled[495] = 8'h0;
                pixels_oled[494] = 8'h0;
                pixels_oled[493] = 8'h0;
                pixels_oled[492] = 8'h0;
                pixels_oled[491] = 8'h0;
                pixels_oled[490] = 8'h0;
                pixels_oled[498] = 8'h0;
                pixels_oled[497] = 8'h0;
                pixels_oled[496] = 8'h0;
                pixels_oled[499] = 8'h0;
                pixels_oled[500] = 8'h0;
                pixels_oled[501] = 8'h0;
                pixels_oled[502] = 8'h0;
                pixels_oled[503] = 8'h0;
                pixels_oled[504] = 8'h0;
                pixels_oled[505] = 8'h0;
                pixels_oled[506] = 8'h0;
                pixels_oled[507] = 8'h0;
            end

            case (ind_select) 
                IND_PLAY: begin
                    for (i=128; i<256; i = i + 1) begin
                        pixels_oled[i][4] = 1;
                    end
                end
                IND_SLEEP: begin
                    for (i=128; i<256; i = i + 1) begin
                        pixels_oled[i][4] = 1;
                    end
                end
                IND_EAT: begin
                    for (i=128; i<256; i = i + 1) begin
                        pixels_oled[i][4] = 1;
                    end
                end
                IND_HEAL: begin
                    for (i=128; i<256; i = i + 1) begin
                        pixels_oled[i][4] = 1;
                    end
                end
            endcase
        end

        PLAY: begin
            if(btn_reset) begin
                state = START;
                end
            else if(btn_cancel) begin
                state = MAIN;
                end
            else if (cont_fun2 == 28'd150000000)begin
                    //pixels_oled = pantalla_rest_default
                    if(btn_action) begin
                        if(fun != 7'd100)begin
                        // pixels_oled = pantalla_resting
                        fun <= fun + 1'd1;
                        cont_fun2 <= 0;
                        if(random_medicine[7] == 1 || random_medicine[3] == 1)begin
                            if(medicines != 7'd127)begin
                            medicines = medicines + 1'd1;
                            end
                            else begin
                                //medicinas llenas
                            end
                        end
                      end
                      else begin
                    // todo mensaje de lleno
                      end
                    end
                end 
            else begin
                cont_fun2 <= cont_fun2 + 1'd1;
            end
        end

        SLEEP: begin
            
        end

        EAT: begin
          if(btn_reset) begin
                state = START;
          end
          else if(btn_cancel) begin
                state = MAIN;
                end
          else if (cont_food2 == 28'd150000000)begin
                    //pixels_oled = pantalla_eat_default
                    if(btn_action) begin    
                        if(food != 7'd100)begin
                    // pixels_oled = pantalla_eating
                        food <= food + 1'd1;
                        cont_food2 <= 0;
                        end
                        else begin
                     //TODO si algo ponerle una frase de que esta lleno       
                        end
                    end
                end 
          else begin
                cont_food2 <= cont_food2 + 1'd1;
            end
        end
        HEAL: begin
            if(btn_reset) begin
                state = START;
                end
            else if(btn_cancel) begin
                state = MAIN;
                end
            else if (cont_heal2 == 28'd150000000)begin
                    //pixels_oled = pantalla_heal_default
                    if(btn_action && (medicines >= 7'd1)) begin
                    // pixels_oled = pantalla_healing
                        life <= life + 7'd20;
                        cont_heal2 <= 0;
                        medicines <= medicines - 1'd1;
                    end
                    else if(btn_action && (medicines == 0))begin
                    // pixels_oled = pantalla_not_medicines    
                    end
                end 
            else begin
                cont_heal2 <= cont_heal2 + 1'd1;
            end
        end

        DEATH: begin
        end
    endcase
end

reg enable_btn_joystick = 1;



always @(posedge clk) begin
    if (state == MAIN) begin
        if (btn_left == 1 && enable_btn_joystick) begin
            enable_btn_joystick <= 0;
            if (ind_select != IND_PLAY) begin
                ind_select = ind_select - 1'b1;
            end
        end

        if (btn_right == 1 && enable_btn_joystick) begin
            enable_btn_joystick <= 0;
            if (ind_select == IND_EAT && disease == 1) begin
                ind_select = ind_select + 1'b1;
            end
            else if (ind_select != IND_HEAL && ind_select != IND_EAT) begin
                ind_select = ind_select + 1'b1;
            end
        end
    end
end

//check buttons availability

always @(negedge clk_2s) begin 

    if (enable_btn_joystick == 0) begin
        enable_btn_joystick <= 1;
    end

end

endmodule