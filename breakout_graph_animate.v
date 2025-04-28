//----------------------------------//
// Breakout Files
// breakout_graph_animate.v
// David J. Morvay
// ECEN 4856
// Fall 2020
// Reference for this file:
// "FPGA Prototyping by Verilog Examples"
//----------------------------------//

module breakout_graph_animate (clk, reset, btnR, btnL, video_on, pix_x, pix_y, vgaRed, vgaGreen, vgaBlue, score);
input clk, reset, btnR, btnL, video_on;
input [10:0] pix_x, pix_y;
//input [1:0] switch ;

output [3:0] vgaRed, vgaGreen, vgaBlue;
output [15:0] score;


reg [3:0] vgaRed, vgaGreen, vgaBlue;
reg offpage;
reg [2:0] _heart;
initial _heart = 3;

// Constant and signal declaration
// x, y coordinates (0,0) to (799, 599)
localparam MAX_X = 800;
localparam MAX_Y = 600;

// Vertical stripe as a wall
// wall left, right boundary
localparam WALL_X_L = 0;
localparam WALL_X_R = 3;

// Top horizontal stripe as a wall
// Wall top, bottom boundary
localparam T_WALL_T = 0;
localparam T_WALL_B = 3;

// Bottom horizontal strip as a wall
// Wall top, bottom boundary
localparam B_WALL_T = 596;
localparam B_WALL_B = 599;

//Right horizontal stripe as a wall
// Wall left, right boundary
localparam WALL_Y_L = 796;
localparam WALL_Y_R = 799;

//-----------------------------------------------//

// Paddle
// bar left, right boundary
localparam BAR_X_L = 331;
localparam BAR_X_R = 470;
// Bar top, bottom boundary
wire [10:0] bar_x_r, bar_x_l, bar_y_t, bar_y_b;
localparam BAR_Y_SIZE = 10;
// Register to track right, left boundary (y position fixed)
reg [10:0] bar_x_reg, bar_x_next, bar_y_reg;
// Bar moving velocity when a button is pressed 
localparam BAR_V = 4;

//-----------------------------------------------// 

// Square ball
localparam BALL_SIZE = 8;
// Ball left, right boundary
wire [10:0] ball_x_l, ball_x_r;
// Ball top, bottom boundary 
wire [10:0] ball_y_t, ball_y_b;
// Reg to track left, top position
reg [10:0] ball_x_reg, ball_y_reg;
wire [10:0] ball_x_next, ball_y_next;
// Reg to track ball speed
reg [10:0] x_delta_reg, x_delta_next;
reg [10:0] y_delta_reg, y_delta_next;
// Ball velocity can be positive or negative
localparam BALL_V_P = 2;
localparam BALL_V_N = -2;
localparam BALL_V_P_Y = 1;
localparam BALL_V_N_Y = -1;

//------------------------------------------------// 

// Round ball
wire [2:0] rom_addr, rom_col;
reg [7:0] rom_data;
wire rom_bit;

//------------------------------------------------//

// Object output signals
wire wall_on, bar_on, sq_ball_on, rd_ball_on;
wire C0_ON, C1_ON, C2_ON, C3_ON, C4_ON, C5_ON, C6_ON;
wire score_ON_R, score_ON_RM, score_ON_LM, score_ON_L;
wire heart_ON_1, heart_ON_2, heart_ON_3;

wire [3:0] wall_rgb_red, wall_rgb_green, wall_rgb_blue;
wire [3:0] bar_rgb_red, bar_rgb_green, bar_rgb_blue;
wire [3:0] ball_rgb_red, ball_rgb_green, ball_rgb_blue;
wire [3:0] heart_rgb_red, heart_rgb_green, heart_rgb_blue;

//------------------------------------------------//

wire blocks_reset;

// Column one blocks
wire [5:0] C0_count;
wire C0_U, C0_D, C0_L, C0_R;
breakout_blocks column0(.clk(clk), .reset(blocks_reset), .pix_x(pix_x), .pix_y(pix_y), .ball_x_r(ball_x_r),
		    .ball_x_l(ball_x_l), .ball_y_t(ball_y_t), .ball_y_b(ball_y_b), .moveU(C0_U), 
		    .moveD(C0_D), .moveL(C0_L), .moveR(C0_R), .C0_count(C0_count), .C0_ON(C0_ON));

// Column two blocks
wire [5:0] C1_count;
wire C1_U, C1_D, C1_L, C1_R;
breakout_blocks_C1 column1(.clk(clk), .reset(blocks_reset), .pix_x(pix_x), .pix_y(pix_y), .ball_x_r(ball_x_r),
		    .ball_x_l(ball_x_l), .ball_y_t(ball_y_t), .ball_y_b(ball_y_b), .moveU(C1_U), 
		    .moveD(C1_D), .moveL(C1_L), .moveR(C1_R), .C1_count(C1_count), .C1_ON(C1_ON));

