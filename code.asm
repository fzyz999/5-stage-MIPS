.data
.align 2
	size:	.word 7
	fib:	.word 0:40
	fib2:	.word 0:40
	stack:	.word 0:500
.text
main:
	nop
	jal	T1
	la	$s6,fib
	jal	T2
	nop
	j	NORMAL
	nop
T2:	la	$s0,stack
	addu	$t0,$zero,$ra
	jr	$t0
	nop
		
NORMAL:	la	$a0,size
	lw	$a0,0($a0)
	j	NORMAL2
	nop
	
T1:	jr $ra
	la	$s7,fib2
	
NORMAL2:	ori	$t4,$zero,1
	lui	$t0,0	#base=0
	ori	$t1,$t0,1	#s1=1 
	addu	$t2,$t1,$zero	#f0=1,f1=1
	addu	$t3,$zero,$t1
	la	$s3,size
	lw	$s3,0($s3)
	LOOP:	beq	$s3,$zero,END	# {
	addi	$t4,$t4,1
	addu	$t2,$t3,$t2
	sw	$t2,0($s7)
	
	jal	FIB		#     FIB(i)
	addu	$a0,$zero,$s3	#     a0=i
	
	sw	$v0,0($s6)	#     store FIB(i) in array
	addi	$s6,$s6,4
	li	$t0,1
	subu	$s3,$s3,$t0	#     i--	
	j	LOOP		# }
	addi	$s7,$s7,4
END:	j	END		# endless loop	
	nop

FIB:	beq	$a0,$zero,TRUE	# if(n==0 || n==1) goto TRUE;
	nop
	li	$t0,1
	beq	$a0,$t0,TRUE
	nop
FALSE:	addi	$s0,$s0,-12	# using $s0 to simulate $sp
	addi	$t1,$zero,1
	sw	$ra,0($s0)	# store ra
	sw	$a0,4($s0)	# store n
	sw	$s1,8($s0)	# store $s1
	
	jal	FIB		# fib(n-1)
	subu	$a0,$a0,$t1	
	
	lw	$t0,4($s0)
	addi	$t1,$zero,2
	addu	$s1,$zero,$v0	# s1=v0
	
	jal	FIB		# fib(n-2)
	subu	$a0,$t0,$t1
	
	addu	$s1,$s1,$v0	# s1+=v0
	addu	$v0,$zero,$s1
	lw	$ra,0($s0)
	lw	$s1,8($s0)
	
	jr	$ra		# return s1;
	addi	$s0,$s0,12
TRUE:	
	addi	$v0,$zero,1
	jr	$ra		#return 1;
	nop
	
