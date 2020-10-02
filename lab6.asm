.data

A:			.space 	80  	# create integer array with 20 elements ( A[20] )
size_prompt:		.asciiz 	"Enter array size [between 1 and 20]: "
array_prompt:		.asciiz 	"A["
sorted_array_prompt:	.asciiz 	"Sorted A["
close_bracket: 		.asciiz 	"] = "
search_prompt:		.asciiz		"Enter search value: "
not_found:		.asciiz		" not in sorted A"
newline: 		.asciiz 	"\n" 	

.text

main:	
	# ----------------------------------------------------------------------------------
	# Do not modify
	#
	# MIPS code that performs the C-code below:
	#
	# 	int A[20];
	#	int size = 0;
	#	int v = 0;
	#
	#	printf("Enter array size [between 1 and 20]: " );
	#	scanf( "%d", &size );
	#
	#	for (int i=0; i<size; i++ ) {
	#
	#		printf( "A[%d] = ", i );
	#		scanf( "%d", &A[i]  );
	#
	#	}
	#
	#	printf( "Enter search value: " );
	#	scanf( "%d", &v  );
	#
	# ----------------------------------------------------------------------------------
	la $s0, A			# store address of array A in $s0
  
	add $s1, $0, $0			# create variable "size" ($s1) and set to 0
	add $s2, $0, $0			# create search variable "v" ($s2) and set to 0
	add $t0, $0, $0			# create variable "i" ($t0) and set to 0

	addi $v0, $0, 4  		# system call (4) to print string
	la $a0, size_prompt 		# put string memory address in register $a0
	syscall           		# print string
  
	addi $v0, $0, 5			# system call (5) to get integer from user and store in register $v0
	syscall				# get user input for variable "size"
	add $s1, $0, $v0		# copy to register $s1, b/c we'll reuse $v0
  
prompt_loop:
	# ----------------------------------------------------------------------------------
	slt $t1, $t0, $s1		# if( i < size ) $t1 = 1 (true), else $t1 = 0 (false)
	beq $t1, $0, end_prompt_loop
	sll $t2, $t0, 2			# multiply i * 4 (4-byte word offset)
				
  	addi $v0, $0, 4  		# print "A["
  	la $a0, array_prompt 			
  	syscall  
  	         			
  	addi $v0, $0, 1			# print	value of i (in base-10)
  	add $a0, $0, $t0			
  	syscall	
  					
  	addi $v0, $0, 4  		# print "] = "
  	la $a0, close_bracket		
  	syscall					
  	
  	addi $v0, $0, 5			# get input from user and store in $v0
  	syscall 			
	
	add $t3, $s0, $t2		# A[i] = address of A + ( i * 4 )
	sw $v0, 0($t3)			# A[i] = $v0 
	addi $t0, $t0, 1		# i = i + 1
		
	j prompt_loop			# jump to beginning of loop
	# ----------------------------------------------------------------------------------	
end_prompt_loop:
	addi $v0, $0, 4  		# print "Enter search value: "
  	la $a0, search_prompt			
  	syscall 
  	
  	addi $v0, $0, 5			# system call (5) to get integer from user and store in register $v0
	syscall				# get user input for variable "v"
	add $s2, $0, $v0		# copy to register $s2, b/c we'll reuse $v0

	# ----------------------------------------------------------------------------------
	# TODO:	PART 1
	#	Write the MIPS-code that performs the the C-code (bubble sort) shown below.
	#	You may only use the $s, $v, $a, $t registers (and of course the $0 register)
	#	The above code has already created array A and A[0] to A[size-1] have been 
	#	entered by the user. After the bubble sort has been completed, the values im
	#	A are sorted in increasing order, i.e. A[0] holds the smallest value and 
	#	A[size -1] holds the largest value.
	#	
	#	int t = 0;
	#	
	#	for ( int i=0; i<size-1; i++ ) {
	#		for ( int j=0; j<size-1-i; j++ ) {
 	#			if ( A[j] > A[j+1] ) {
	#				t = A[j+1];
	#				A[j+1] = A[j];
	#				A[j] = t;
	#			}
	#		}
	#	}
	#			
	# ----------------------------------------------------------------------------------
	
	li $t0, 0			# $t0 = i (set to 0)
	li $t2, 0			# $t2 = j (set to 0)
	
	subi $s3, $s1, 1		# $s3 = size - 1
					# $s4 = size - 1 - i
	
	li $t3, 0			# $t3 = array offset
	li $t4, 0			# $t4 = 0 (will be used to get address of A[j])
						
	li $s5, 0			# $s5 = 0 (will be used to store value of A[j])
	li $s6, 0			# $s6 = 0 (will be used to store value of A[j + 1])
	
bubble_outLoop:
	slt $t1, $t0, $s3		# if(i < size - 1), set $t1 = 1 else $t1 = 0
	beq $t1, $0, search		# if $t1 = 0 then jump to search part of problem
	
	sub $s4, $s3, $t0		# setting $s4 = size - 1 - i
	li $t2, 0 			# $t2 = 0 (j = 0)
	
	addi $t0, $t0, 1		# $t0 = $t0 + 1 (i +=1)
	
