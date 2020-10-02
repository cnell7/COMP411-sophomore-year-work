.data

pattern: 	.space 17	# array of 16 (1 byte) characters (i.e. string) plus one additional character to store the null terminator when N=16

N_prompt:	.asciiz "Enter the number of bits (N): "
newline: 	.asciiz "\n"
n:		.word   0
.text

main:


#----------------------------------------------
#
# Convert the lab8 C-code to MIPS instructions
#
# Please remember to read the "program specification"
# section in the lab assignment PDF very carefully.
# It has all the information needed to complete this
# assignment :)
#
# TODO: Put your MIPS code here
#
#----------------------------------------------
  li $v0, 4	#print N prompt
  la $a0, N_prompt
  syscall
  
  la $t0, n	#get N address

  li $v0, 5	#get user input of N and store in N
  syscall
  sw $v0, 0($t0)
  
  li $t4, '\0'
  la $t3, pattern    #load pattern address
  lw $t2, n	     #load N
  sll $t2, $t2  2   #N + word offset
  add $t2, $t2, $t3 #pattern[N]
  sw $t4, 0($t2)    #pattern[N] = '\0'
  
  lw $a0, 0($t0)  #load arguments N and n for function call
  lw $a1, 0($t0)
  
  jal bingen	#call functions bingen

  j exit

bingen:
  addi $sp, $sp, -8 
  sw $ra, 4($sp) # Save $ra 
  sw $fp, 0($sp) # Save $fp 
  addi $fp, $sp, 4 # Set $fp 
  
  addi $sp, $sp, -8	#save arguments N and n
  sw $a0, -8($fp)
  sw $a1, -12($fp)
  
  slt $t1, $0, $a1	#if (0 < n) set to 1 and cont., else 0 and branch to else
  beq $t1, $0, else
  
  sub $t0, $a0, $a1	#N - n
  sll $t0, $t0, 2	#N - n word offset
  la $s0, pattern	#base address of pattern
  add $s0, $s0, $t0	#base address + [N - n] offset
  
  li $t2, '0'		#loading 0
  
  sw $t2, 0($s0)	#set pattern[N - n] = 0
  
  subi $a1, $a1, 1	#n = n - 1
  
  jal bingen
  
  lw $a0, -8($fp)
  lw $a1, -12($fp)	#load arguments
  
  sub $t0, $a0, $a1	#N - n
  sll $t0, $t0, 2	#N - n word offset
  la $s0, pattern	#base address of pattern
  add $s0, $s0, $t0	#base address + [N - n] offset
  
  li $t2, '1'		#loading 0
  
  sw $t2, 0($s0)	#set pattern[N - n] = 0
  
  subi $a1, $a1, 1	#n = n - 1
  
  jal bingen
  
  j endRtn
  
  
else:  
  li $s2, 0

print:
  la $s3, pattern	#load base address of pattern
  sll $t0, $s2, 2	#load counter offset
  add $t0, $t0, $s3	#pattern[counter]
  
  lw $t0, 0($t0)	#load pattern[counter]
  beq $t0, '\0', rtn
  
  li $v0, 11		#print pattern[counter]
  addi $a0, $t0, 0
  syscall
  
  addi $s2, $s2, 1
  j print
  
rtn:
  li $v0, 4	 #print newline
  la $a0, newline
  syscall

endRtn:  
  addi $sp, $fp, 4 # Restore 
  lw $ra, 0($fp) # Restore 
  lw $fp, -4($fp) # Restore 
  jr $ra # Return

exit:                     
  addi $v0, $0, 10      	# system call code 10 for exit
  syscall               	# exit the program
