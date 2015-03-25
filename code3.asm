TEXT:       .text
	    addi $sp,$zero,8188
	    addi $t9,$t9,0
	    nop
            j    MAIN
            addi $t9,$t9,1

					#int strlen(char str[]){
STRLEN:	    xor  $t0,$t0,$t0    	#    int count=0;
    	    add  $t1,$a0,$zero		#    char *p=str;
WHILE1:	    lb   $t2,0($t1)		#    while(*p!='\0') 
	    addi $t3,$zero,0		#
    	    beq  $t2,$t3,BREAK1		#    {
            nop
            addi $t0,$t0,1		#        count++;
            addi $t1,$t1,1		#        p++;
            beq  $zero,$zero,WHILE1  	#    }
            nop
BREAK1:	    add  $v0,$t0,$zero		#    return count;
	    jr   $ra			#}
            addi $t9,$t9,1

					
REVERSE:    addi $sp,$sp,-8		#void reverse(char str[])
	    sw	 $a0,0($sp)		#{
	    sw   $ra,4($sp)		#
	    jal	 STRLEN			#
            addi $t9,$t9,1
	    lw	 $t0,0($sp)		#    char *l=str;
	    add	 $t1,$t0,$v0		#    char *r=str+strlen(str)-1;
	    addi $t1,$t1,-1		#
WHILE2:     slt	 $t2,$t0,$t1		#    while(l<r)
    	    beq	 $t2,$zero,BREAK2	#    {
            addi $t9,$t9,1
            lb	 $t3,0($t0)		#        char tmp=*l;
            lb   $t4,0($t1)		#        *l=*r;
            sb   $t4,0($t0)		#        *r=tmp;
            sb   $t3,0($t1)		#
            addi $t0,$t0,1		#        l++;
            addi $t1,$t1,-1		#        r--;
    	    beq  $zero,$zero,WHILE2     #    }
            addi $t9,$t9,1
BREAK2:	    lw   $ra,4($sp)             #    
            addi $sp,$sp,8              #    return;
            jr   $ra                    #}
            addi $t9,$t9,1

MAIN:	    jal  REVERSE		#
	    la   $a0,NUM1		#    reverse(num1);
	    
	    jal  REVERSE		#
	    la   $a0,NUM2		#    reverse(num2);
	    
    	    jal  STRLEN			#
    	    la   $a0,NUM1		#    int l1=_strlen(num1),
    	    
    	    
    	    add  $s0,$v0,$zero		#
    	    
    	    jal  STRLEN			#
    	    la   $a0,NUM2		#        l2=_strlen(num2);
    	    
    	    add  $s1,$v0,$zero		#
    	    la   $s5,NUM1		#
    	    la   $s6,NUM2		#
    	    la   $s7,ANS		#
	    xor  $s3,$s3,$s3		#    int flag=0;
	    slt  $t1,$s0,$s1		#    int i,l=l1<l2?l1:l2;
	    beq  $t1,$zero,FALSE	#
            addi $t9,$t9,1
	    add  $s2,$zero,$s0		#
	    beq  $zero,$zero,E		#
            addi $t9,$t9,1
FALSE:	    add  $s2,$zero,$s1		#
E:	    xor  $t0,$t0,$t0		#    for (i = 0; 
FOR:	    slt  $t1,$t0,$s2		#         i < l; 
	    beq  $t1,$zero,END_FOR	#         i++) {
            addi $t9,$t9,1
	    add  $t2,$s3,-96		#        ans[i]=flag+num1[i]-'0'+num2[i]-'0';
	    add  $t3,$t0,$s5		#
	    lb   $t3,0($t3)		#
	    add  $t2,$t2,$t3		#
	    add  $t3,$t0,$s6		#
	    lb   $t3,0($t3)		#
	    add  $t2,$t2,$t3		#
	    sll  $t3,$t0,2		#
	    add  $t3,$t3,$s7		#
	    sw   $t2,0($t3)		#
	    addi $t7,$zero,10           #
	    div  $t2,$t7		#        flag=ans[i]/10;
	    mflo $s3			#
	    mfhi $t7			#        ans[i]%=10;
	    sw   $t7,0($t3)		#
	    addi $t0,$t0,1		#
    	    beq  $zero,$zero,FOR	#    }
            addi $t9,$t9,1
END_FOR:    
WHILE3:     slt  $t1,$t0,$s0		#    while (i < l1) {
	    beq  $t1,$zero,BREAK3	#
            addi $t9,$t9,1
	    add  $t3,$s5,$t0		#
	    lb   $t3,0($t3)		#
	    add  $t2,$s3,$t3		#        ans[i]=flag+num1[i]-'0';
	    addi $t2,$t2,-48		#
	    sll  $t3,$t0,2		#
	    add  $t3,$t3,$s7		#
	    sw   $t2,0($t3)		#
            addi $t7,$zero,10           #
	    div  $t2,$t7		#        flag=ans[i]/10;
	    mflo $s3			#
	    mfhi $t7			#        ans[i]%=10;
	    sw   $t7,0($t3)		#
	    addi $t0,$t0,1		#        i++;
    	    beq  $zero,$zero,WHILE3	#    }
            addi $t9,$t9,1
BREAK3:
WHILE4:	    slt  $t1,$t0,$s1		#    while (i < l2) {
	    beq  $t1,$zero,BREAK4	#
            addi $t9,$t9,1
	    add  $t3,$s6,$t0		#
	    lb   $t3,0($t3)		#
	    add  $t2,$s3,$t3		#        ans[i]=flag+num2[i]-'0';
	    addi $t2,$t2,-48		#
	    sll  $t3,$t0,2		#
	    add  $t3,$t3,$s7		#
	    sw   $t2,0($t3)		#
            addi $t7,$zero,10           #
	    div  $t2,$t7		#        flag=ans[i]/10;
	    mflo $s3			#
	    mfhi $t7			#        ans[i]%=10;
	    sw   $t7,0($t3)		#
	    addi $t0,$t0,1		#        i++;
    	    beq  $zero,$zero,WHILE4	#    }
            addi $t9,$t9,1
BREAK4:     beq  $s3,$zero,FALSE2	#    if(flag){
            addi $t9,$t9,1
	    sll  $t3,$t0,2		#
	    add  $t3,$t3,$s7		#        ans[i++]=1;
	    addi $t7,$zero,1		#
	    sw   $t7,0($t3)		#
	    addi $t0,$t0,1		#   
FALSE2:     la   $t8,T9
	    sw   $t9,0($t8)

END: 	    j END
	    nop

.data
.align 0
NUM1:   .asciiz "112393247567876545678765434567876545678433222222"
NUM2:	.asciiz "10987653112345678900987654321234567890098765434565434321123456"
.align 2
T9:	.word 0
ANS:    .word 0:100
