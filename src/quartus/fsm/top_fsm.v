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
    output level2,
	output reg led_s1,
	output reg led_s2,
	output reg led_s3
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

wire [7:0] screen_param = {act_eat, act_heal, act_play, act_sleep, state};
wire [32:0] needs_values = {disease, life, food, fun, rest, ind_select};

top_oled UUT_oled (
	.clk(clk),
	.screen_param(screen_param),
	.needs_values(needs_values),
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

assign led_reset = ~btn_reset;
assign led_cancel = ~btn_cancel;
assign led_test = ~btn_test;

// manage needs values

localparam LIFE_PLUS = 7'd70;
localparam LIFE_MINUS = 5'd30;

reg [5:0] cont_food = 0;
reg [5:0] cont_fun = 0;
reg [5:0] cont_rest = 0;

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

reg [3:0] state = START;

localparam IND_PLAY = 4'd0;
localparam IND_EAT = 4'd1;
localparam IND_SLEEP = 4'd2;
localparam IND_HEAL = 4'd3;

localparam DELAY_TIME_BUTTONS = 26'd25000000;
localparam DELAY_SCREEN_PAUSE = 30'd100000000;

integer i;
reg [3:0] ind_select = IND_PLAY;
reg [29:0] cont_screen_pause = DELAY_SCREEN_PAUSE;

reg [25:0] cont_pulse_1s = 0;
reg pulse_1s = 0;

wire btn_left;
wire btn_middle;
wire btn_right;

reg enable_joystick = 1;
reg [26:0] cont_enable_joystick = 0;

reg enable_btn_action = 1;
reg [26:0] cont_enable_btn_action = 0;

reg enable_btn_cancel = 1;
reg [26:0] cont_enable_btn_cancel = 0;

reg [26:0] cont_actions = 0;

assign btn_left = ~led_left;
assign btn_right = ~led_right;

reg act_play = 0;
reg act_sleep = 0;
reg act_eat = 0;
reg act_heal = 0;

always @(posedge clk) begin

    if (cont_pulse_1s == 26'd50000000/10) begin
        pulse_1s <= 1;
        cont_pulse_1s <= 0;
    end
    else begin
        pulse_1s <= 0;
        cont_pulse_1s <= cont_pulse_1s + 1'd1;
    end

    if (pulse_1s && state != START) begin
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
	
	if (btn_cancel == 1 && enable_btn_cancel) begin
		state <= MAIN;
	end

    case (state)
        START: begin
            if (cont_screen_pause == 0) begin
                state <= MAIN;
            end
            else begin
                cont_screen_pause <= cont_screen_pause - 1'b1;
            end

			led_s1 = 0;
			led_s2 = 1;
			led_s3 = 1;
        end

        MAIN: begin
			led_s1 = 1;
			led_s2 = 0;
			led_s3 = 1;

            if (btn_action== 0 && ind_select == IND_PLAY) begin
			    state <= PLAY;
            end
            
            if (btn_action == 0 && ind_select == IND_EAT) begin
                state <= EAT;
            end
            
            if (btn_action == 0 && ind_select == IND_SLEEP) begin
                state <= SLEEP;
            end
            
            if (btn_action == 0 && ind_select == IND_HEAL) begin
                state <= HEAL;
            end

            if (!enable_joystick) begin
                if (cont_enable_joystick == DELAY_TIME_BUTTONS) begin
                    enable_joystick <= 1;
                    cont_enable_joystick <= 0;
                end
                else begin
                    cont_enable_joystick <= cont_enable_joystick + 1;
                end
            end

            if (btn_left == 1 && enable_joystick) begin
                enable_joystick <= 0;
                if (ind_select != IND_PLAY) begin
                    ind_select <= ind_select - 1'b1;
                end
            end

            if (btn_right == 1 && enable_joystick) begin
                enable_joystick <= 0;
                if (ind_select == IND_SLEEP && disease == 1) begin
                    ind_select <= ind_select + 1'b1;
                end
                else if (ind_select != IND_HEAL && ind_select != IND_SLEEP) begin
                    ind_select <= ind_select + 1'b1;
                end
            end
        end

        PLAY: begin
			led_s1 = 1;
			led_s2 = 1;
			led_s3 = 0;
		end

        SLEEP: begin
			led_s1 = 0;
			led_s2 = 0;
			led_s3 = 1;
			
			if (level1 == 0) begin
                act_sleep = 1;
                if (cont_actions == 26'd50000000) begin
                    cont_actions <= 0;
                    rest <= 7'd100;
                end
                else begin
                    cont_actions <= cont_actions + 1'd1;
                end
            end
            else begin
                cont_actions = 0;
                act_sleep = 0;
            end
			
        end

        EAT: begin
			led_s1 = 1;
			led_s2 = 0;
			led_s3 = 0;
        end

        HEAL: begin
			led_s1 = 0;
			led_s2 = 1;
			led_s3 = 0;
        end

        DEATH: begin
			led_s1 = 0;
			led_s2 = 0;
			led_s3 = 0;
        end
    endcase
end

endmodule