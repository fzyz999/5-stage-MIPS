	mfc0	$t0,$13
	sll	$s2,$s2,1
	addi	$s3,$s3,1
	sw	$t0,0($s4)
	addi	$s4,$s4,4
	sw	$s2,0($s4)
	addi	$s4,$s4,4
	sw	$s3,0($s4)
	addi	$s4,$s4,4
	ori	$t0,$zero,30
	ori	$s0,0x00007f00   # timer1 base
	sw	$t0,4($s0)
	eret