# LINE 902, 932, 1166, 1189 IMPLEMENTED ENHANCEMENT Increase difficulty by increasing the number of boxes and targets.
# Explanation: The implementation of the diffuculty enhancement is spread accross many different functions, so to help structure 
             # this explanation I will explain them in the order that they would be executed in when running the game. So, before 
			 # the board is generated inside the _start function the game prompts the user to enter the diffuculty (the number of 
			 # boxes and targets they want) The program stores that value in memory under variable name difficulty. Later the program 
			 # jumps from the _start function to the play function, to give player x a turn at solving the board. Inside the play 
			 # function there is a loop which loops over function createBox and function createTarget calling them each iteration. 
			 # The functions createBox and createTarget add the newly generated coordinates to the box and target arrays in 
			 # memory, respectively. After each iteration the pointers s3, s4 , that point to the front of the arrays box and target 
			 # get incremented by 2 bytes so that for the next loop when createBox and createTarget are called again the new coordinates
			 # don't overwrite the coordinates that were added in the previous loop. 
			 # After the loop terminates the characters coordinates are saved in memory under character by calling createCharacter and 
			 # then the board is constructed by calling the construct_board function. To get all the targets and boxes onto the board, 
			 # for each space on the board, construct_board checks the box and target arrays to see if there are any boxes or targets 
			 # at that square on the board. The construct_board function is able to check all the values in arrays target and box by 
			 # starting at the base address of the array and advancing 2 bytes and reading the first 2 bites each iteration. The 
			 # iteration stops when the address of the last checked coordinate is equal to the pointer to box or target. The rest of 
			 # the program runs as normal.



# LINE 721, 733, 738, 776 IMPLEMENTED ENHANCEMENT Provide a multi-player (competitive) mode.
# Explanation: The implementation of the multi-player enhancement is spread accross many different functions, so to help structure
			 # this explanation I will explain them in the order that they would be executed in when running the game. The first 
			 # place my code has catered to this enhancement is in the _start function. It's before the board is generated, when 
			 # the user is prompted to enter the number of players that will be playing. The number is then stored in memory under
			 # the variable num_players. A bit farther down into the _start function there is a loop labeled player_loop, this is 
			 # what allows the game to be re-played by each player. Additionally, the variable s0 tracks how many moves were made 
			 # during that play so, when play returns, we save s0, in an array, score, that stores the number of steps it took 
			 # each player to complete the board. Next, since we need to keep constructing the same board for every player, we 
			 # need to always start with the same seed. This is why there is a variable called static_seed. Unlike static_seed, 
			 # the variable named just seed updates whever I use my LCG_RAND function. The LCG_RAND function is used to compute 
			 # all the random coordiantes of objects on my board. So at the start of the next players turn I must set the value 
			 # of seed back to the value of static_seed. The seed is updated in the player_loop of the _start function. Lastly, 
			 # at the end of the game once every player has completed a board, the leaderboard is generated (inside _start). 
			 # The leaderboard ranks each player by the number of moves it took them to complete the board. In order to get the 
			 # leaderboard standings I used the score array. Each index of the score array corresponded to player [index+1].
			 # I looped over the score array and each time I chose the smallest number and displayed the player whose number that 
			 # was. Then I would set that number to be the largest possible number that can be represented in 32 bits. This 
			 # iterated once for each player there was in the game, so by the end of the interations I would have the leaderboard 
			 # show all of their rankings. 



# THE REFERENCE FOR MY LCG_RAND FUNCTION IS REFERENCED ON LINE 1992

.data
# text responses
enter_difficulty: .string "ENTER NUMBER OF BOXES AND TARGETS\n"
wrong_bool: .string "That was not a valid input.\n"
play_again: .string "Play again? y(yes)/n(no)\n"
wrong_grid_size: .string "The grid dimentions must be greater or equal to 3\n\n"
clear_console: .string "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
prompt: .string "> "
size_prompt_x: .string "ENTER BOARD WIDTH\n"
size_prompt_y: .string "ENTER BOARD HEIGHT\n"
invalid: .string "Your input was invalid. Enter character r, w, s, a, or d.\n"
win: .string "Yay! You pushed all the boxes into target locations.\n---------------------------------\n\n\n"
wall_up: .string "Cannot move up\n"
wall_down: .string "Cannot move down\n"
wall_left: .string "Cannot move left\n"
wall_right: .string "Cannot move right\n"
player_count: .string "ENTER THE NUMBER OF PLAYERS\n"
player_turn: .string "IT IS NOW THE TURN OF PLAYER "
leader: .string "LEADERBOARD (number of moves)\n========================================\n"
p: .string "Player "
line: .string "------------------------"

# LCG Formula
.align 2
max: .word 0 # the width/height of the board needs to be updated before lcg_rand called
modulus: .word 2097152 # variable in our LCG formula
ad: .word 5461 # variable in our LCG formula
c: .word 23897 # variable in our LCG formula
seed: .word 7 # variable in our LCG formula
static_seed: .word 7 # original seed allowing all user to play the same board

# Game Board
difficulty: .word 0
num_players: .word 0
gridsize:   .byte 0,0
character:  .byte 0,0
board_comp1: .string "+---"
board_comp2: .string "+"
board_comp3: .string "\n"
board_comp4: .string "   "
board_comp5: .string "|"
board_comp6: .string "X"
board_comp7: .string "X---"
board_comp8: .string "XXXX"
character_symbol: .string " @ "
box_symbol:        .string " # "
target_symbol:     .string " ! "
empty:
	.space 128
.align 2
score: 
	.space 128
box:        
	.space 128 # arbitrary long array b_1x, b_1y, b_2x, b_2y, ...
target:     
	.space 128 # arbitrary long array t_1x, t_1y, t_2x, t_2y, ...

.text
.globl _start


