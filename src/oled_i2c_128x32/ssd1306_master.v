module ssd1306_master (
    input clk,
    input [3:0] state,
    input [9:0] data_counter,
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

    reg [7:0] pixels_oled [511:0];
    reg [4:0] block_sep = 0;

    initial begin
        $readmemh("D:/Personal/1-Universidad nacional/Semestre 6/Digital 1/Github/entrega-1-proyecto-grupo03-2024-1/src/oled_i2c_128x32/pixels_oled.men", pixels_oled, 0, 511);
        addr_byte_in = 7'b0111100;
        read_write = 0;
        control_byte_in = 8'b00000000;
        data_byte_in = 8'hAE;
        continue_bit = 1;
    end

    always @ (posedge clk) begin 
        case (state)
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
                            addr_byte_in = 7'b0111100;
                            read_write = 0;
                            control_byte_in = 8'b01000000;
                            data_byte_in = pixels_oled[data_counter-32];
                            continue_bit = 0;
                        end
                    endcase
                end
        endcase
    end

endmodule