// Column three blocks
wire [15:0] C2_count;
wire C2_U, C2_D, C2_L, C2_R;
breakout_blocks_C2 column2(.clk(clk), .reset(blocks_reset), .pix_x(pix_x), .pix_y(pix_y), .ball_x_r(ball_x_r),
		    .ball_x_l(ball_x_l), .ball_y_t(ball_y_t), .ball_y_b(ball_y_b), .moveU(C2_U), 
		    .moveD(C2_D), .moveL(C2_L), .moveR(C2_R), .C2_count(C2_count), .C2_ON(C2_ON));

// Column four blocks
wire [15:0] C3_count;
wire C3_U, C3_D, C3_L, C3_R;
breakout_blocks_C3 column3(.clk(clk), .reset(blocks_reset), .pix_x(pix_x), .pix_y(pix_y), .ball_x_r(ball_x_r),
		    .ball_x_l(ball_x_l), .ball_y_t(ball_y_t), .ball_y_b(ball_y_b), .moveU(C3_U), 
		    .moveD(C3_D), .moveL(C3_L), .moveR(C3_R), .C3_count(C3_count), .C3_ON(C3_ON));

// Column five blocks
wire [15:0] C4_count; 
wire C4_U, C4_D, C4_L, C4_R;
breakout_blocks_C4 column4(.clk(clk), .reset(blocks_reset), .pix_x(pix_x), .pix_y(pix_y), .ball_x_r(ball_x_r),
		    .ball_x_l(ball_x_l), .ball_y_t(ball_y_t), .ball_y_b(ball_y_b), .moveU(C4_U), 
		    .moveD(C4_D), .moveL(C4_L), .moveR(C4_R), .C4_count(C4_count), .C4_ON(C4_ON));

// Column six blocks
wire [15:0] C5_count; 
wire C5_U, C5_D, C5_L, C5_R;
breakout_blocks_C5 column5(.clk(clk), .reset(blocks_reset), .pix_x(pix_x), .pix_y(pix_y), .ball_x_r(ball_x_r),
		    .ball_x_l(ball_x_l), .ball_y_t(ball_y_t), .ball_y_b(ball_y_b), .moveU(C5_U), 
		    .moveD(C5_D), .moveL(C5_L), .moveR(C5_R), .C5_count(C5_count), .C5_ON(C5_ON));

// Column seven blocks
wire [15:0] C6_count;
wire C6_U, C6_D, C6_L, C6_R;
breakout_blocks_C6 column6(.clk(clk), .reset(blocks_reset), .pix_x(pix_x), .pix_y(pix_y), .ball_x_r(ball_x_r),
		    .ball_x_l(ball_x_l), .ball_y_t(ball_y_t), .ball_y_b(ball_y_b), .moveU(C6_U), 
		    .moveD(C6_D), .moveL(C6_L), .moveR(C6_R), .C6_count(C6_count), .C6_ON(C6_ON));

//-----------------------------------------------------------------------------------------------------//


// Score counter
// Secondary score counter
reg [7:0] secondary_score;
always @(posedge clk) begin
	if (reset || _heart < 0)
		secondary_score <= 0;
	else
		secondary_score <= C6_count + C5_count + C4_count + C3_count + C2_count + C1_count + C0_count;
end

// If secondary_score reaches 56,
// send_56 will go high for one clk cycle
reg buffer_1, buffer_2;
assign fifty_six = (secondary_score == 56);
always @(posedge clk) buffer_1 <= fifty_six;
always @(posedge clk) buffer_2 <= buffer_1;
wire send_56 = buffer_1 && !buffer_2;

// Send 56 indicates that the full board has been destroyed
// Hence, a full board score needs to be sent to the main score
// becuase the board is going to reset and send the values back to zero. 
reg [15:0] full_board;
always @(posedge clk) begin
	if (reset || _heart < 0)
		full_board <= 0;
	else if (send_56)
		full_board <= full_board ;
end

// Main score. Notice full_board only increments every time
// the board is completely destroyed. 
reg [15:0] score;
always @(posedge clk) begin
	if (reset || _heart < 0)
		score <= 0;
	else
		score <= full_board + C6_count + C5_count + C4_count + C3_count + C2_count + C1_count + C0_count;
end

// Send the full score to be converted from base 2 to base 10
wire [15:0] b_10_score;
wire moveD1;
b_10_vga b10_vga(.clk(clk), .sw(score), .num_out(b_10_score));

// Send the score to the onscreen scoreboard
score scoreboard(.clk(clk), .reset(), .score(b_10_score), .pix_x(pix_x), .pix_y(pix_y), .ball_x_r(ball_x_r), 
		 .ball_x_l(ball_x_l), .ball_y_t(ball_y_t), .ball_y_b(ball_y_b), .moveD(moveD1), .moveL(), .moveR(), 
		 .score_ON_R(score_ON_R), .score_ON_RM(score_ON_RM), .score_ON_LM(score_ON_LM), .score_ON_L(score_ON_L));

//------------------------- BODY ---------------------------------// 



