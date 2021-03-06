.data
.align 2
	size:	.word 7
	fib:	.word 0:10
	stack:	.word 0:500
.text
	la	$s6,fib
	la	$s0,stack
	lui	$s0,0
	ori	$s0,2000
	la	$a0,size
	lw	$a0,0($a0)
	la	$s3,size	
	lw	$s3,0($s3)	# while(i)
LOOP:	beq	$s3,$zero,END	# {
	nop
	
	
	jal	FIB		#     FIB(i)
	addu	$a0,$zero,$s3	#     a0=i
	
	sw	$v0,0($s6)	#     store FIB(i) in array
	addi	$s6,$s6,4
	li	$t0,1
	
	j	LOOP		# }
	subu	$s3,$s3,$t0	#     i--
	
END:	j	END		# endless loop
	nop

FIB:	beq	$a0,$zero,TRUE	# if(n==0 || n==1) goto TRUE;
	nop
	
	li	$t0,1
	beq	$a0,$t0,TRUE
	nop
	
FALSE:	addi	$s0,$s0,-12	# using $s0 to simulate $sp
	sw	$ra,0($s0)	# store ra
	sw	$a0,4($s0)	# store n
	sw	$s1,8($s0)	# store $s1
	addi	$t1,$zero,1
	
	
	jal	FIB		# fib(n-1)
	subu	$a0,$a0,$t1	
	
	addu	$s1,$zero,$v0	# s1=v0
	lw	$t0,4($s0)
	addi	$t1,$zero,2
	
	jal	FIB		# fib(n-2)
	subu	$a0,$t0,$t1
	
	addu	$s1,$s1,$v0	# s1+=v0
	addu	$v0,$zero,$s1
	lw	$ra,0($s0)
	lw	$s1,8($s0)
	
	jr	$ra		# return s1;
	addi	$s0,$s0,12
	
TRUE:	
	jr	$ra		#return 1;
	addi	$v0,$zero,1