# returns Nothing since it just adds a new box to the box array
createBox: # creates a box that has any coordinate except for a corner of the board
	addi sp, sp, -4
	sw x1, 0(sp)
	addi sp, sp, -4
	sw a1, 0(sp)
	restart2:
	
	addi t0, s1, -1 # the width index
	addi t1, s2, -1 # the height index

	la a0, max
	sw s1, 0(a0)
	jal x1, lcg_rand
	mv t3, a0
	sb a0, 0(s3)
	
	la a0, max
	sw s2, 0(a0)
	jal x1, lcg_rand
	mv t4, a0
	sb a0, 1(s3)
	
	#t3 represents x value 
	#t4 represents y value
	
	bne t3, x0, end1
	bne t4, x0, end1
	j restart2
	end1:
	
	bne t3, x0, end2
	bne t4, t1, end2
	j restart2
	end2:
	
	bne t4, x0, end3
	bne t3, t0, end3
	j restart2
	end3:
	
	bne t4, t1, end4
	bne t3, t0, end4
	j restart2
	end4:	
	
	beq t3, x0, on_wall_edge_case_left
	beq t4, x0, on_wall_edge_case_top
	beq t3, t0, on_wall_edge_case_right
	beq t4, t1, on_wall_edge_case_bottom
	beq x0, x0, not_on_wall_edge_case
	
	#t3 represents x value 
	#t4 represents y value
	
	on_wall_edge_case_left:
	
	la t2, box
	li a2, 1
	beq t4, a2, loop_check_boxes_left_diagonal1
	j done_check_boxes_left_diagonal1
	loop_check_boxes_left_diagonal1:
		beq t2, s3, done_check_boxes_left_diagonal1
		lb t5, 0(t2)
		lb t6, 1(t2)
		
		li a2, 1
		
		bne t5, a2, next_set_left_diagonal1
		bne t6, zero, next_set_left_diagonal1
		beq x0, x0, restart2	
		
		next_set_left_diagonal1:
		addi t2, t2, 2
		j loop_check_boxes_left_diagonal1
	done_check_boxes_left_diagonal1:
	
	
	la t2, box
	addi a2, s2, -2
	li a3, 1
	beq t4, a2, loop_check_boxes_left_diagonal2
	j done_check_boxes_left_diagonal2
	loop_check_boxes_left_diagonal2:
		beq t2, s3, done_check_boxes_left_diagonal2
		lb t5, 0(t2)
		lb t6, 1(t2)
		
		addi a2, s2, -1
		
		bne t5, a3, next_set_left_diagonal2
		bne t6, a2, next_set_left_diagonal2
		beq x0, x0, restart2	
		
		next_set_left_diagonal2:
		addi t2, t2, 2
		j loop_check_boxes_left_diagonal2
	done_check_boxes_left_diagonal2:
	
	
	la t2, box
	loop_check_boxes_left:
		beq t2, s3, done_check_boxes_left
		lb t5, 0(t2)
		lb t6, 1(t2)
		addi a1, t6, 1
		addi a2, t6, -1
		
		
		bne t5, t3, next_set_left
		beq t4, a1, restart2 
		beq t4, a2, restart2
		beq t4, t6, restart2
		beq x0, x0, next_set_left
		
		next_set_left:
		addi t2, t2, 2
		j loop_check_boxes_left
	done_check_boxes_left:
	j not_on_wall_edge_case
	
	
	
	on_wall_edge_case_right:
	
	
	la t2, box
	li a2, 1
	beq t4, a2, loop_check_boxes_right_diagonal1
	j done_check_boxes_right_diagonal1
	loop_check_boxes_right_diagonal1:
		beq t2, s3, done_check_boxes_right_diagonal1
		lb t5, 0(t2)
		lb t6, 1(t2)
		
		addi a2, s2, -2
		
		bne t5, a2, next_set_right_diagonal1
		bne t6, zero, next_set_right_diagonal1
		beq x0, x0, restart2	
		
		next_set_right_diagonal1:
		addi t2, t2, 2
		j loop_check_boxes_right_diagonal1
	done_check_boxes_right_diagonal1:
	
	
	la t2, box
	addi a2, s2, -2
	li a3, 1
	beq t4, a2, loop_check_boxes_right_diagonal2
	j done_check_boxes_right_diagonal2
	loop_check_boxes_right_diagonal2:
		beq t2, s3, done_check_boxes_right_diagonal2
		lb t5, 0(t2)
		lb t6, 1(t2)
		
		addi a2, s2, -1
		addi a3, s1, -2
		bne t5, a3, next_set_right_diagonal2
		bne t6, a2, next_set_right_diagonal2
		beq x0, x0, restart2	
		
		next_set_right_diagonal2:
		addi t2, t2, 2
		j loop_check_boxes_right_diagonal2
	done_check_boxes_right_diagonal2:
	
	
	
	la t2, box
	loop_check_boxes_right:
		beq t2, s3, done_check_boxes_right
		lb t5, 0(t2)
		lb t6, 1(t2)
		addi a1, t6, 1
		addi a2, t6, -1
		
		
		bne t5, t3, next_set_right
		beq t4, a1, restart2 
		beq t4, a2, restart2
		beq t4, t6, restart2
		beq x0, x0, next_set_right
		
		next_set_right:
		addi t2, t2, 2
		j loop_check_boxes_right
	done_check_boxes_right:
	j not_on_wall_edge_case
	
	
	
	
	on_wall_edge_case_top:
	
	
	la t2, box
	li a2, 1
	beq t3, a2, loop_check_boxes_top_diagonal1
	j done_check_boxes_top_diagonal1
	loop_check_boxes_top_diagonal1:
		beq t2, s3, done_check_boxes_top_diagonal1
		lb t5, 0(t2)
		lb t6, 1(t2)
		
		li a2, 1
		
		bne t5, zero, next_set_top_diagonal1
		bne t6, a2, next_set_top_diagonal1
		beq x0, x0, restart2	
		
		next_set_top_diagonal1:
		addi t2, t2, 2
		j loop_check_boxes_top_diagonal1
	done_check_boxes_top_diagonal1:
	
	
	la t2, box
	addi a2, s1, -2
	li a3, 1
	beq t3, a2, loop_check_boxes_top_diagonal2
	j done_check_boxes_top_diagonal2
	loop_check_boxes_top_diagonal2:
		beq t2, s3, done_check_boxes_top_diagonal2
		lb t5, 0(t2)
		lb t6, 1(t2)
		
		addi a2, s2, -1
		
		bne t5, a2, next_set_top_diagonal2
		bne t6, a3, next_set_top_diagonal2
		beq x0, x0, restart2	
		
		next_set_top_diagonal2:
		addi t2, t2, 2
		j loop_check_boxes_top_diagonal2
	done_check_boxes_top_diagonal2:
	
	
	
	la t2, box
	loop_check_boxes_top:
		beq t2, s3, done_check_boxes_top
		lb t5, 0(t2)
		lb t6, 1(t2)
		addi a1, t5, 1
		addi a2, t5, -1
		
		
		bne t6, t4, next_set_top
		beq t3, a1, restart2 
		beq t3, a2, restart2
		beq t3, t5, restart2
		beq x0, x0, next_set_top
		
		next_set_top:
		addi t2, t2, 2
		j loop_check_boxes_top
	done_check_boxes_top:
	j not_on_wall_edge_case
	
	
	
	on_wall_edge_case_bottom:
	
	
	la t2, box
	li a2, 1
	beq t3, a2, loop_check_boxes_bottom_diagonal1
	j done_check_boxes_bottom_diagonal1
	loop_check_boxes_bottom_diagonal1:
		beq t2, s3, done_check_boxes_bottom_diagonal1
		lb t5, 0(t2)
		lb t6, 1(t2)
		
		addi a2, s2, -2
		
		bne t5, zero, next_set_bottom_diagonal1
		bne t6, a2, next_set_bottom_diagonal1
		beq x0, x0, restart2	
		
		next_set_bottom_diagonal1:
		addi t2, t2, 2
		j loop_check_boxes_bottom_diagonal1
	done_check_boxes_bottom_diagonal1:
	
	
	
	la t2, box
	addi a2, s1, -2
	addi a3, s2, -2
	beq t3, a2, loop_check_boxes_bottom_diagonal2
	j done_check_boxes_bottom_diagonal2
	loop_check_boxes_bottom_diagonal2:
		beq t2, s3, done_check_boxes_bottom_diagonal2
		lb t5, 0(t2)
		lb t6, 1(t2)
		
		addi a2, s1, -1
		addi a3, s2, -2
		
		bne t5, a2, next_set_bottom_diagonal2
		bne t6, a3, next_set_bottom_diagonal2
		beq x0, x0, restart2	
		
		next_set_bottom_diagonal2:
		addi t2, t2, 2
		j loop_check_boxes_bottom_diagonal2
	done_check_boxes_bottom_diagonal2:
	
	
	la t2, box
	loop_check_boxes_bottom:
		beq t2, s3, done_check_boxes_bottom
		lb t5, 0(t2)
		lb t6, 1(t2)
		addi a1, t5, 1
		addi a2, t5, -1
		
		
		bne t6, t4, next_set_bottom
		beq t3, a1, restart2 
		beq t3, a2, restart2
		beq t3, t5, restart2
		beq x0, x0, next_set_bottom
		
		next_set_bottom:
		addi t2, t2, 2
		j loop_check_boxes_bottom
	done_check_boxes_bottom:
	j not_on_wall_edge_case
	
	
	
	not_on_wall_edge_case:
	
	la t2, box
	la a0, target
	loop_check_prior_boxes_and_targets2:
		beq a0, s4, done_check_prior_boxes_and_targets2
		lb t5, 0(t2)
		lb t6, 1(t2)
		lb a1, 0(a0)
		lb a2, 1(a0)
		bne t5, t3, target_now0
		bne t6, t4, target_now0
		
		j restart2
		target_now0:
		bne a1, t3, next_set0
		bne a2, t4, next_set0
		j restart2
		next_set0:
		addi t2, t2, 2
		addi a0, a0, 2
		j loop_check_prior_boxes_and_targets2
		
		
	done_check_prior_boxes_and_targets2:	
	# IF THIS EQUALS TO ANY OF THE PRIOR BOXES MADE RESTART
	lw a1, 0(sp)
	addi sp, sp, 4
	lw x1, 0(sp)
	addi sp, sp, 4	
	jalr x0, x1
	
	
