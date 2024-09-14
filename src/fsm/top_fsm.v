`include "src/ads1115/top_ads1115.v"
`include "src/ultrasonido/top_hcsr04.v"
`include "src/oled_i2c_128x32/top_oled.v"

`timescale 1ns / 1ps

module top_fsm (
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
	.sda(sda_display), 
	.scl(scl_display)
);

reg btn_left;
reg btn_middle;
reg btn_right;

reg [6:0] life = 7'd100;
reg [6:0] food = 7'd50;
reg [6:0] fun = 7'd50;
reg [6:0] rest = 7'd50;
reg [6:0] medicines = 0;
reg disease = 0;
reg death = 0;

reg [7:0] pixels_oled [511:0];
reg [7:0] pixels_default [511:0];

assign led_reset = ~btn_reset;
assign led_cancel = ~btn_cancel;
assign led_test = ~btn_test;

initial begin
    $readmemh("D:/Personal/1-Universidad nacional/Semestre 6/Digital 1/Github/entrega-1-proyecto-grupo03-2024-1/src/fsm/pixels_oled.men", pixels_oled, 0, 511);
    $readmemh("D:/Personal/1-Universidad nacional/Semestre 6/Digital 1/Github/entrega-1-proyecto-grupo03-2024-1/src/fsm/pixels_default.men", pixels_default, 0, 511);
end

// clocks

reg [25:0] cont_clk_1s = 0;
reg clk_1s = 0;

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
reg [5:0] cont_fun = 0;
reg [5:0] cont_rest = 0;

always @(negedge clk_1s) begin
    cont_food = cont_food + 1'b1;
    cont_fun = cont_fun + 1'b1;
    cont_rest = cont_rest + 1'b1;

    if (cont_food >= 5'd3 && food > 0) begin
        food <= food - 1'b1;
        cont_food <= 0;
    end

    if (cont_fun >= 5'd4 && fun > 0) begin
        fun <= fun - 1'b1;
        cont_fun <= 0;
    end

    if (cont_rest >= 5'd5 && rest > 0) begin
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
localparam DEATH = 5'd6;

reg [3:0] state = START;

localparam IND_PLAY = 4'd0;
localparam IND_SLEEP = 4'd1;
localparam IND_EAT = 4'd2;
localparam IND_HEAL = 4'd3;

reg [3:0] ind_select = IND_PLAY;
integer i;

always @(posedge clk) begin
    case (state)
        START: begin
        end

        MAIN: begin
            for (i=128; i<256; i=i+1) begin
                pixels_oled[i][4] = 0;
            end

            case (ind_select) 
                IND_PLAY: begin
                    for (i=128; i<256; i=i+1) begin
                        pixels_oled[i][4] = 1;
                    end
                end
                IND_SLEEP: begin
                    for (i=128; i<256; i=i+1) begin
                        pixels_oled[i][4] = 1;
                    end
                end
                IND_EAT: begin
                    for (i=128; i<256; i=i+1) begin
                        pixels_oled[i][4] = 1;
                    end
                end
                IND_HEAL: begin
                    for (i=128; i<256; i=i+1) begin
                        pixels_oled[i][4] = 1;
                    end
                end
            endcase
        end

        PLAY: begin
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