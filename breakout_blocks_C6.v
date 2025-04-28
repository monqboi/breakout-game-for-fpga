//----------------------------------//
// Breakout Files
// breakout_blocks_C6.v
// David J. Morvay
// ECEN 4856
// Fall 2020
//----------------------------------//

module breakout_blocks_C6 (clk, reset, pix_x, pix_y, ball_x_r, ball_x_l, ball_y_t, ball_y_b, moveU, moveD, moveL, moveR, C6_count, C6_ON);
input clk, reset;
input [10:0] pix_x, pix_y, ball_x_r, ball_x_l, ball_y_t, ball_y_b;

output moveU, moveD, moveL, moveR;
output [3:0] C6_count; 
output C6_ON;

// Top, bottom, left, right side of block registers
reg moveU, moveD, moveL, moveR;
reg b0R, b0L, b0D;
reg b1R, b1L, b1U, b1D;
reg b2R, b2L, b2U, b2D;
reg b3R, b3L, b3U, b3D;
reg b4R, b4L, b4U, b4D;
reg b5R, b5L, b5U, b5D;
reg b6R, b6L, b6U, b6D;
reg b7R, b7L, b7U, b7D;


reg [7:0] blocks_C6;
initial blocks_C6 = 8'b11111111;

// Signals to turn blocks on
assign block_C6_R0 = ((4 <= pix_y) && (19 >= pix_y) && (687 <= pix_x) && (792 >= pix_x) && (blocks_C6[0] == 1));
assign block_C6_R1 = ((27 <= pix_y) && (42 >= pix_y) && (687 <= pix_x) && (792 >= pix_x) && (blocks_C6[1] == 1));
assign block_C6_R2 = ((50 <= pix_y) && (65 >= pix_y) && (687 <= pix_x) && (792 >= pix_x) && (blocks_C6[2] == 1));
assign block_C6_R3 = ((73 <= pix_y) && (88 >= pix_y) && (687 <= pix_x) && (792 >= pix_x) && (blocks_C6[3] == 1));
assign block_C6_R4 = ((96 <= pix_y) && (111 >= pix_y) && (687 <= pix_x) && (792 >= pix_x) && (blocks_C6[4] == 1));
assign block_C6_R5 = ((119 <= pix_y) && (134 >= pix_y) && (687 <= pix_x) && (792 >= pix_x) && (blocks_C6[5] == 1));
assign block_C6_R6 = ((142 <= pix_y) && (157 >= pix_y) && (687 <= pix_x) && (792 >= pix_x) && (blocks_C6[6] == 1));
assign block_C6_R7 = ((165 <= pix_y) && (180 >= pix_y) && (687 <= pix_x) && (792 >= pix_x) && (blocks_C6[7] == 1));

// x - Parameters for this column of blocks
localparam right_border = 792;
localparam right_border_in = 789;
localparam left_border = 687;
localparam left_border_in = 690;
localparam right_ext = 799;
localparam left_ext = 680;

reg counter0, counter1, counter2, counter3, counter4, counter5, counter6, counter7;


// Board reset
// If a block has been hit, it will turn off the block, and increment the score
always @(posedge clk)
	if (reset)
		blocks_C6 = 8'b11111111;
	else if (b0R || b0L || b0D)
		blocks_C6[0] = 0;
	else if (b1R || b1L || b1U || b1D)
		blocks_C6[1] = 0;
	else if (b2R || b2L || b2U || b2D)
		blocks_C6[2] = 0;
	else if (b3R || b3L || b3U || b3D)
		blocks_C6[3] = 0;
	else if (b4R || b4L || b4U || b4D)
		blocks_C6[4] = 0;
	else if (b5R || b5L || b5U || b5D)
		blocks_C6[5] = 0;
	else if (b6R || b6L || b6U || b6D)
		blocks_C6[6] = 0;
	else if (b7R || b7L || b7U || b7D)
		blocks_C6[7] = 0;
        

// If any block is hit, the signal is sent here to
// determine the direction the ball should be redirected.
always @(posedge clk)
	if (b0R || b1R || b2R || b3R || b4R || b5R || b6R || b7R)
		moveR = 1;
	else
		moveR = 0;

always @(posedge clk)
	if (b0L || b1L || b2L || b3L || b4L || b5L || b6L || b7L)
		moveL = 1;
	else
		moveL = 0;

always @(posedge clk)
	if (b1U || b2U || b3U || b4U || b5U || b6U || b7U)
		moveU = 1;
	else
		moveU = 0;

always @(posedge clk)
	if (b0D || b1D || b2D || b3D || b4D || b5D || b6D || b7D)
		moveD = 1;
	else
		moveD = 0;


// Always block for right of block hits.
// If the ball hits the right side of the block,
// it will bounce off towards to right direction.
always @(posedge clk)
	if ((ball_x_l <= right_border) && (ball_x_l >= right_border_in) && (ball_y_t >= 0) && (ball_y_t <= 19) && (blocks_C6[0] == 1)) 
		b0R = 1;
	
	else if ((ball_x_l <= right_border) && (ball_x_l >= right_border_in) && (ball_y_b >= 27) && (ball_y_t <= 42) && (blocks_C6[1] == 1))
		b1R = 1;

	else if ((ball_x_l <= right_border) && (ball_x_l >= right_border_in) && (ball_y_b >= 50) && (ball_y_t <= 65) && (blocks_C6[2] == 1))
		b2R = 1;

	else if ((ball_x_l <= right_border) && (ball_x_l >= right_border_in) && (ball_y_b >= 73) && (ball_y_t <= 88) && (blocks_C6[3] == 1))
		b3R = 1;

	else if ((ball_x_l <= right_border) && (ball_x_l >= right_border_in) && (ball_y_b >= 96) && (ball_y_t <= 111) && (blocks_C6[4] == 1))
		b4R = 1;

	else if ((ball_x_l <= right_border) && (ball_x_l >= right_border_in) && (ball_y_b >= 119) && (ball_y_t <= 134) && (blocks_C6[5] == 1))
		b5R = 1;

	else if ((ball_x_l <= right_border) && (ball_x_l >= right_border_in) && (ball_y_b >= 142) && (ball_y_t <= 157) && (blocks_C6[6] == 1))
		b6R = 1;

	else if ((ball_x_l <= right_border) && (ball_x_l >= right_border_in) && (ball_y_b >= 165) && (ball_y_b <= 180) && (blocks_C6[7] == 1))
		b7R = 1;
	
	else 
		begin
			b0R = 0; b1R = 0; b2R = 0; b3R = 0; b4R = 0; b5R = 0; b6R = 0; b7R = 0;
		end			