# returns Nothing since it just updates the variable character
createCharacter: 
	addi sp, sp, -4
	sw x1, 0(sp)
	restart1:
	
	addi t0, s1, -1 # the width index
	addi t1, s2, -1 # the height index

	la t2, character
	la a0, max
	sw s1, 0(a0)
	jal x1, lcg_rand
	mv t3, a0
	sb a0, 0(t2)
	
	la t2, character
	la a0, max
	sw s2, 0(a0)
	jal x1, lcg_rand
	mv t4, a0
	sb a0, 1(t2)
	
	# WE NEED TO CHECK THAT EVERY SINGLE BOX AND TARGET BEFORE ITS POINTER IS NOT EQUAL TO CHARACTER
	la t2, box
	la a0, target
	loop_check_prior_boxes_and_targets_character:
		beq a0, s4, done_check_prior_boxes_and_targets_character
		lb t5, 0(t2)
		lb t6, 1(t2)
		lb a1, 0(a0)
		lb a2, 1(a0)
		bne t5, t3, target_now_character
		bne t6, t4, target_now_character
		j restart1
		target_now_character:
		bne a1, t3, next_set_character
		bne a2, t4, next_set_character
		j restart1
		next_set_character:
		addi t2, t2, 2
		addi a0, a0, 2
		j loop_check_prior_boxes_and_targets_character
		
		
	done_check_prior_boxes_and_targets_character:	
	
	lw x1, 0(sp)
	addi sp, sp, 4	
	jalr x0, x1
	
	
# returns Nothing since it just adds a new target to the target array
# THE POSITION OF BOX WILL ALREADY BE DEFINED AT ITS POINTER LOCATION WHEN THIS FUNCTION IS CALLED
createTarget:
	addi sp, sp, -4
	sw x1, 0(sp)
	addi sp, sp, -4
	sw a1, 0(sp)
	restart3:
	
	addi t0, s1, -1 # the width index
	addi t1, s2, -1 # the height index
	#la t2, box
	lb t3, 0(s3) # x value of box
	lb t4, 1(s3) # y value of box 
	
	beq t3, t0, Case1_1 # x value is max
	beq t4, t1, Case1_2 # y value is max
	beq t3, x0, Case1_3 # x value is 0
	beq t4, x0, Case1_4 # y value is 0
	beq x0, x0, Case2
	
	# the box is on a wall
	Case1_1:
	
	sb t3, 0(s4)
	
	la a0, max
	sw s2, 0(a0)
	jal x1, lcg_rand
	sb a0, 1(s4)
	
	beq t4, a0, Case1_1
	
	j DoneTarget
	
	
	Case1_2:
	
	sb t4, 1(s4)
	
	la a0, max
	sw s1, 0(a0)
	jal x1, lcg_rand
	sb a0, 0(s4)
	
	beq t3, a0, Case1_2
	
	j DoneTarget
	
	
	Case1_3:
	
	sb x0, 0(s4)
	
	la a0, max
	sw s2, 0(a0)
	jal x1, lcg_rand
	sb a0, 1(s4)
	
	beq t4, a0, Case1_3
	
	j DoneTarget
	
	
	Case1_4:
	
	sb x0, 1(s4)
	
	la a0, max
	sw s1, 0(a0)
	jal x1, lcg_rand
	sb a0, 0(s4)
	
	beq t3, a0, Case1_4
	
	j DoneTarget
	
	
	Case2: # box is not on wall 
	
	la a0, max
	sw s1, 0(a0)
	jal x1, lcg_rand
	sb a0, 0(s4)
	mv t5, a0
	
	la a0, max
	sw s2, 0(a0)
	jal x1, lcg_rand
	sb a0, 1(s4)
	mv t6, a0
	
	bne t3, t5, DoneTarget
	bne t4, t6, DoneTarget
	j Case2
	
	DoneTarget:
	
	la t2, box
	la a0, target
	
	lb t3, 0(s4)
	lb t4, 1(s4)
	loop_check_prior_boxes_and_targets:
		beq a0, s4, done_check_prior_boxes_and_targets
		lb t5, 0(t2)
		lb t6, 1(t2)
		lb a1, 0(a0)
		lb a2, 1(a0)
		bne t5, t3, target_now2
		bne t6, t4, target_now2
		j restart3
		target_now2:
		bne a1, t3, next_set2
		bne a2, t4, next_set2
		j restart3
		next_set2:
		addi t2, t2, 2
		addi a0, a0, 2
		j loop_check_prior_boxes_and_targets
			
	done_check_prior_boxes_and_targets:	
	
	# IF THIS EQUALS ANY PREVIOUS TARGET OR BOX RESTART CREATING THIS TARGET
	
	lw a1, 0(sp)
	addi sp, sp, 4
	lw x1, 0(sp)
	addi sp, sp, 4	
	jalr x0, x1
	

