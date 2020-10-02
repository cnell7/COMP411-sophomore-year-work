.data
  AA:     .space 400  		# int AA[100]
  BB:     .space 400  		# int BB[100]
  CC:     .space 400  		# int CC[100]
  m:      .word	 0   		# m is an int whose value is at most 10
  mm:     .word  0		# m * m
  size:   .asciiz		"m = "
  AAPrompt: .asciiz		"AA["
  BBPrompt: .asciiz		"BB["
  CCPrompt: .asciiz		"CC["
  equal:    .asciiz		"] = "
  newL:	  .asciiz		"\n"
.text

main:


#----------------------------------------------
#
# Convert the lab7 C-code to MIPS instructions
#
# Please remember to read the "program specification"
# section in the lab assignment PDF very carefully.
# It has all the information needed to complete this
# assignment :)
#
# TODO: Put your MIPS code here
#
#----------------------------------------------
  
  addi $v0, $0, 4	#print "m = "
  la $a0, size
  syscall

  addi $v0, $0, 5	#get input from user and store in $s0
  syscall
  add $s0, $0, $v0
  
  mult $s0, $s0		#square m 
  mflo $s1		#store m*m in $s1
  
  la $t0, m		#load address of m
  la $t1, mm		#load address of mm
  
  sw $s0, 0($t0)	#save m into memory of m
  sw $s1, 0($t1)	#save m*m into memory of mm
  
  jal run		#call run function
  j exit		#call exit function when done
  
run:
  addi $sp, $sp, -8	#create new stack frame 
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addi $fp, $sp, 4
  
  li $t2, 0		#i = 0
  la $s0, mm
  lw $s0, 0($s0)	#load mm into $s0
  la $s1, AA		#load AA base address into $s1
  la $s2, BB		#load BB base address into $s2
  
################################################
runLoop:  
  slt $t1, $t2, $s0	#if(i < m*m) set to 1 and cont, else 0 and branch to endRun
  beq $t1, 0, endRun
  sll $t3, $t2, 2	#i offset
  
  addi $v0, $0, 4	#print "AA["
  la $a0, AAPrompt
  syscall
  
  addi $v0, $0, 1	#print i
  add $a0, $0, $t2
  syscall
  
  addi $v0, $0, 4	#print ] = 
  la $a0, equal
  syscall
  
  add $t4, $t3, $s1	#address of AA[i]
  
  addi $v0, $0, 5	#store input in AA[i]
  syscall
  sw $v0, 0($t4)
  
  addi $v0, $0, 4	#print "BB["
  la $a0, BBPrompt
  syscall
  
  addi $v0, $0, 1	#print i
  add $a0, $0, $t2
  syscall
  
  addi $v0, $0, 4	#print "] = "
  la $a0, equal
  syscall
  
  add $t5, $t3, $s2	#address of BB[i]
  
  addi $v0, $0, 5	#store input in BB[i]
  syscall
  sw $v0, 0($t5)	

  addi $t2, $t2, 1	#i++
  j runLoop
  
endRun:
  jal matrixmult	#call matrixmult function
  
  addi $sp, $fp, 4	#restore stack frame
  lw $ra, 0($fp)
  lw $fp, -4($fp)
  jr $ra

################################################
matrixmult:
  addi $sp, $sp, -8	#create new stack frame 
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addi $fp, $sp, 4
  
  li $t0, 0		#s = 0
  li $t2, 0		#i = 0
  li $t3, 0		#j = 0
  li $t4, 0		#k = 0
  la $t5, m
  lw $t5, 0($t5)	#$t5 = m
  
matrixOuter:
  slt $t1, $t2, $t5	#if(i<m) set to 1 and cont, else 0 and branch to end of procedure
  beq $t1, 0, doneLoop
  
  li $t3, 0		#reset j counter
  
matrixMiddle: 
  slt $t1, $t3, $t5	#if(j<m) set to 1 and cont, else 0 and branch to end of middle loop
  beq $t1, 0, doneMiddle
  
  li $t0, 0		#s = 0
  li $t4, 0		#rest k counter
  
matrixInner:
  slt $t1, $t4, $t5	#if(k<m) set to 1 and cont, else 0 and branch to end of inner loop
  beq $t1, 0, doneInner
  
  mult $t2, $t5		#i * m
  mflo $t6		#load i * m
  add $t6, $t6, $t4	#(i * m) + k
  
  mult $t4, $t5		#k * m
  mflo $t7		#load k * m
  add $t7, $t7, $t3	#(k * m) + j
  
  sll $t6, $t6, 2	#index offsets
  sll $t7, $t7, 2

  la $s0, AA		#load base address of AA
  add $s0, $s0, $t6	#add [i * m + k] offset to AA
  la $s1, BB		#load base address of BB
  add $s1, $s1, $t7	#add [k * m + j] offset to BB
  
  lw $s0, 0($s0)
  lw $s1, 0($s1)	#load both AA's and BB's values into $s0 and $s1 respective
  
  mult $s0, $s1		#AA[i * m + k] * BB[k * m + j]
  mflo $s3		#load result into $s3
  
  add $t0, $t0, $s3	#s += AA[i * m + k] * BB[k * m + j]
  
  addi $t4, $t4, 1	#k += 1
  j matrixInner

doneInner: 
  mult $t2, $t5		#i * m
  mflo $t6		#load i * m
  add $t6, $t6, $t3	#(i * m) + j
  sll $t6, $t6, 2	#offset
  
  la $t7, CC		#load CC base address
  add $t7, $t7, $t6	#add CC(i * m + j] offset
  sw $t0, 0($t7)	#save s into CC[i * m + j]
  
  addi $t3, $t3, 1	#j += 1
  j matrixMiddle
  
doneMiddle:
  addi $t2, $t2, 1	#i += 1
  j matrixOuter

doneLoop:
  jal printC		#call printC function
  
  addi $sp, $fp, 4	#restore stack frame
  lw $ra, 0($fp)
  lw $fp, -4($fp)
  jr $ra

################################################
printC:
  addi $sp, $sp, -8	#create new stack frame 
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addi $fp, $sp, 4
  
  li $t2, 0		#i = 0
  la $t3, CC		#load CC base address
  la $s0, mm		
  lw $s0, 0($s0)	#load mm into $s0

printLoop:  
  slt $t1, $t2, $s0	#if(i < m*m) set to 1 and cont, else 0 and branch to exit
  beq $t1, 0, donePrint
  sll $t4, $t2, 2	#i offset to CC base
  
  addi $v0, $0, 4	#print "CC["
  la $a0, CCPrompt
  syscall
  
  addi $v0, $0, 1	#print i 
  add $a0, $0, $t2
  syscall
  
  addi $v0, $0, 4	#print "] = "
  la $a0, equal 
  syscall
  
  add $t4, $t3, $t4	#add i offset to CC base address
  lw $t4, 0($t4)	#load CC[i]
  
  addi $v0, $0, 1	#print CC[i]
  add $a0, $0, $t4
  syscall
  
  addi $v0, $0, 4	#print "\n"
  la $a0, newL
  syscall
  
  addi $t2, $t2, 1	#i++
  j printLoop

donePrint:
  addi $sp, $fp, 4	#restore stack frame
  lw $ra, 0($fp)
  lw $fp, -4($fp)
  jr $ra

################################################
exit:                      
  addi $v0, $0, 10      	# system call code 10 for exit
  syscall               	# exit the program