// Round ball image ROM
always @*
case (rom_addr)
	3'h0: rom_data = 8'b00111100;	//    ****
	3'h1: rom_data = 8'b01111110;	//   ******
	3'h2: rom_data = 8'b11111111;	//  ********
	3'h3: rom_data = 8'b11111111;	//  ********
	3'h4: rom_data = 8'b11111111;	//  ********
	3'h5: rom_data = 8'b11111111;	//  ********
	3'h6: rom_data = 8'b01111110;	//   ******
	3'h7: rom_data = 8'b00111100;	//    ****
endcase





//------------------------------------------------------------Heart-------------------------------------------------//
//------------------------------------//

//Heart
localparam heart_SIZE = 32;

//------------------------------------//

// Heart Left
// Heart left, right boundary
wire [10:0] heart_x_l_1 = 690;
wire [10:0] heart_x_r_1 = heart_x_l_1 + heart_SIZE - 1;
// Heart top, bottom boundary 
wire [10:0] heart_y_t_1 = 565; 
wire [10:0] heart_y_b_1 = heart_y_t_1 + heart_SIZE - 1;
reg rom_bit_heart1;

wire [4:0] rom_addr_heart1, rom_col_heart1;
reg [31:0] rom_data_heart1;

// Heart Left On image ROM
always @*
case (rom_addr_heart1)
	5'h0: rom_data_heart1 =   32'b00000000_00000000_00000000_00000000;
	5'h1: rom_data_heart1 =   32'b00000000_00000000_00000000_00000000;
	5'h2: rom_data_heart1 =   32'b00000111_10000011_11000000_00000000;  //         ****     ****  
	5'h3: rom_data_heart1 =   32'b00111111_11101111_11111000_00000000;	//      ********* *********                                
	5'h4: rom_data_heart1 =   32'b11111111_11111111_11111110_00000000;	//    ***********************                              
	5'h5: rom_data_heart1 =   32'b11111111_11111111_11111110_00000000;	//    ***********************
	5'h6: rom_data_heart1 =   32'b11111111_11111111_11111110_00000000;	//    *********************** 
	5'h7: rom_data_heart1 =   32'b01111111_11111111_11111100_00000000;	//     *********************
	5'h8: rom_data_heart1 =   32'b00011111_11111111_11110000_00000000;	//       *****************
	5'h9: rom_data_heart1 =   32'b00000111_11111111_11000000_00000000;	//         *************
	5'hA: rom_data_heart1 =   32'b00000001_11111111_00000000_00000000;	//           *********
	5'hB: rom_data_heart1 =   32'b00000000_01111100_00000000_00000000;	//   		   *****
	5'hC: rom_data_heart1 =   32'b00000000_00010000_00000000_00000000;	//               *
	5'hD: rom_data_heart1 =   32'b00000000_00000000_00000000_00000000;
	5'hE: rom_data_heart1 =   32'b00000000_00000000_00000000_00000000;
	5'hF: rom_data_heart1 =   32'b00000000_00000000_00000000_00000000;	             
endcase

assign rom_addr_heart1 = pix_y[4:0] - heart_y_t_1[4:0];
assign rom_col_heart1 = pix_x[4:0] - heart_x_l_1[4:0];

wire [3:0] rom_addr_heart1_off, rom_col_heart1_off;
reg [31:0] rom_data_heart1_off;

// Heart Left Off image ROM
always @*
case (rom_addr_heart1_off)
	5'h0: rom_data_heart1_off =   32'b00000000_00000000_00000000_00000000;
	5'h1: rom_data_heart1_off =   32'b00000000_00000000_00000000_00000000;
	5'h2: rom_data_heart1_off =   32'b00000000_00000000_00000000_00000000; 
	5'h3: rom_data_heart1_off =   32'b00000000_00000000_00000000_00000000;                                
	5'h4: rom_data_heart1_off =   32'b00000000_00000000_00000000_00000000;	                             
	5'h5: rom_data_heart1_off =   32'b00000000_00000000_00000000_00000000;
	5'h6: rom_data_heart1_off =   32'b00000000_00000000_00000000_00000000;	 
	5'h7: rom_data_heart1_off =   32'b00000000_00000000_00000000_00000000;
	5'h8: rom_data_heart1_off =   32'b00000000_00000000_00000000_00000000;
	5'h9: rom_data_heart1_off =   32'b00000000_00000000_00000000_00000000;
	5'hA: rom_data_heart1_off =   32'b00000000_00000000_00000000_00000000;
	5'hB: rom_data_heart1_off =   32'b00000000_00000000_00000000_00000000;	
	5'hC: rom_data_heart1_off =   32'b00000000_00000000_00000000_00000000;
	5'hD: rom_data_heart1_off =   32'b00000000_00000000_00000000_00000000;
	5'hE: rom_data_heart1_off =   32'b00000000_00000000_00000000_00000000;
	5'hF: rom_data_heart1_off =   32'b00000000_00000000_00000000_00000000;	             
endcase

assign rom_addr_heart1_off = pix_y[4:0] - heart_y_t_1[4:0];
assign rom_col_heart1_off = pix_x[4:0] - heart_x_l_1[4:0];