_start:
	restart_entire_game:
	li a7, 4
	la a0, clear_console
	ecall
	
	la a6, gridsize
	# asking the size of the board
	j no_error
	ask_width_again:
	li a7, 4
	la a0, wrong_grid_size
	ecall
	no_error:
	li a7, 4
	la a0, size_prompt_x
	ecall
	la a0, prompt
	ecall
	li a7, 5
	ecall
	li a1, 3
	blt a0, a1, ask_width_again
	sb a0, 0(a6)
	j no_error2
	ask_height_again:
	li a7, 4
	la a0, wrong_grid_size
	ecall
	no_error2:
	li a7, 4
	la a0, size_prompt_y
	ecall
	la a0, prompt
	ecall
	li a7, 5
	ecall
	li a1, 3
	blt a0, a1, ask_height_again
	
	sb a0, 1(a6)
	
	# asking the number of targets and boxes
	li a7, 4
	la a0, enter_difficulty
	ecall
	la a0, prompt
	ecall
	li a7, 5
	ecall
	la t2, difficulty
	sw a0, 0(t2)
	
	
	# asking the number of players playing
	li a7, 4
	la a0, player_count
	ecall
	la a0, prompt
	ecall
	li a7, 5
	ecall
	
	la t2, num_players
	sw a0, 0(t2)
	mv a3, a0
	li a7, 4
	la a0, board_comp3
	ecall
	ecall
	li a7, 5
	# now we know the number of players
	
	la t5, static_seed
	la a1, seed
	li a2, 0
	la a4, score
	la a6, player_turn
	player_loop:
		beq a2, a3, leaderboard
		sw t5, 0(a1)
		li a7, 4
		mv a0, a6
		ecall
		li a7, 1
		addi a0, a2, 1
		ecall
		li a7, 4
		la a0, board_comp3
		ecall # PRINT ITS PLAYER X'S TURN
		j play # returns the number of steps in register s0
		next_player:
		slli a5, a2, 2
		add a5, a5, a4
		sw s0, 0(a5)
		addi a2, a2, 1
		j player_loop
		
	leaderboard:
	li a7, 4
	la a0, board_comp3
	ecall
	ecall
	ecall
	la a0, leader
	ecall
	
	la a0, num_players
	la a1, score # the list of scores (indexed by player# + 1)
	li a2, 2147483647 # the smallest number of moves from score list so far
	li a6, 0 # a6 the index of a2
	li a3, 0 # looping value i
	li a4, 0 # looping value j
	lw a5, 0(a0) # upperbound for loop
	li t3, 2147483647
	
	leader_loop:
		beq a3, a5, done_leader_loop
		leader_loopj:
			beq a4, a5, done_leader_loopj
			#we need to get score[a4]
			slli a7, a4, 2
			add a7, a7, a1
			
			# a7 now holds score[a4] address
			lw t0, 0(a7)
			# t0 holds the value at score[a4]
			blt t0, a2, change_a2
			j no_change_a2
			change_a2:
			mv t6, a7
			mv a2, t0
			mv a6, a4
			
			no_change_a2:
			addi a4, a4, 1
			j leader_loopj	
		done_leader_loopj:
		li a4, 0
		
		li a7, 4
		la a0, p
		ecall
		
		li a7, 1
		addi a0, a6, 1
		ecall 
		
		li a7, 4
		la a0, board_comp4
		ecall
		
		li a7, 1
		mv a0, a2
		ecall
		
		li a7, 4
		la a0, board_comp3
		ecall
		
		li a7, 4
		la a0, line
		ecall
		
		li a7, 4
		la a0, board_comp3
		ecall
		
		sw t3, 0(t6)
		addi a3, a3, 1
		li a2, 2147483647
		j leader_loop
	done_leader_loop:
	j first_input
	wrong_input:
	li a7, 4
	la a0, board_comp3
	ecall
	la a0, wrong_bool
	ecall
	
	first_input:
	li a7, 4
	la a0, board_comp3
	ecall
	ecall
	la a0, play_again
	ecall
	la a0, prompt
	ecall
	li a7, 12
	ecall
	li a2, 'y'
	li a3, 'n'
	beq a0, a2, restart_entire_game
	beq a0, a3, end_the_game
	
	end_the_game:
	li a7, 10
	ecall


