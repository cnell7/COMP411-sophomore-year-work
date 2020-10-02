.data
         .asciiz    "$t3 = "
.text

main:
  
  li $a1, 20
  jal fib
  
  li $v0, 1
  addi $a0, $v1, 0
  syscall   
  
  j exit
##################
fib:
  addi $sp, $sp, -8	#create new frame
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addi $fp, $sp, 4
  
  addi $sp, $sp, -4
  sw $a1, -8($fp)

if:
  bne $a1, 0, elseIf
  li $v1, 0
  
  j rtn
  
elseIf:  
  bne $a1, 1, else
  li $v1, 1
  
  j rtn
  
else:
  addi $a1, $a1, -1	#call fib(n-1)
  jal fib
  
  addi $sp, $sp, -4	#save ^ result 
  sw $v1, -12($fp)
  
  lw $a1, -8($fp)	#call fib(n-2)
  addi $a1, $a1, -2
  jal fib
  
  lw $s0, -12($fp)
  add $v1, $s0, $v1
  
  j rtn
  
rtn:
  addi $sp, $fp, 4
  lw $ra, 0($fp)
  lw $fp, -4($fp)
  jr $ra
  
##################
exit:
  addi $v0, $0, 10
  syscall