always @(posedge clk) begin
	if (_heart > 0)
	    rom_bit_heart1 = rom_data_heart1[rom_col_heart1];
	else
	    rom_bit_heart1 = rom_data_heart1_off[rom_col_heart1_off];
end

//------------------------------------//

// Heart Middle
// Heart left, right boundary
wire [10:0] heart_x_l_2 = 720;
wire [10:0] heart_x_r_2 = heart_x_l_2 + heart_SIZE - 1;
// Heart top, bottom boundary 
wire [10:0] heart_y_t_2 = 565; 
wire [10:0] heart_y_b_2 = heart_y_t_2 + heart_SIZE - 1;
reg rom_bit_heart2;

wire [4:0] rom_addr_heart2, rom_col_heart2;
reg [31:0] rom_data_heart2;

// Heart Middle On image ROM
always @*
case (rom_addr_heart2)
	5'h0: rom_data_heart2 =   32'b00000000_00000000_00000000_00000000;
	5'h1: rom_data_heart2 =   32'b00000000_00000000_00000000_00000000;
	5'h2: rom_data_heart2 =   32'b00000111_10000011_11000000_00000000;  //         ****     ****  
	5'h3: rom_data_heart2 =   32'b00111111_11101111_11111000_00000000;	//      ********* *********                                
	5'h4: rom_data_heart2 =   32'b11111111_11111111_11111110_00000000;	//    ***********************                              
	5'h5: rom_data_heart2 =   32'b11111111_11111111_11111110_00000000;	//    ***********************
	5'h6: rom_data_heart2 =   32'b11111111_11111111_11111110_00000000;	//    *********************** 
	5'h7: rom_data_heart2 =   32'b01111111_11111111_11111100_00000000;	//     *********************
	5'h8: rom_data_heart2 =   32'b00011111_11111111_11110000_00000000;	//       *****************
	5'h9: rom_data_heart2 =   32'b00000111_11111111_11000000_00000000;	//         *************
	5'hA: rom_data_heart2 =   32'b00000001_11111111_00000000_00000000;	//           *********
	5'hB: rom_data_heart2 =   32'b00000000_01111100_00000000_00000000;	//   		   *****
	5'hC: rom_data_heart2 =   32'b00000000_00010000_00000000_00000000;	//               *
	5'hD: rom_data_heart2 =   32'b00000000_00000000_00000000_00000000;
	5'hE: rom_data_heart2 =   32'b00000000_00000000_00000000_00000000;
	5'hF: rom_data_heart2 =   32'b00000000_00000000_00000000_00000000;	             
endcase

assign rom_addr_heart2 = pix_y[4:0] - heart_y_t_2[4:0];
assign rom_col_heart2 = pix_x[4:0] - heart_x_l_2[4:0];

wire [4:0] rom_addr_heart2_off, rom_col_heart2_off;
reg [31:0] rom_data_heart2_off;

// Heart Middle Off image ROM
always @*
case (rom_addr_heart2_off)
	5'h0: rom_data_heart2_off =   32'b00000000_00000000_00000000_00000000;
	5'h1: rom_data_heart2_off =   32'b00000000_00000000_00000000_00000000;
	5'h2: rom_data_heart2_off =   32'b00000000_00000000_00000000_00000000; 
	5'h3: rom_data_heart2_off =   32'b00000000_00000000_00000000_00000000;                                
	5'h4: rom_data_heart2_off =   32'b00000000_00000000_00000000_00000000;	                             
	5'h5: rom_data_heart2_off =   32'b00000000_00000000_00000000_00000000;
	5'h6: rom_data_heart2_off =   32'b00000000_00000000_00000000_00000000;	 
	5'h7: rom_data_heart2_off =   32'b00000000_00000000_00000000_00000000;
	5'h8: rom_data_heart2_off =   32'b00000000_00000000_00000000_00000000;
	5'h9: rom_data_heart2_off =   32'b00000000_00000000_00000000_00000000;
	5'hA: rom_data_heart2_off =   32'b00000000_00000000_00000000_00000000;
	5'hB: rom_data_heart2_off =   32'b00000000_00000000_00000000_00000000;	
	5'hC: rom_data_heart2_off =   32'b00000000_00000000_00000000_00000000;
	5'hD: rom_data_heart2_off =   32'b00000000_00000000_00000000_00000000;
	5'hE: rom_data_heart2_off =   32'b00000000_00000000_00000000_00000000;
	5'hF: rom_data_heart2_off =   32'b00000000_00000000_00000000_00000000;	             
endcase

// Map current pixel location to ROM addr/col
assign rom_addr_heart2_off = pix_y[4:0] - heart_y_t_2[4:0];
assign rom_col_heart2_off = pix_x[4:0] - heart_x_l_2[4:0];

//------------------------------------//

always @(posedge clk) begin
	if (_heart > 1)
	    rom_bit_heart2 = rom_data_heart2[rom_col_heart2];
	else
	    rom_bit_heart2 = rom_data_heart2_off[rom_col_heart2_off];
end

//------------------------------------//