play:
	addi sp, sp, -4
	sw x1, 0(sp)
	addi sp, sp, -4
	sw a0, 0(sp)
	addi sp, sp, -4
	sw a1, 0(sp)
	addi sp, sp, -4
	sw a2, 0(sp)
	addi sp, sp, -4
	sw a3, 0(sp)
	addi sp, sp, -4
	sw a4, 0(sp)
	addi sp, sp, -4
	sw a5, 0(sp)
	addi sp, sp, -4
	sw a6, 0(sp)
	addi sp, sp, -4
	sw a7, 0(sp)
	addi sp, sp, -4
	sw t0, 0(sp)
	addi sp, sp, -4
	sw t1, 0(sp)
	addi sp, sp, -4
	sw t2, 0(sp)
	addi sp, sp, -4
	sw t3, 0(sp)
	addi sp, sp, -4
	sw t4, 0(sp)
	addi sp, sp, -4
	sw t5, 0(sp)
	addi sp, sp, -4
	sw t6, 0(sp)
	addi sp, sp, -4
	sw s5, 0(sp)
	addi sp, sp, -4
	sw s6, 0(sp)
	# S0 REPRESENTS THE NUMBER OF STEPS FOR THIS PLAY
	# S1 REPRESENTS WIDTH OF BOX
	# S2 REPRESENTS HEIGHT OF BOX
	# S3 REPRESENTS CURR BOX POINTER
	li s0, 0
	la s3, box
	# S4 REPRESENTS CURR TARGET POINTER
	la s4, target
	# S7 REPRESENTS THE NUMBER OF BOXES AND TARGETS THERE WILL BE ON THE BOARD (THE SMALLER DIMENTION OF THE HEIGHT AND WIDTH)
	
	
	
	la t0, gridsize
	lb s1, 0(t0) # width of the board
	lb s2, 1(t0) # height of the board
	
	la s7, difficulty
	lw s7, 0(s7)
	
	mv a0, s1
	mv a1, s2
	addi sp, sp, -4
	sw s2, 0(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	
	##### LOADING COORDINATES FOR CHARACHTER,BOX,TARGET ######
	#addi sp, sp, -4
	mv a0, s1
	mv a1, s2
	
	li a1, 0
	# FOR LOOP OVER CREATING BOX AND TARGET
	loop_for_creation:
		beq a1, s7, create_character_now
		addi sp, sp, -4
		sw x1, 0(sp)
		addi sp, sp, -4
		sw a1, 0(sp)
		addi sp, sp, -4
		sw a2, 0(sp)
		addi sp, sp, -4
		sw a3, 0(sp)
		addi sp, sp, -4
		sw a4, 0(sp)
		addi sp, sp, -4
		sw a5, 0(sp)
		addi sp, sp, -4
		sw a6, 0(sp)
		addi sp, sp, -4
		sw a7, 0(sp)
		addi sp, sp, -4
		sw t0, 0(sp)
		addi sp, sp, -4
		sw t1, 0(sp)
		addi sp, sp, -4
		sw t2, 0(sp)
		addi sp, sp, -4
		sw t3, 0(sp)
		addi sp, sp, -4
		sw t4, 0(sp)
		addi sp, sp, -4
		sw t5, 0(sp)
		addi sp, sp, -4
		sw t6, 0(sp)
		addi sp, sp, -4
		sw s5, 0(sp)
		addi sp, sp, -4
		sw s6, 0(sp)
		jal x1, createBox
		jal x1, createTarget
		lw s6, 0(sp)
		addi sp, sp, 4
		lw s5, 0(sp)
		addi sp, sp, 4
		lw t6, 0(sp)
		addi sp, sp, 4
		lw t5, 0(sp)
		addi sp, sp, 4
		lw t4, 0(sp)
		addi sp, sp, 4
		lw t3, 0(sp)
		addi sp, sp, 4
		lw t2, 0(sp)
		addi sp, sp, 4
		lw t1, 0(sp)
		addi sp, sp, 4
		lw t0, 0(sp)
		addi sp, sp, 4
		lw a7, 0(sp)
		addi sp, sp, 4
		lw a6, 0(sp)
		addi sp, sp, 4
		lw a5, 0(sp)
		addi sp, sp, 4
		lw a4, 0(sp)
		addi sp, sp, 4
		lw a3, 0(sp)
		addi sp, sp, 4
		lw a2, 0(sp)
		addi sp, sp, 4
		lw a1, 0(sp)
		addi sp, sp, 4
		lw x1, 0(sp)
		addi sp, sp, 4	
		addi s3, s3, 2
		addi s4, s4, 2
		addi a1, a1, 1
		j loop_for_creation
		
	create_character_now:
	jal x1, createCharacter
	
	lw s1, 0(sp)
	addi sp, sp, 4
	lw s2, 0(sp)
	addi sp, sp, 4
	
	DoneCreatingObjects:
	
	
	##### NOW WE KNOW THAT THERE ARE NO OBJECT INSIDE ONE ANOTHER #####
    # ---------------------------------------------------------------------------------------------------------#

	#### CREATING A BOARD STRING ####
	mv a0, s1
	mv a1, s2
	#No registers outside of the function call need to be preserved
	addi sp, sp, -4
	sw s2, 0(sp)
	addi sp, sp, -4
	sw s1, 0(sp)
	jal x1, construct_board
	lw s1, 0(sp)
	addi sp, sp, 4
	lw s2, 0(sp)
	addi sp, sp, 4
	
	
	j enter_loop
	end_round:
	
	
	lw s6, 0(sp)
	addi sp, sp, 4
	lw s5, 0(sp)
	addi sp, sp, 4
	lw t6, 0(sp)
	addi sp, sp, 4
	lw t5, 0(sp)
	addi sp, sp, 4
	lw t4, 0(sp)
	addi sp, sp, 4
	lw t3, 0(sp)
	addi sp, sp, 4
	lw t2, 0(sp)
	addi sp, sp, 4
	lw t1, 0(sp)
	addi sp, sp, 4
	lw t0, 0(sp)
	addi sp, sp, 4
	lw a7, 0(sp)
	addi sp, sp, 4
	lw a6, 0(sp)
	addi sp, sp, 4
	lw a5, 0(sp)
	addi sp, sp, 4
	lw a4, 0(sp)
	addi sp, sp, 4
	lw a3, 0(sp)
	addi sp, sp, 4
	lw a2, 0(sp)
	addi sp, sp, 4
	lw a1, 0(sp)
	addi sp, sp, 4
	lw a0, 0(sp)
	addi sp, sp, 4
	lw x1, 0(sp)
	addi sp, sp, 4
	#once this returns we know a persons turn is over
	j next_player
	

construct_board:
	addi sp, sp, -4
	sw x1, 0(sp)
	addi sp, sp, -4
	sw a1, 0(sp)
	addi sp, sp, -4
	sw a2, 0(sp)
	addi sp, sp, -4
	sw a3, 0(sp)
	addi sp, sp, -4
	sw a4, 0(sp)
	addi sp, sp, -4
	sw a5, 0(sp)
	addi sp, sp, -4
	sw a6, 0(sp)
	addi sp, sp, -4
	sw a7, 0(sp)
	addi sp, sp, -4
	sw t0, 0(sp)
	addi sp, sp, -4
	sw t1, 0(sp)
	addi sp, sp, -4
	sw t2, 0(sp)
	addi sp, sp, -4
	sw t3, 0(sp)
	addi sp, sp, -4
	sw t4, 0(sp)
	addi sp, sp, -4
	sw t5, 0(sp)
	addi sp, sp, -4
	sw t6, 0(sp)
	addi sp, sp, -4
	sw s5, 0(sp)
	addi sp, sp, -4
	sw s6, 0(sp)
	
	la t2, character
	lb t0, 0(t2)
	lb t1, 1(t2)
	
	la t4, box
	lb t2, 0(t4)
	lb t3, 1(t4)
	
	la t6, target
	lb t4, 0(t6)
	lb t5, 1(t6)
	
	
	li s5, 0 # the i iteration variable
	li s6, 0 # the j iteration variable
	# s1 width board
	# s2 height board
	li a7, 4
	for1:
		bge s5, s2, for4 #checks for1 loop condition
		for2: 
			bge s6, s1, exitFor2 # checks for2 loop condition
			beq s5, x0, pX1
			beq s6, x0, pX2
			beq x0, x0, notpX
			pX1:	
			la a0, board_comp8
			ecall
			j after
			pX2:
			la a0, board_comp7
			ecall
			j after
			notpX:
			la a0, board_comp1 # printing +--
			ecall
			j after
			after:
			addi s6, s6, 1 # increments s6 by 1
			j for2
			
		exitFor2:
		la a0, board_comp6 # printing X
		ecall
		la a0, board_comp3 # printing \n
		ecall
		li s6, 0 # setting the loop condition for for3 to 0
		
		for3:
			bge s6, s1, exitFor3
			beq s6, x0, pX
			beq x0, x0, notpX1
			
			pX:
			la a0, board_comp6
			ecall
			j after2
			notpX1:
			la a0, board_comp5 # printing | 
			ecall
			j after2
			
			after2:
			# FOR LOOP THROUGH HERE ADJUSTING THE POINTER TO BOX AND TARGET EACH TIME
			bne s6, t0, not_possible_character
			bne s5, t1, not_possible_character
			la a0, character_symbol
			j got_filling
			not_possible_character:
			
			la t2, box
			loop_boxes_and_targets_and_character1:
				beq t2, s3, done_check_boxes_and_targets_and_character1
				lb t5, 0(t2)
				lb t6, 1(t2)
				bne t5, s6, next_set1
				bne t6, s5, next_set1
				la a0, box_symbol
				j got_filling
				next_set1:
				addi t2, t2, 2
				j loop_boxes_and_targets_and_character1

			done_check_boxes_and_targets_and_character1:
			
			la a0, target
			loop_boxes_and_targets_and_character11:
				beq a0, s4, done_check_boxes_and_targets_and_character11
				lb a1, 0(a0)
				lb a2, 1(a0)
				bne a1, s6, next_set11
				bne a2, s5, next_set11
				la a0, target_symbol
				j got_filling
				next_set11:
				addi a0, a0, 2
				j loop_boxes_and_targets_and_character11

			done_check_boxes_and_targets_and_character11:			
			
			la a0, board_comp4
			got_filling:
			ecall
			addi s6, s6, 1
			j for3
			
		exitFor3:
		la a0, board_comp6 # printing X
		ecall
		la a0, board_comp3 # printing \n
		ecall
		li s6, 0
		addi s5, s5, 1
		j for1
		
	for4:
		bge s6, s1, leave
		la a0, board_comp8
		ecall
		addi s6, s6, 1
		j for4
	
	leave:
	la a0, board_comp6
	ecall
	la a0, board_comp3
	ecall
	lw s6, 0(sp)
	addi sp, sp, 4
	lw s5, 0(sp)
	addi sp, sp, 4
	lw t6, 0(sp)
	addi sp, sp, 4
	lw t5, 0(sp)
	addi sp, sp, 4
	lw t4, 0(sp)
	addi sp, sp, 4
	lw t3, 0(sp)
	addi sp, sp, 4
	lw t2, 0(sp)
	addi sp, sp, 4
	lw t1, 0(sp)
	addi sp, sp, 4
	lw t0, 0(sp)
	addi sp, sp, 4
	lw a7, 0(sp)
	addi sp, sp, 4
	lw a6, 0(sp)
	addi sp, sp, 4
	lw a5, 0(sp)
	addi sp, sp, 4
	lw a4, 0(sp)
	addi sp, sp, 4
	lw a3, 0(sp)
	addi sp, sp, 4
	lw a2, 0(sp)
	addi sp, sp, 4
	lw a1, 0(sp)
	addi sp, sp, 4
	lw x1, 0(sp)
	addi sp, sp, 4	
	jalr x0, x1


enter_loop:
	li a7, 4
	la a0, prompt
	ecall
	li a7, 12 # read char
	ecall
	addi sp, sp, -4
	sw a0, 0(sp)
	li a7, 4
	la a0, board_comp3
	ecall
	lw a0, 0(sp)
	addi sp, sp, 4
	li a7, 12
	
	addi s0, s0, 1
	li a1, 'r'
	beq a1, a0, restart_entire_game
	li a1, 'w'
	beq a1, a0, w_move_label
	li a1, 's'
	beq a1, a0, s_move_label
	li a1, 'a'
	beq a1, a0, a_move_label
	li a1, 'd'
	beq a1, a0, d_move_label
	li a7, 4
	la a0, invalid
	ecall
	j done_move
	
	w_move_label:
	jal x1, w_move
	j done_move
	s_move_label:
	jal x1, s_move
	j done_move
	a_move_label:
	jal x1, a_move
	j done_move
	d_move_label:
	jal x1, d_move
	j done_move
		
	done_move:
	
	# WE NEED TO CHECK IF FOR EVERY TARGET, THERE IS A BOX PLACED ON IT, TO DETERMINE IF THE GAME HAS BEEN WON
	la t0, target
	la t1, box
	
	win_loop:
		beq t0, s4, winner
		lb a1, 0(t0)
		lb a2, 1(t0)
		check_box_loop:
			beq t1, s3, loser
			lb a3, 0(t1)
			lb a4, 1(t1)
			bne a1, a3, not_the_box
			bne a2, a4, not_the_box
			la t1, box
			j found_the_box
			not_the_box:
			addi t1, t1, 2
			j check_box_loop
		
		found_the_box:
		addi t0, t0, 2
		j win_loop
	
	
	winner:
	li a7, 4
	la a0, win
	ecall
	j end_round
	
	loser: # do nothing
	
	j enter_loop
	
	

w_move:
	addi sp, sp, -4
	sw x1, 0(sp)
	addi sp, sp, -4
	sw a1, 0(sp)
	addi sp, sp, -4
	sw a2, 0(sp)
	addi sp, sp, -4
	sw a3, 0(sp)
	addi sp, sp, -4
	sw a4, 0(sp)
	addi sp, sp, -4
	sw a5, 0(sp)
	addi sp, sp, -4
	sw a6, 0(sp)
	addi sp, sp, -4
	sw a7, 0(sp)
	addi sp, sp, -4
	sw t0, 0(sp)
	addi sp, sp, -4
	sw t1, 0(sp)
	addi sp, sp, -4
	sw t2, 0(sp)
	addi sp, sp, -4
	sw t3, 0(sp)
	addi sp, sp, -4
	sw t4, 0(sp)
	addi sp, sp, -4
	sw t5, 0(sp)
	addi sp, sp, -4
	sw t6, 0(sp)
	
	la a1, character
	lb a2, 1(a1) # y index of character
	lb a1, 0(a1) # x index of character
	
	beq a2, zero, no_move
	
	la t2, box
	loop_boxes_find_box_above:
		beq t2, s3, there_is_no_box_above
		lb t5, 0(t2) # x index of box
		lb t6, 1(t2) # y index of box
		addi t6, t6, 1
		
		bne t5, a1, next_box3 # 
		bne t6, a2, next_box3 # 
		j there_is_box_above

		next_box3:
		addi t2, t2, 2
		j loop_boxes_find_box_above
		
	there_is_box_above: # t2 is the current box above character
		lb t5, 0(t2)
		lb t6, 1(t2)
		
		beq t6, zero, no_move # if the box is agaist a wall
		addi t6, t6, -1
		
		#then we need to check if there is a box above that box
		
		la a7, box
		loop_boxes_find_box_above_box:
			beq a7, s3, there_is_no_box_above_box
			lb a3, 0(a7) # x index of box
			lb a4, 1(a7) # y index of box

			bne t5, a3, next_box_above_box # if x index of box does not equal x index 
			bne t6, a4, next_box_above_box # the y index of box does not equal y index of character
			j there_is_box_above_box

			next_box_above_box:
			addi a7, a7, 2
			j loop_boxes_find_box_above_box
			
		there_is_no_box_above_box:
			# then we can move the box up and the character up 1
			j box_move
			
		there_is_box_above_box:
			# then we do nothing
			j no_move	
		

	there_is_no_box_above:
		j no_move_box
		
	
	box_move:
		la a1, character
		lb a2, 1(a1) # y index of character
		addi a2, a2, -1
		sb a2, 1(a1)
		
		
		lb a2, 1(t2)
		addi a2, a2, -1
		sb a2, 1(t2)
		j done_w_move
		
	no_move_box:
		la a1, character
		lb a2, 1(a1) # y index of character
		addi a2, a2, -1
		sb a2, 1(a1)
		j done_w_move
	
	no_move:
		li a7, 4
		la a0, wall_up
		ecall
		j finish_w_move
	
	
	done_w_move:
		jal x1, construct_board
		
	finish_w_move:
		lw t6, 0(sp)
		addi sp, sp, 4
		lw t5, 0(sp)
		addi sp, sp, 4
		lw t4, 0(sp)
		addi sp, sp, 4
		lw t3, 0(sp)
		addi sp, sp, 4
		lw t2, 0(sp)
		addi sp, sp, 4
		lw t1, 0(sp)
		addi sp, sp, 4
		lw t0, 0(sp)
		addi sp, sp, 4
		lw a7, 0(sp)
		addi sp, sp, 4
		lw a6, 0(sp)
		addi sp, sp, 4
		lw a5, 0(sp)
		addi sp, sp, 4
		lw a4, 0(sp)
		addi sp, sp, 4
		lw a3, 0(sp)
		addi sp, sp, 4
		lw a2, 0(sp)
		addi sp, sp, 4
		lw a1, 0(sp)
		addi sp, sp, 4
		lw x1, 0(sp)
		addi sp, sp, 4
		
		jalr x0, x1
		
		
		
s_move:
	addi sp, sp, -4
	sw x1, 0(sp)
	addi sp, sp, -4
	sw a1, 0(sp)
	addi sp, sp, -4
	sw a2, 0(sp)
	addi sp, sp, -4
	sw a3, 0(sp)
	addi sp, sp, -4
	sw a4, 0(sp)
	addi sp, sp, -4
	sw a5, 0(sp)
	addi sp, sp, -4
	sw a6, 0(sp)
	addi sp, sp, -4
	sw a7, 0(sp)
	addi sp, sp, -4
	sw t0, 0(sp)
	addi sp, sp, -4
	sw t1, 0(sp)
	addi sp, sp, -4
	sw t2, 0(sp)
	addi sp, sp, -4
	sw t3, 0(sp)
	addi sp, sp, -4
	sw t4, 0(sp)
	addi sp, sp, -4
	sw t5, 0(sp)
	addi sp, sp, -4
	sw t6, 0(sp)
	
	la a1, character
	lb a2, 1(a1) # y index of character
	lb a1, 0(a1) # x index of character
	
	addi t3, s2, -1
	beq a2, t3, no_move2
	
	la t2, box
	loop_boxes_find_box_below:
		beq t2, s3, there_is_no_box_below
		lb t5, 0(t2) # x index of box
		lb t6, 1(t2) # y index of box
		addi t6, t6, -1
		
		bne t5, a1, next_box4
		bne t6, a2, next_box4
		j there_is_box_below

		next_box4:
		addi t2, t2, 2
		j loop_boxes_find_box_below
		
	there_is_box_below: # t2 is the current box below character
		lb t5, 0(t2)
		lb t6, 1(t2)
		
		beq t6, t3, no_move2 # if the box is agaist a wall
		addi t6, t6, 1
		
		#then we need to check if there is a box below that box
		
		la a7, box
		loop_boxes_find_box_below_box:
			beq a7, s3, there_is_no_box_below_box
			lb a3, 0(a7) # x index of box
			lb a4, 1(a7) # y index of box

			bne t5, a3, next_box_below_box # if x index of box does not equal x index 
			bne t6, a4, next_box_below_box # the y index of box does not equal y index of character
			j there_is_box_below_box

			next_box_below_box:
			addi a7, a7, 2
			j loop_boxes_find_box_below_box
			
		there_is_no_box_below_box:
			# then we can move the box down and the character down 1
			j box_move2
			
		there_is_box_below_box:
			# then we do nothing
			j no_move2	
		

	there_is_no_box_below:
		j no_move_box2
		
	
	box_move2:
		la a1, character
		lb a2, 1(a1) # y index of character
		addi a2, a2, 1
		sb a2, 1(a1)
		
		
		lb a2, 1(t2)
		addi a2, a2, 1
		sb a2, 1(t2)
		j done_w_move2
		
	no_move_box2:
		la a1, character
		lb a2, 1(a1) # y index of character
		addi a2, a2, 1
		sb a2, 1(a1)
		j done_w_move2
	
	no_move2:
		li a7, 4
		la a0, wall_down
		ecall
		j finish_w_move2
	
	
	done_w_move2:
		jal x1, construct_board
		
	finish_w_move2:
		lw t6, 0(sp)
		addi sp, sp, 4
		lw t5, 0(sp)
		addi sp, sp, 4
		lw t4, 0(sp)
		addi sp, sp, 4
		lw t3, 0(sp)
		addi sp, sp, 4
		lw t2, 0(sp)
		addi sp, sp, 4
		lw t1, 0(sp)
		addi sp, sp, 4
		lw t0, 0(sp)
		addi sp, sp, 4
		lw a7, 0(sp)
		addi sp, sp, 4
		lw a6, 0(sp)
		addi sp, sp, 4
		lw a5, 0(sp)
		addi sp, sp, 4
		lw a4, 0(sp)
		addi sp, sp, 4
		lw a3, 0(sp)
		addi sp, sp, 4
		lw a2, 0(sp)
		addi sp, sp, 4
		lw a1, 0(sp)
		addi sp, sp, 4
		lw x1, 0(sp)
		addi sp, sp, 4
		
		jalr x0, x1
		
	
a_move:
	addi sp, sp, -4
	sw x1, 0(sp)
	addi sp, sp, -4
	sw a1, 0(sp)
	addi sp, sp, -4
	sw a2, 0(sp)
	addi sp, sp, -4
	sw a3, 0(sp)
	addi sp, sp, -4
	sw a4, 0(sp)
	addi sp, sp, -4
	sw a5, 0(sp)
	addi sp, sp, -4
	sw a6, 0(sp)
	addi sp, sp, -4
	sw a7, 0(sp)
	addi sp, sp, -4
	sw t0, 0(sp)
	addi sp, sp, -4
	sw t1, 0(sp)
	addi sp, sp, -4
	sw t2, 0(sp)
	addi sp, sp, -4
	sw t3, 0(sp)
	addi sp, sp, -4
	sw t4, 0(sp)
	addi sp, sp, -4
	sw t5, 0(sp)
	addi sp, sp, -4
	sw t6, 0(sp)
	
	la a1, character
	lb a2, 1(a1) # y index of character
	lb a1, 0(a1) # x index of character
	
	addi t3, s1, -1
	beq a1, zero, no_move3
	
	la t2, box
	loop_boxes_find_box_left:
		beq t2, s3, there_is_no_box_left
		lb t5, 0(t2) # x index of box
		lb t6, 1(t2) # y index of box
		addi t5, t5, 1
		
		bne t5, a1, next_box5
		bne t6, a2, next_box5
		j there_is_box_left

		next_box5:
		addi t2, t2, 2
		j loop_boxes_find_box_left
		
	there_is_box_left: # t2 is the current box left character
		lb t5, 0(t2)
		lb t6, 1(t2)
		
		beq t5, zero, no_move3 # if the box is agaist a wall
		addi t5, t5, -1
		
		#then we need to check if there is a box left that box
		
		la a7, box
		loop_boxes_find_box_left_box:
			beq a7, s3, there_is_no_box_left_box
			lb a3, 0(a7) # x index of box
			lb a4, 1(a7) # y index of box

			bne t5, a3, next_box_left_box # if x index of box does not equal x index 
			bne t6, a4, next_box_left_box # the y index of box does not equal y index of character
			j there_is_box_left_box

			next_box_left_box:
			addi a7, a7, 2
			j loop_boxes_find_box_left_box
			
		there_is_no_box_left_box:
			# then we can move the box left and the character left 1
			j box_move3
			
		there_is_box_left_box:
			# then we do nothing
			j no_move3	
		

	there_is_no_box_left:
		j no_move_box3
		
	
	box_move3:
		la a1, character
		lb a2, 0(a1) # x index of character
		addi a2, a2, -1
		sb a2, 0(a1)
		
		
		lb a2, 0(t2)
		addi a2, a2, -1
		sb a2, 0(t2)
		j done_w_move3
		
	no_move_box3:
		la a1, character
		lb a2, 0(a1) # x index of character
		addi a2, a2, -1
		sb a2, 0(a1)
		j done_w_move3
	
	no_move3:
		li a7, 4
		la a0, wall_left
		ecall
		j finish_w_move3
	
	
	done_w_move3:
		jal x1, construct_board
		
	finish_w_move3:
		lw t6, 0(sp)
		addi sp, sp, 4
		lw t5, 0(sp)
		addi sp, sp, 4
		lw t4, 0(sp)
		addi sp, sp, 4
		lw t3, 0(sp)
		addi sp, sp, 4
		lw t2, 0(sp)
		addi sp, sp, 4
		lw t1, 0(sp)
		addi sp, sp, 4
		lw t0, 0(sp)
		addi sp, sp, 4
		lw a7, 0(sp)
		addi sp, sp, 4
		lw a6, 0(sp)
		addi sp, sp, 4
		lw a5, 0(sp)
		addi sp, sp, 4
		lw a4, 0(sp)
		addi sp, sp, 4
		lw a3, 0(sp)
		addi sp, sp, 4
		lw a2, 0(sp)
		addi sp, sp, 4
		lw a1, 0(sp)
		addi sp, sp, 4
		lw x1, 0(sp)
		addi sp, sp, 4
		
		jalr x0, x1
	
	
	
d_move:
	addi sp, sp, -4
	sw x1, 0(sp)
	addi sp, sp, -4
	sw a1, 0(sp)
	addi sp, sp, -4
	sw a2, 0(sp)
	addi sp, sp, -4
	sw a3, 0(sp)
	addi sp, sp, -4
	sw a4, 0(sp)
	addi sp, sp, -4
	sw a5, 0(sp)
	addi sp, sp, -4
	sw a6, 0(sp)
	addi sp, sp, -4
	sw a7, 0(sp)
	addi sp, sp, -4
	sw t0, 0(sp)
	addi sp, sp, -4
	sw t1, 0(sp)
	addi sp, sp, -4
	sw t2, 0(sp)
	addi sp, sp, -4
	sw t3, 0(sp)
	addi sp, sp, -4
	sw t4, 0(sp)
	addi sp, sp, -4
	sw t5, 0(sp)
	addi sp, sp, -4
	sw t6, 0(sp)
	
	la a1, character
	lb a2, 1(a1) # y index of character
	lb a1, 0(a1) # x index of character
	
	addi t3, s1, -1
	beq a1, t3, no_move4
	
	la t2, box
	loop_boxes_find_box_right:
		beq t2, s3, there_is_no_box_right
		lb t5, 0(t2) # x index of box
		lb t6, 1(t2) # y index of box
		addi t5, t5, -1
		
		bne t5, a1, next_box6
		bne t6, a2, next_box6
		j there_is_box_right

		next_box6:
		addi t2, t2, 2
		j loop_boxes_find_box_right
		
	there_is_box_right: # t2 is the current box right character
		lb t5, 0(t2)
		lb t6, 1(t2)
		
		beq t5, t3, no_move4 # if the box is agaist a wall
		addi t5, t5, 1
		
		#then we need to check if there is a box right that box
		
		la a7, box
		loop_boxes_find_box_right_box:
			beq a7, s3, there_is_no_box_right_box
			lb a3, 0(a7) # x index of box
			lb a4, 1(a7) # y index of box

			bne t5, a3, next_box_right_box # if x index of box does not equal x index 
			bne t6, a4, next_box_right_box # the y index of box does not equal y index of character
			j there_is_box_right_box

			next_box_right_box:
			addi a7, a7, 2
			j loop_boxes_find_box_right_box
			
		there_is_no_box_right_box:
			# then we can move the box right and the character right 1
			j box_move4
			
		there_is_box_right_box:
			# then we do nothing
			j no_move4	
		

	there_is_no_box_right:
		j no_move_box4
		
	
	box_move4:
		la a1, character
		lb a2, 0(a1) # x index of character
		addi a2, a2, 1
		sb a2, 0(a1)
		
		
		lb a2, 0(t2)
		addi a2, a2, 1
		sb a2, 0(t2)
		j done_w_move4
		
	no_move_box4:
		la a1, character
		lb a2, 0(a1) # x index of character
		addi a2, a2, 1
		sb a2, 0(a1)
		j done_w_move4
	
	no_move4:
		li a7, 4
		la a0, wall_right
		ecall
		j finish_w_move4
	
	
	done_w_move4:
		jal x1, construct_board
		
	finish_w_move4:
		lw t6, 0(sp)
		addi sp, sp, 4
		lw t5, 0(sp)
		addi sp, sp, 4
		lw t4, 0(sp)
		addi sp, sp, 4
		lw t3, 0(sp)
		addi sp, sp, 4
		lw t2, 0(sp)
		addi sp, sp, 4
		lw t1, 0(sp)
		addi sp, sp, 4
		lw t0, 0(sp)
		addi sp, sp, 4
		lw a7, 0(sp)
		addi sp, sp, 4
		lw a6, 0(sp)
		addi sp, sp, 4
		lw a5, 0(sp)
		addi sp, sp, 4
		lw a4, 0(sp)
		addi sp, sp, 4
		lw a3, 0(sp)
		addi sp, sp, 4
		lw a2, 0(sp)
		addi sp, sp, 4
		lw a1, 0(sp)
		addi sp, sp, 4
		lw x1, 0(sp)
		addi sp, sp, 4
		
		jalr x0, x1
	
exit:
    li a7, 10
    ecall
    
    
# --- HELPER FUNCTIONS ---
# Feel free to use, modify, or add to them however you see fit.
	
	
# The implementation of lcg_rand uses the Linear Congruential Generator (LCG) algorithm.
# Developed by John von Neumann and D.H. Lehmer.
# Reference: Linear Congruential Generator. Wikipedia. Last modified 26 September 2024. Accessed October 7 2024. 
#            Developed by W. E. Thomson and A. Rotenberg. https://en.wikipedia.org/wiki/Linear_congruential_generator.

# will return the random number in a0
lcg_rand:
	addi sp, sp, -4
	sw x1, 0(sp)
	addi sp, sp, -4
	sw a1, 0(sp)
	addi sp, sp, -4
	sw a2, 0(sp)
	addi sp, sp, -4
	sw a3, 0(sp)
	addi sp, sp, -4
	sw a4, 0(sp)
	addi sp, sp, -4
	sw a5, 0(sp)
	addi sp, sp, -4
	sw a6, 0(sp)
	addi sp, sp, -4
	sw a7, 0(sp)
	addi sp, sp, -4
	sw t0, 0(sp)
	addi sp, sp, -4
	sw t1, 0(sp)
	addi sp, sp, -4
	sw t2, 0(sp)
	addi sp, sp, -4
	sw t3, 0(sp)
	addi sp, sp, -4
	sw t4, 0(sp)
	addi sp, sp, -4
	sw t5, 0(sp)
	addi sp, sp, -4
	sw t6, 0(sp)


	la a0, modulus
	lw a0, 0(a0)

	la a1, ad
	lw a1, 0(a1)

	la a2, c
	lw a2, 0(a2)

	la a3, seed
	lw a3, 0(a3)

	# we need to multiply a and seed
	mul a5, a3, a1

	# now a5 holds a*seed
	add a5, a5, a2 # we add c to a times seed.

	# now we want the modulus of a5 and a0 (a5 % a0)
	div a6, a5, a0 
	mul a6, a6, a0
	sub a7, a5, a6
	# Now a7 contains a random number according to the LCG algorithm
	# now we need to update the value of seed
	la a0, seed
	sw a7, 0(a0)

	# so we need to make this number fit our range
	la a0, max
	lw a0, 0(a0)
	# We want a7 % a0
	div a6, a7, a0
	mul a6, a6, a0
	sub a0, a7, a6

	# we will absolute value the value of a0 as a safety percaution
	blt a0, zero, make_pos
		j d

	make_pos:
		neg a0, a0

	d:
	# now a0 contains the random number that we need.

	lw t6, 0(sp)
	addi sp, sp, 4
	lw t5, 0(sp)
	addi sp, sp, 4
	lw t4, 0(sp)
	addi sp, sp, 4
	lw t3, 0(sp)
	addi sp, sp, 4
	lw t2, 0(sp)
	addi sp, sp, 4
	lw t1, 0(sp)
	addi sp, sp, 4
	lw t0, 0(sp)
	addi sp, sp, 4
	lw a7, 0(sp)
	addi sp, sp, 4
	lw a6, 0(sp)
	addi sp, sp, 4
	lw a5, 0(sp)
	addi sp, sp, 4
	lw a4, 0(sp)
	addi sp, sp, 4
	lw a3, 0(sp)
	addi sp, sp, 4
	lw a2, 0(sp)
	addi sp, sp, 4
	lw a1, 0(sp)
	addi sp, sp, 4
	lw x1, 0(sp)
	addi sp, sp, 4
	
	jalr x0, x1