// Always block for left side hits
// If the ball hits the left side of a block,
// it will bounce back in the left direction.
always @(posedge clk)
	if ((ball_x_r <= left_border_in) && (ball_x_r >= left_border) && (ball_y_t >= 0) && (ball_y_t <= 19) && (blocks_C6[0] == 1)) 
		b0L = 1;
	
	else if ((ball_x_r <= left_border_in) && (ball_x_r >= left_border) && (ball_y_b >= 27) && (ball_y_t <= 42) && (blocks_C6[1] == 1))
		b1L = 1;

	else if ((ball_x_r <= left_border_in) && (ball_x_r >= left_border) && (ball_y_b >= 50) && (ball_y_t <= 65) && (blocks_C6[2] == 1))
		b2L = 1;

	else if ((ball_x_r <= left_border_in) && (ball_x_r >= left_border) && (ball_y_b >= 73) && (ball_y_t <= 88) && (blocks_C6[3] == 1))
		b3L = 1;

	else if ((ball_x_r <= left_border_in) && (ball_x_r >= left_border) && (ball_y_b >= 96) && (ball_y_t <= 111) && (blocks_C6[4] == 1))
		b4L = 1;

	else if ((ball_x_r <= left_border_in) && (ball_x_r >= left_border) && (ball_y_b >= 119) && (ball_y_t <= 134) && (blocks_C6[5] == 1))
		b5L = 1;

	else if ((ball_x_r <= left_border_in) && (ball_x_r >= left_border) && (ball_y_b >= 142) && (ball_y_t <= 157) && (blocks_C6[6] == 1))
		b6L = 1;

	else if ((ball_x_r <= left_border_in) && (ball_x_r >= left_border) && (ball_y_b >= 165) && (ball_y_b <= 180) && (blocks_C6[7] == 1))
		b7L = 1;
	else 
		begin
			b0L = 0; b1L = 0; b2L = 0; b3L = 0; b4L = 0; b5L = 0; b6L = 0; b7L = 0;
		end	

// Always block for bottom side hits
// If the ball hits the bottom side of a block,
// it will bounce back in the down direction.
always @(posedge clk)
	if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_t <= 19) && (ball_y_t >= 16) && (blocks_C6[0] == 1))
		b0D = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_t <= 42) && (ball_y_t >= 39) && (blocks_C6[1] == 1))
		b1D = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_t <= 65) && (ball_y_t >= 62) && (blocks_C6[2] == 1))
		b2D = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_t <= 88) && (ball_y_t >= 85) && (blocks_C6[3] == 1))
		b3D = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_t <= 111) && (ball_y_t >= 108) && (blocks_C6[4] == 1))
		b4D = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_t <= 134) && (ball_y_t >= 131) && (blocks_C6[5] == 1))
		b5D = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_t <= 157) && (ball_y_t >= 154) && (blocks_C6[6] == 1))
		b6D = 1;
		
	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_t <= 180) && (ball_y_t >= 173) && (blocks_C6[7] == 1))
		b7D = 1;
		
	else 
		begin
			b0D = 0; b1D = 0; b2D = 0; b3D = 0; b4D = 0; b5D = 0; b6D = 0; b7D = 0;
		end	

// Always block for top side hits
// If the ball hits the top side of a block,
// it will bounce back in the up direction.
always @(posedge clk)
	if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_b >= 27) && (ball_y_b <= 30) && (blocks_C6[1] == 1))
		b1U = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_b >= 50) && (ball_y_b <= 53) && (blocks_C6[2] == 1))
		b2U = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_b >= 73) && (ball_y_b <= 76) && (blocks_C6[3] == 1))
		b3U = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_b >= 96) && (ball_y_b <= 99) && (blocks_C6[4] == 1))
		b4U = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_b >= 119) && (ball_y_b <= 122) && (blocks_C6[5] == 1))
		b5U = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_b >= 142) && (ball_y_b <= 145) && (blocks_C6[6] == 1))
		b6U = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_b >= 163) && (ball_y_b <= 166) && (blocks_C6[7] == 1))
		b7U = 1;
	
	else 
		begin
			b1U = 0; b2U = 0; b3U = 0; b4U = 0; b5U = 0; b6U = 0; b7U = 0; 
		end	

// Signal sent to turn on a block	
assign C6_ON = block_C6_R0 || block_C6_R1 || block_C6_R2 || block_C6_R3 || block_C6_R4 || block_C6_R5 || block_C6_R6 || block_C6_R7;

// Counter to determine score from the number of blocks hit
reg [7:0] C6_count_small;
always @(posedge clk) begin
		C6_count_small <= (counter0 + counter1 + counter2 + counter3 + counter4 + counter5 + counter6 + counter7);
end

// Score multipled to appropriate amount for the respectice column
reg [15:0] C6_count;
always @(posedge clk) begin
	C6_count <= C6_count_small * 1;
end
		
endmodule