// Heart Right
// Heart left, right boundary
wire [10:0] heart_x_l_3 = 750;
wire [10:0] heart_x_r_3 = heart_x_l_3 + heart_SIZE - 1;
// Heart top, bottom boundary 
wire [10:0] heart_y_t_3 = 565; 
wire [10:0] heart_y_b_3 = heart_y_t_3 + heart_SIZE - 1;
reg rom_bit_heart3;

wire [4:0] rom_addr_heart3, rom_col_heart3;
reg [31:0] rom_data_heart3;

// Heart Right On image ROM
always @*
case (rom_addr_heart3)
	5'h0: rom_data_heart3 =   32'b00000000_00000000_00000000_00000000;
	5'h1: rom_data_heart3 =   32'b00000000_00000000_00000000_00000000;
	5'h2: rom_data_heart3 =   32'b00000111_10000011_11000000_00000000;  //         ****     ****  
	5'h3: rom_data_heart3 =   32'b00111111_11101111_11111000_00000000;	//      ********* *********                                
	5'h4: rom_data_heart3 =   32'b11111111_11111111_11111110_00000000;	//    ***********************                              
	5'h5: rom_data_heart3 =   32'b11111111_11111111_11111110_00000000;	//    ***********************
	5'h6: rom_data_heart3 =   32'b11111111_11111111_11111110_00000000;	//    *********************** 
	5'h7: rom_data_heart3 =   32'b01111111_11111111_11111100_00000000;	//     *********************
	5'h8: rom_data_heart3 =   32'b00011111_11111111_11110000_00000000;	//       *****************
	5'h9: rom_data_heart3 =   32'b00000111_11111111_11000000_00000000;	//         *************
	5'hA: rom_data_heart3 =   32'b00000001_11111111_00000000_00000000;	//           *********
	5'hB: rom_data_heart3 =   32'b00000000_01111100_00000000_00000000;	//   		   *****
	5'hC: rom_data_heart3 =   32'b00000000_00010000_00000000_00000000;	//               *
	5'hD: rom_data_heart3 =   32'b00000000_00000000_00000000_00000000;
	5'hE: rom_data_heart3 =   32'b00000000_00000000_00000000_00000000;
	5'hF: rom_data_heart3 =   32'b00000000_00000000_00000000_00000000;	             
endcase

assign rom_addr_heart3 = pix_y[4:0] - heart_y_t_3[4:0];
assign rom_col_heart3 = pix_x[4:0] - heart_x_l_3[4:0];

wire [4:0] rom_addr_heart3_off, rom_col_heart3_off;
reg [31:0] rom_data_heart3_off;

// Heart Right Off image ROM
always @*
case (rom_addr_heart3_off)
	5'h0: rom_data_heart3_off =   32'b00000000_00000000_00000000_00000000;
	5'h1: rom_data_heart3_off =   32'b00000000_00000000_00000000_00000000;
	5'h2: rom_data_heart3_off =   32'b00000000_00000000_00000000_00000000; 
	5'h3: rom_data_heart3_off =   32'b00000000_00000000_00000000_00000000;                                
	5'h4: rom_data_heart3_off =   32'b00000000_00000000_00000000_00000000;	                             
	5'h5: rom_data_heart3_off =   32'b00000000_00000000_00000000_00000000;
	5'h6: rom_data_heart3_off =   32'b00000000_00000000_00000000_00000000;	 
	5'h7: rom_data_heart3_off =   32'b00000000_00000000_00000000_00000000;
	5'h8: rom_data_heart3_off =   32'b00000000_00000000_00000000_00000000;
	5'h9: rom_data_heart3_off =   32'b00000000_00000000_00000000_00000000;
	5'hA: rom_data_heart3_off =   32'b00000000_00000000_00000000_00000000;
	5'hB: rom_data_heart3_off =   32'b00000000_00000000_00000000_00000000;	
	5'hC: rom_data_heart3_off =   32'b00000000_00000000_00000000_00000000;
	5'hD: rom_data_heart3_off =   32'b00000000_00000000_00000000_00000000;
	5'hE: rom_data_heart3_off =   32'b00000000_00000000_00000000_00000000;
	5'hF: rom_data_heart3_off =   32'b00000000_00000000_00000000_00000000;	             
endcase

assign rom_addr_heart2_off = pix_y[4:0] - heart_y_t_3[4:0];
assign rom_col_heart2_off = pix_x[4:0] - heart_x_l_3[4:0];

always @(posedge clk) begin
	if (_heart > 2)
	    rom_bit_heart3 = rom_data_heart3[rom_col_heart3];
	else
	    rom_bit_heart3 = rom_data_heart3_off[rom_col_heart3_off];
end	

//------------------------------------//
// Heart RGB
assign heart_rgb_red = 4'b1110;
assign heart_rgb_green = 4'b0000;
assign heart_rgb_blue = 4'b0011;	

// Pixel within a block
assign heart_1 =  ((heart_x_l_1 <= pix_x) && (pix_x <= heart_x_r_1) && (heart_y_t_1 <= pix_y) && (pix_y <= heart_y_b_1));  
assign heart_2 =  ((heart_x_l_2 <= pix_x) && (pix_x <= heart_x_r_2) && (heart_y_t_2 <= pix_y) && (pix_y <= heart_y_b_2)); 
assign heart_3 =  ((heart_x_l_3 <= pix_x) && (pix_x <= heart_x_r_3) && (heart_y_t_3 <= pix_y) && (pix_y <= heart_y_b_3));