bubble_innerLoop:
	slt $t1, $t2, $s4		# if(j < size - 1 - i), set $t1 = 1 else $t1 = 0
	beq $t1, $0, bubble_outLoop	# if $t1 = 0 then jump back to outer loop
	
	sll $t3, $t2, 2
	add $t4, $s0, $t3		# address of A[j]
	
	addi $t2, $t2, 1		# $t2 = $t2 + 1 (j += 1)
	
	lw $s5, 0($t4)			# $s5 = A[j]
	lw $s6, 4($t4)			# $s6 = A[j + 1]
	
	slt $t1, $s6, $s5 		# if(A[j + 1] < A[j]), $t1 = 1 else $t1 = 0
	beq $t1, 0, bubble_innerLoop	# if $t1 = 0 then jump to top of inner loop
	
	sw $s5, 4($t4)			# A[j] = $s5
	sw $s6, 0($t4)			# A[j + 1] = $s4
	
	j bubble_innerLoop
		
	# ----------------------------------------------------------------------------------
	# TODO:	PART 2
	#	Write the MIPS-code that performs the C-code (binary earch) shown below.
	#	You may only use the $s, $v, $a, $t registers (and of course the $0 register)
	#	The array A has already been sorted by your code above int PART 1, where A[0] 
	#	holds the smallest value and A[size -1] holds the largest value, and v holds 
	# 	the search value entered by the user
	#	
	#	int left = 0;
	# 	int right = size - 1;
	#	int middle = 0;
	#	int element_index = -1;
 	#
	#	while ( left <= right ) { 
        #
        #		middle = left + (right - left) / 2; 
	#
        #		if ( array[middle] == v) {
        #    			element_index = middle;
        #    			break;
        #		}
        #
        #		if ( array[middle] < v ) 
        #    			left = middle + 1; 
        #		else
        #    			right = middle - 1; 
	#
    	#	} 
	#
    	#	if ( element_index < 0 ) 
    	#		printf( "%d not in sorted A\n", v );
    	#	else 
    	#		printf( "Sorted A[%d] = %d\n", element_index, v );
	#			
	# ----------------------------------------------------------------------------------
	
search:
	li $s3, 0		# $s3 = 0 (left = 0)
	subi $s4, $s1, 1	# $s4 = size - 1 (right = size - 1)
	li $s5, 0		# $s5 = 0 (middle = 0)
	li $s6, -1		# $s6 = -1 (element_index = -1)
	li $s7, 0 		# $s7 = 0 (will be used to get A[])
	
search_loop:
	slt $t1, $s4, $s3	# if(right < left), $t1 = 1 else $t1 = 0
	bne $t1, 0, search_cont	# branch to not_less if right > left ($t1 = 1)
 
	sub $t2, $s4, $s3	# $t2 = right - left
	div $t2, $t2, 2		# $t2 = $t2 / 2
	add $s5, $t2, $s3	# $s5 = left + $t2
	
	sll $t3, $s5, 2		# $t3 = middle + offset
	add $s7, $s0, $t3	# $s7 = Array[middle]
	lw $s7, 0($s7)		
	
	bne $s7, $s2, if_two	# if(A[middle !== V) branch to if_two
	
	add $s6, $0, $s5	# element_index = middle
	j search_cont

if_two:
	slt $t1, $s5, $s2	# if(A[middle] < v) 
	beq $t1, 0, if_two_else	# branch to else, if ^ is not true
	
	add $s3, $s5, 1		# left = middle + 1
	j search_loop
	
if_two_else:
	sub $s4, $s5, 1		# right = middle - 1
	j search_loop
	
search_cont:
	slt $t1, $s6, $0
	beq $t1, 0, print_element
	
	addi $v0, $0, 1		#print "v"	
  	add $a0, $0, $s2			
  	syscall	
  	
  	addi $v0, $0, 4  	# print " not in sorted A"
  	la $a0, not_found 			
  	syscall 
  	
  	addi $v0, $0, 4		# print "\n"
  	la $a0, newline
  	syscall
  	j exit
	
print_element:  
	addi $v0, $0, 4			# print "Sorted A["
	la $a0, sorted_array_prompt
	syscall
	
	addi $v0, $0, 1			# print element_index
	add $a0, $0, $s6
	syscall
	
	addi $v0, $0, 4			# print close_bracket
	la $a0, close_bracket
	syscall
	
	addi $v0, $0, 1			# print v
	add $a0, $0, $s2
	syscall
	
	addi $v0, $0, 4			# print "\n"
  	la $a0, newline
  	syscall
	j exit
	
print:
	li $t0, 0			# prints the sorted array (used to check bubble sort)

print_loop:	
	slt $t1, $t0, $s1
	beq $t1, 0, exit
	sll $t2, $t0, 2
	
	add $t2, $t2, $s0
	lw $t2, 0($t2)
	
	addi $v0, $0, 1			
  	add $a0, $0, $t2			
  	syscall	
  	
  	addi $t0, $t0, 1
  	j print_loop
  	
# ----------------------------------------------------------------------------------
# Do not modify the exit
# ----------------------------------------------------------------------------------
exit:                     
  addi $v0, $0, 10      		# system call (10) exits the progra
  syscall               		# exit the program
  
