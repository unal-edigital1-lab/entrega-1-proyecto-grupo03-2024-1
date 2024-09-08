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
            for (i=128; i<256; i++) begin
                pixels_oled[i][4] = 0;
            end

            case (ind_select) 
                IND_PLAY: begin
                    for (i=128; i<256; i++) begin
                        pixels_oled[i][4] = 1;
                    end
                end
                IND_SLEEP: begin
                    for (i=128; i<256; i++) begin
                        pixels_oled[i][4] = 1;
                    end
                end
                IND_EAT: begin
                    for (i=128; i<256; i++) begin
                        pixels_oled[i][4] = 1;
                    end
                end
                IND_HEAL: begin
                    for (i=128; i<256; i++) begin
                        pixels_oled[i][4] = 1;
                    end
                end
            endcase
        end

        PLAY: begin
            
        end

        SLEEP: begin
            if(btn_reset) begin
                state = START;
                end
            else if(btn_cancel) begin
                state = MAIN;
                end
            else if (cont_rest2 == 28'd150000000)begin
                    //pixels_oled = pantalla_rest_default
                    if(btn_action) begin
                    // pixels_oled = pantalla_resting
                        rest <= rest + 1'd1;
                        cont_rest2 <= 0;
                    end
                end 
            else begin
                cont_rest2 <= cont_rest2 + 1'd1;
            end
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
                    // pixels_oled = pantalla_eating
                        food <= food + 1'd1;
                        cont_food2 <= 0;
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
                        life <= life + 1'd20;
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