// Pixel within number
assign heart_ON_1 = heart_1 && rom_bit_heart1;
assign heart_ON_2 = heart_2 && rom_bit_heart2;
assign heart_ON_3 = heart_3 && rom_bit_heart3;



//------------------------------------------------------------Heart-------------------------------------------------//


















assign blocks_reset = reset || _heart == 0  || send_56;

/*
// Registers 
always @(posedge clk, posedge reset)
// Reset entire board
	if (reset)
		begin
		    bar_x_reg = 11'h18f; //399
			bar_y_reg = 11'h226; //550
			ball_x_reg = 11'h18f; //399
			ball_y_reg = 11'h190; //400
			x_delta_reg = 11'h000; //not move
			y_delta_reg = 11'h002; //down
			_heart <= 4;
		end

// Reset blocks and ball to the center of the screen
	else if (offpage || _heart > 0)
		begin
		    bar_x_reg = bar_x_next;
			bar_y_reg = 11'h226; //550
			ball_x_reg = 11'h18f; //399
			ball_y_reg = 11'h190; //400
			x_delta_reg = x_delta_next;
			y_delta_reg = y_delta_next;
			_heart <= _heart-1;
		end		
	else 
		begin
		    bar_x_reg = bar_x_next;
			bar_y_reg = 11'h226; //550
			ball_x_reg = ball_x_next;
			ball_y_reg = ball_y_next;
			x_delta_reg = x_delta_next;
			y_delta_reg = y_delta_next;
		end
	*/	
		
		
		
		
always @(posedge clk, posedge reset)
// Reset entire board
	if (reset)
		begin
			bar_x_reg = 11'h18f; //399
			bar_y_reg = 11'h226; //550
			ball_x_reg = 11'h18f; //399
			ball_y_reg = 11'h190; //400
			x_delta_reg = 11'h000; //not move
			y_delta_reg = 11'h002; //down
            _heart <= 3;
		end

// Reset blocks and ball to the center of the screen
	else if (offpage && _heart > 0) // Ball off page but the player still have heart
		begin
			bar_x_reg = bar_x_next;
			bar_y_reg = 11'h226; //550
			ball_x_reg = 11'h18f; //399
			ball_y_reg = 11'h190; //400
			x_delta_reg = x_delta_next;
			y_delta_reg = y_delta_next;
		    _heart <= _heart-1;
		end		
		
	else if (offpage && _heart == 0) // Game Over, Wait for player to restart
		begin
			if (btnL || btnR)
			begin
                bar_x_reg = 11'h18f; //399
                bar_y_reg = 11'h226; //550
                ball_x_reg = 11'h18f; //399
                ball_y_reg = 11'h190; //400
                x_delta_reg = 11'h000; //not move
                y_delta_reg = 11'h002; //down
				_heart <= 3;
				full_board <= 0;
            end
		end		
    else if (send_56) // Player Win
		begin
			_heart <= 3;
			bar_x_reg = bar_x_next;
			ball_x_reg = 11'h18f;
			ball_y_reg = 11'h12b;
			x_delta_reg = x_delta_next;
			y_delta_reg = y_delta_next;
		end		    
	else 
		begin
			bar_x_reg = bar_x_next;
			bar_y_reg = 11'h226; //550
			ball_x_reg = ball_x_next;
			ball_y_reg = ball_y_next;
			x_delta_reg = x_delta_next;
			y_delta_reg = y_delta_next;
		end

// refresh_tick: 1-clock tick asserted at start of v-sync
// i.e. - when the screen is refreshed (72 Hz)
assign refr_tick = (pix_y == 601) && (pix_x == 0);



//------------------------------------------------------------------// 



// Wall left vertical strip
// Pixel within wall
assign wall_on = ((WALL_X_L <= pix_x) && (pix_x <= WALL_X_R)) || ((T_WALL_T <= pix_y) && (pix_y <= T_WALL_B)) || ((WALL_Y_L <= pix_x) && (pix_x <= WALL_Y_R))
		 //((B_WALL_T <= pix_y) && (pix_y <= B_WALL_B))//                     
		  ; 
// Wall RGB
assign wall_rgb_red = 4'b0000;
assign wall_rgb_green = 4'b0111;
assign wall_rgn_blue = 4'b0000;



//------------------------------------------------------------------//	



// Right vertical Bar (Paddle)
// Boundary
assign bar_y_t = bar_y_reg;
assign bar_y_b = bar_y_t + BAR_Y_SIZE - 1;
// Pixel within bar 

//-fix-//
assign bar_on = (bar_x_l <= pix_x) && (pix_x <= bar_x_r) && (bar_y_t <= pix_y) && (pix_y <= bar_y_b);


// Bar RGB output
assign bar_rgb_red = 4'b0000;
assign bar_rgb_green = 4'b0000;
assign bar_rgb_blue = 4'b0111;


