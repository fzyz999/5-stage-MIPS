	li	$s2,1
	li	$s3,0
	li	$s4,0
	ori 	$t6, $0, 64513
	mtc0 	$t6, $12 # 开中断
	ori	$t0,$zero,50
	ori	$s0,0x00007f00   # timer1 base
	sw	$t0,4($s0)
	ori	$t0,$zero,9
	sw	$t0,0($s0)
	ori	$t1,$zero,10
	ori	$s1,0x00007f10   # timer2 base
	sw	$t1,4($s1)
	ori	$t0,$zero,11
	sw	$t0,0($s1)
	
POLL:	slti	$t0,$s3,10
	bne	$t0,$zero,POLL
	nop

END:	j 	END
	nop