// New bar x-position
always @*
begin
    bar_x_next = bar_x_reg; // No move
    if (refr_tick) begin
        if (btnR && (bar_x_r < (MAX_X - 1 - BAR_V))) // Move right
            bar_x_next = bar_x_reg + BAR_V;
        else if (btnL && (bar_x_l > BAR_V)) // Move left
            bar_x_next = bar_x_reg - BAR_V;
    end
end

// Assign bar_x_l and bar_x_r based on bar_x_reg
assign bar_x_l = bar_x_reg;         // Left boundary of the bar
assign bar_x_r = bar_x_l + 140 - 1; // Right boundary of the bar



//-------------------------------------------------------------------//

// Square Ball
// Boundary
assign ball_x_l = ball_x_reg;
assign ball_y_t = ball_y_reg;
assign ball_x_r = ball_x_l + BALL_SIZE - 1;
assign ball_y_b = ball_y_t + BALL_SIZE - 1;
// Pixel within square ball
assign sq_ball_on = (ball_x_l <= pix_x) && (pix_x <= ball_x_r) && (ball_y_t <= pix_y) && (pix_y <= ball_y_b);
// Map current pixel location to ROM addr/col
assign rom_addr = pix_y[2:0] - ball_y_t[2:0];
assign rom_col = pix_x[2:0] - ball_x_l[2:0];
assign rom_bit = rom_data[rom_col];
// Pixel within ball
assign rd_ball_on = sq_ball_on && rom_bit;
// Ball RGB output
assign ball_rgb_red = 4'b0111;
assign ball_rgb_green = 4'b0000;
assign ball_rgb_blue = 4'b0000;
// New ball position
assign ball_x_next = (refr_tick) ? ball_x_reg + x_delta_reg : ball_x_reg;
assign ball_y_next = (refr_tick) ? ball_y_reg + y_delta_reg : ball_y_reg;

// Ouput from blocks - move up
assign MOVE_UP = C0_U || C1_U || C2_U || C3_U || C4_U || C5_U || C6_U;

// Ouput from blocks - move down
assign MOVE_DOWN = C0_D || C1_D || C2_D || C3_D || C4_D || C5_D || C6_D;

// Ouput from blocks - move left
assign MOVE_LEFT = C0_L || C1_L || C2_L || C3_L || C4_L || C5_L || C6_L;

// Ouput from blocks - move right
assign MOVE_RIGHT = C0_R || C1_R || C2_R || C3_R || C4_R || C5_R || C6_R;

// In case two directions are set high at the same time,
// make a counter, and chose a new direction.
reg UP_DOWN, LEFT_RIGHT;

// Case of multiple hits at once continued....
always @(posedge clk)
	if ((MOVE_UP == 1) && (MOVE_DOWN == 1))
		UP_DOWN <= UP_DOWN + 1;

always @(posedge clk)
	if ((MOVE_LEFT == 1) && (MOVE_RIGHT == 1))
		LEFT_RIGHT <= LEFT_RIGHT + 1;

// New ball velocity - Off-screen
always @*
begin

	if (ball_y_b >= B_WALL_T) // offscreen when out from bottom
		offpage = 1;
	else
		offpage = 0;
end

// New ball velocity - y-direction
always @*
begin
	y_delta_next = y_delta_reg;

	// reach top wall
	if (ball_y_t <= T_WALL_B)	
		y_delta_next = BALL_V_P;

	// Ball hits top of a block
	else if ((MOVE_UP == 1) && (MOVE_DOWN == 0))
		y_delta_next = BALL_V_N;

	// Ball hits the bottom of a block
	else if ((MOVE_DOWN == 1) && (MOVE_UP == 0))
		y_delta_next = BALL_V_P;

	// Ball hits both top and bottom of neighbor blocks
	else if ((MOVE_DOWN == 1) && (MOVE_UP == 1))
		begin
			if (UP_DOWN == 1)
				y_delta_next = BALL_V_P;

			else
				y_delta_next = BALL_V_N;

		end

	// Reach bottom of paddle, hit, ball bounce back
	else if ((bar_x_l <= ball_x_r) && (ball_x_r <= bar_x_r) && ((bar_y_t + 40) <= ball_y_b) && (ball_y_t <= bar_y_b))	
			y_delta_next = BALL_V_P_Y;

	else if ((bar_x_l <= ball_x_r) && (ball_x_r <= bar_x_r) && (bar_y_t <= ball_y_b) && (ball_y_t <= (bar_y_t + 39)))
			y_delta_next = BALL_V_N_Y;

	
end

// New ball velocity - x-direction
always @*
begin
	x_delta_next = x_delta_reg;
    
    // reach left wall
	if (ball_x_l <= WALL_X_R)	
        x_delta_next = BALL_V_P; // bounce ball
        
	// reach right wall
	else if (ball_x_r >= WALL_Y_L)
		x_delta_next = BALL_V_N; // bounce ball
		

	// Ball hits the left side of a block
	else if ((MOVE_LEFT == 1) && (MOVE_RIGHT == 0))
		x_delta_next = BALL_V_N;
	
	// Ball hits the right side of a block
	else if ((MOVE_RIGHT == 1) && (MOVE_LEFT == 0))
		x_delta_next = BALL_V_P;

	// Ball hits both left and right of neighbor blocks
	else if ((MOVE_LEFT == 1) && (MOVE_RIGHT == 1))
		begin
			if (LEFT_RIGHT == 1)
				x_delta_next = BALL_V_P;

			else
				x_delta_next = BALL_V_N;

		end

	// Reach bottom of paddle, hit, ball bounce back
	else if ((BAR_X_L <= ball_x_r) && (ball_x_r <= BAR_X_R) && ((bar_y_t + 40) <= ball_y_b) && (ball_y_t <= bar_y_b))	
			x_delta_next = BALL_V_N;

	else if ((BAR_X_L <= ball_x_r) && (ball_x_r <= BAR_X_R) && (bar_y_t <= ball_y_b) && (ball_y_t <= (bar_y_t + 39)))
			x_delta_next = BALL_V_N;

end


//-----------------------------------------------------------------------// 
// RGB Multiplexing Circuit
always @*
	if (~video_on) begin
		vgaRed <= 4'b0000;
		vgaGreen <= 4'b0000;
		vgaBlue <= 4'b0000;
	end
	else begin
	// Top, bottom, and left wall is on
		if (wall_on) begin
			vgaRed <= wall_rgb_red;
			vgaGreen <= wall_rgb_green;
			vgaBlue <= wall_rgb_blue;
		end 
	// Paddle is on
		else if (bar_on) begin
			vgaRed <= bar_rgb_red;
			vgaGreen <= bar_rgb_green;
			vgaBlue <= bar_rgb_blue;
		end
	// Ball is on
		else if (rd_ball_on) begin
			vgaRed <= ball_rgb_red;
			vgaGreen <= ball_rgb_green;
			vgaBlue <= ball_rgb_blue;
		end
	// Blocks in column one are on	
		else if (C0_ON) begin
			vgaRed <= 4'b0111;
			vgaGreen <= 4'b0011;
			vgaBlue <= 4'b1101;
		end
	// Blocks in column two are on	
		else if (C1_ON) begin
			vgaRed <= 4'b1010;
			vgaGreen <= 4'b0000;
			vgaBlue <= 4'b1000;
		end
	// Blocks in column three are on	
		else if (C2_ON) begin
			vgaRed <= 4'b0000;
			vgaGreen <= 4'b0000;
			vgaBlue <= 4'b1111;
		end
	// Blocks in column four are on	
		else if (C3_ON) begin
			vgaRed <= 4'b0001;
			vgaGreen <= 4'b1011;
			vgaBlue <= 4'b0011;
		end
	// Blocks in column five are on
		else if (C4_ON) begin
			vgaRed <= 4'b1111;
			vgaGreen <= 4'b1110;
			vgaBlue <= 4'b0100;
		end
	// Blocks in column six are on
		else if (C5_ON) begin
			vgaRed <= 4'b1111;
			vgaGreen <= 4'b0111;
			vgaBlue <= 4'b0010;
		end
	// Blocks in column seven are on
		else if (C6_ON) begin
			vgaRed <= 4'b1101;
			vgaGreen <= 4'b0001;
			vgaBlue <= 4'b0010;
		end
		
	// Heart Left are on
		else if (heart_ON_1) begin
			vgaRed <= heart_rgb_red;
			vgaGreen <= heart_rgb_green;
			vgaBlue <= heart_rgb_blue;
		end
	// Heart Middle are on
		else if (heart_ON_2) begin
			vgaRed <= heart_rgb_red;
			vgaGreen <= heart_rgb_green;
			vgaBlue <= heart_rgb_blue;
		end
	// Heart Right are on
		else if (heart_ON_3) begin
			vgaRed <= heart_rgb_red;
			vgaGreen <= heart_rgb_green;
			vgaBlue <= heart_rgb_blue;
		end
		
		
	// Ones bit of scoreboard is on
		else if (score_ON_R) begin
			vgaRed <= 4'b0111;
			vgaGreen <= 4'b0001;
			vgaBlue <= 4'b0001;
		end
	// Tens bit of scoreboard is on
		else if (score_ON_RM) begin
			vgaRed <= 4'b0111;
			vgaGreen <= 4'b0001;
			vgaBlue <= 4'b0001;
		end
	// Hundreds bit of scoreboard is on
		else if (score_ON_LM) begin
			vgaRed <= 4'b0111;
			vgaGreen <= 4'b0001;
			vgaBlue <= 4'b0001;
		end
	// Thousands bit of scoreboard is on	
		else if (score_ON_L) begin
			vgaRed <= 4'b0111;
			vgaGreen <= 4'b0001;
			vgaBlue <= 4'b0001;
		end
	// Background is on
		else begin
			vgaRed <= 4'b0000;
			vgaGreen <= 4'b0000;
			vgaBlue <= 4'b0000;
		end
	end
		
endmodule
