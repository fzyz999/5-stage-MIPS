#转发测试文件
#作者能力不足之处，多多指教
#项塔兰作，如有问题，请致信qianlxc@126.com
lui $a0,0xffff
ori $a1,$0,0x0004
ori $a2,$0,0x3014
ori $s0,$0,0xaabb
lui $s1,0xccdd
ori $s2,156
jal fR_Jr_Rs
nop
jal fR_B_Rs
beqreturn1:nop
jal fR_R_Rs
nop
jal fR_I_Rs
nop
jal fR_L_Rs
nop
jal fR_MD_Rs #MD=mult div
nop
jal fR_MT_Rs
nop
jal fR_S_Rt
nop
jal fR_R_Rt
nop
jal fR_MD_Rt
nop
jal fI_B_Rs
beqreturn2:nop
jal fI_R_Rs
nop
jal fI_I_Rs
nop
jal fI_L_Rs
nop
jal fI_MD_Rs #MD=mult div
nop
jal fI_MT_Rs
nop
jal fI_S_Rt
nop
jal fI_R_Rt
nop
jal fI_MD_Rt
nop
jal fMF_B_Rs
beqreturn3:nop
jal fMF_R_Rs
nop
jal fMF_I_Rs
nop
jal fMF_L_Rs
nop
jal fMF_MD_Rs #MD=mult div
nop
jal fMF_MT_Rs
nop
jal fMF_S_Rt
nop
jal fMF_R_Rt
nop
jal fMF_MD_Rt
nop
jal fL_B_Rs
beqreturn4:nop
jal fL_R_Rs
nop
jal fL_I_Rs
nop
jal fL_L_Rs
nop
jal fL_MD_Rs #MD=mult div
nop
jal fL_MT_Rs
nop
jal fL_S_Rt
nop
jal fL_R_Rt
nop
jal fL_MD_Rt
nop
jal fMD_Stop
nop
jalr $t7
nop

fR_Jr_Rs: addu $a2,$a1,$a2
             addi $k0,$k0,1#用于检测addu与jr是否存在二级转发，若无，$k0将变为2，如果有，$k0为1
             jr $a2
             nop
fR_B_Rs: addu $t1,$a1,$0
             nop
             beq $a1,$t1,beqreturn1#用于检测R-R与beq是否存在二级转发，若无，则跳转失败，$k1将变为1
             nop
             addi $k1,$k1,1#k1代表R-R与beq的依赖
             jr $ra
             nop
fR_R_Rs: addu $t1,$a0,$0
             addu $t2,$t1,$a1 #1级转发
             sw $t2,0($0)
             addu $t3,$t2,$a1 #2级转发
             nop
             sw $t3,4($0)
             addu $t4,$t3,$a1 #3级转发
             sw $t4,8($0) #   若DM不是递4增加，则转发出错误
             jr $ra
             nop
fR_I_Rs:  addu $t1,$s1,$0 #t1为ccdd0000
             ori $t2,$t1,0xccdd #1级转发
             sw $t2,12($0)
             slti  $t3,$t2,30 #2级转发
             xori $t4,$t2,20 #3级转发
             sw $t3,16($0)  
             sw $t4,20($0)
             jr $ra
             nop
fR_L_Rs: sub $t1,$a1,$0 #t1为4
            lw $t2,8($t1)#1级转发
            lbu $t3,9($t1)#2级转发
            sw $t2,24($0)
            sw $t3,28($0)
            jr $ra
            nop
fR_MD_Rs: or  $t1,$s1,$0 #t1=0xccdd0000
                mult $t1,$a1  #测试乘法是否正确
                mfhi $t2
                mflo $t3
                sw $t2,32($0)
                sw $t3,36($0)
                jr $ra
                nop
fR_MT_Rs: slt  $t1,$s1,$0 #顺便测试slt是否正确 正确t1为1
                mthi $t1 #hi为1
                mfhi $t2 #t2为1
                sw $t2,40($0) #存入ＤＭ
                jr $ra
                nop
fR_S_Rt:     xor $t2,$s0,$a2
                sw $t2,40($a1) #这里只需要转发不需要暂停
                jr $ra
                nop
fR_R_Rt:    sllv  $t1,$s1,$a1 #顺便测试sllv
               xor $t2,$a1,$t1  
               sw $t2,48($0)
               srav $t3,$s1,$t2 #测试srav
               sw $t3,52($0)
               nop
               nor $t4,$a2,$t3
               sw $t4,56($0)
               jr $ra
               nop
fR_MD_Rt: sra $t1,$s1,3 #测sra
                div $s1,$t1
                mfhi $t2 #hi为结果
                mflo $t3 #lo为结果
                sw $t2,60($0)
                sw $t3,64($0)
                jr $ra
                nop

#   I-and others
fI_B_Rs:  slti $t1,$s1,0x0011
             nop
             beq $s1,$t1,beqreturn1#用于检测R-R与beq是否存在二级转发，若无，则跳转失败，$k1将变为1
             nop
             addi $k1,$k1,1#k1代表I与beq的依赖
             jr $ra
             nop
fI_R_Rs:  andi $0,$a2,100  #坑在0处 大家不要怪我
             nor $t2,$0,$a2  
             sw $t2,68($0)
             sub $t3,$0,$s1 #看看能不能识别负数
             sw $t3,72($0)
             nop
             addu $t4,$t3,$0
             sw $t4,76($0)
             jr $ra
             nop
fI_I_Rs:   addiu $t1,$s0,200
             addiu $t2,$t1,10  #1级转发
             sw $t2,80($0)
             addiu $t3,$t2,30  #2级转发
             sw $t3,84($0)
             nop             
             sltiu $t4,$a1,20  #3级转发
             sw $t4,88($0)
             jr $ra
             nop
fI_L_Rs: addiu $t1,$0,84
            lhu $t2,-6($t1)  #坑一下看有没有认真看指令集，lhu的地址也是符号扩展
            lbu $t3,1($t1)
            sw $t2,92($0)
            sw $t3,96($0)
            jr $ra
            nop
fI_MD_Rs: addiu $t1,$0,0xffff
                multu $t1,$s1 #看看multu对不对
                mfhi $t2
                mflo $t3
                sw $t2,100($0)
                sw $t3,104($0)
                jr $ra
                nop
fI_MT_Rs:  addiu $t1,$0,400 
                mthi $t1   
                mfhi $t2
                sb $t2,105($0) #看看你的sb是否加入0扩展了？（不应该加）
                sh $t2,106($0)
                jr $ra
                nop
fI_S_Rt:      ori $t1,$0,112 #又是这个问题 啧啧
                sh $s0,2($t1) #看看你是不是又出问题啦？sh存入112的应该是什么？
                jr $ra
                nop
fI_R_Rt:     xori  $t1,$0,100 #啧啧啧啧 这个指令看起来不错
               addu $t2,$0,$t1#1级转发
               sw $t2,116($0)
               addu $t3,$a2,$t2 #2级转发
               sw $t3,120($0)
               nop
               addu $t4,$t0,$t3
               sw $t4,124($0)
               jr $ra
               nop
fI_MD_Rt:  lui $t1,0xffff
                divu $a1,$s1  #看看你的除法指令延迟的周期正确吗？
                mfhi $t2
                mflo $t3
                sw $t2,128($0) #t2可是一个正数（除非你除法做错了）
                sw $t3,132($0)
                jr $ra
                nop
#MF and others
fMF_B_Rs:
             mthi $s1 
             mfhi $t2
             nop
             blez $t2,beqreturn3  #应该适当加入一些新的指令才有意思嘛，因为上一次t2是个正数，这次变成负数了，所以如果你没转发，就应该不跳转，导致k1又错咯
             nop
             addi $k1,$k1,1
             jr $ra
             nop
fMF_R_Rs: 
             mthi $s1
             mfhi $t2
             sub $t3,$t2,$a1 #一级转发
             or $t4,$t2,$a2   #二级转发
             sw $t3,136($0)
             sw $t4,140($0) #看起来
             jr $ra
             nop
fMF_I_Rs:  
             mthi $a0
             mfhi $t1
             addiu $t1,$t1,10#试试1级转发和2级转发同时存在你要怎么办？
             addiu $t2,$t1,20
             xori $t3,$t1,30
             sw $t1,144($0)
             sw $t2,148($0)
             sw $t3,152($0)
             jr $ra
             nop
fMF_L_Rs: 
            mthi $s2 #s2=156
            mfhi $t1
            lb $t8,1($t1)  #注意检查 t8 和t9
            lh $t9,6($t1)
            jr $ra
            nop
fMF_MD_Rs: 
                mthi $a2
                mfhi $t1
                mult $t1,$a1  #你的乘法是否做对了？ #看看这里要转发吗？
                div $t1,$a1    #再来条除法可好？       #2级转发加暂停哦，这可是2级转发和暂停哦亲
                mfhi $t2
                mflo $t3
                sw $t2,156($0)  
                sw $t3,160($0)
                jr $ra
                nop
fMF_MT_Rs: 
                mthi $s1
                mfhi $t2
                mtlo $t2  
                mflo $t3         #好像没什么太大的影响哦= =
                sw $t3,164($0)
                jr $ra
                nop
fMF_S_Rt:  mthi $s2    #s2=156
                mfhi $t1 
                sw $t3,12($t1)  #看看存了个啥？
                jr $ra
                nop
fMF_R_Rt:                 
             mthi $a1
             mfhi $t2
             addu $t3,$0,$t2
             addu $t4,$0,$t2
             sw $t2,172($0)
             sw $t3,176($0)
             sw $t4,180($0)
             jr $ra
             nop
fMF_MD_Rt:  
                mthi $a2
                mfhi $t1
                mult $a1,$t1
                mfhi $t2
                mflo $t3
                sw $t2,184($0)
                sw $t3,188($0)
                jr $ra
                nop
#Load and others
fL_B_Rs:
             lbu $t1,-22($s2) #从好远的地方取了个值来干啥？
             nop
             bgtz $t1,beqreturn4 #这里好像设计的不合理呢。。。我的t1不知是不是个负数
             nop 
             addi $k1,$k1,1
             jr $ra
             nop
fL_R_Rs:  lhu $t1,186($0) #我想想 起个什么名字好呢
             addu $t2,$t1,$s2 #1级转发 （这里可是要暂停的，不知道你做了没有）
             addu $t3,$t1,$a2 #2级转发
             sb $t1,192($0) #哎，又是没技术含量的这样存数
             sh $t2,196($0)
             sw $t3,200($0)
             nop
             jr $ra
             nop
fL_I_Rs:   lhu $t1,198($0) #哇哦看起来不错，不知道刚刚的t1是个啥。。
             addiu $t2,$t1,20 #1级转发
             sllv $t3,$t1,$a1 #2级转发
             sw $t2,204($0) #
             sw $t3,208($0)
             jr $ra
             nop
fL_L_Rs: ori $t1,$s0,4
            sw $t1,208($0)
            lw $t1,208($0)
            lb $s5,43($s2) #上面那些无聊的话都是乱说的，不要介意
            lhu $s6,-22($s2)
            jr $ra
            nop
fL_MD_Rs: lw $t1,208($0) #又是从208取数据。。。
                mult $t1,$0 #看看你的乘法管用不，这是个0乘哦
                mfhi $t2
                mflo $t3
                sw $t2,220($0) #这俩值应该是0吧
                sw $t3,224($0)
                jr $ra
                nop
fL_MT_Rs:  lb $t1,112($0) #试试符号扩展的
                mthi $t1
                mfhi $t2
                sw $t2,228($0) #怎么样做对了吗？
                jr $ra
                nop
fL_S_Rt: 
               ori $t1,$s0,180
               sw $t1,244($0) 
               lw $t2,244($0)
               sb $a2,116($s2) #156+116=252
                jr $ra
                nop
fL_R_Rt:    lw $t1,228($0)
             addu $t2,$0,$t1
             addu $t3,$0,$t1
             sw $t1,232($0)
             sw $t2,236($0)
             sw $t3,240($0)
             nop
             jr $ra
             nop
fL_MD_Rt:  lw $t1,208($0)
                mult $a1,$t1
                mfhi $t2
                mflo $t3
                sw $t2,244($0)
                sw $t3,248($0)
                jr $ra
                nop
#Mult Stop!!
fMD_Stop: mult $a1,$a2
                mfhi $s1
                mflo $s2
                div $a1,$a2
                mfhi $s3
                mflo $s4
                sw $s1,252($0)
                sw $s2,256($0)
                sw $s3,260($0)
                sw $s4,264($0)
                mthi $t2
                mtlo $t3
                jr $ra
                ori $t7,$0,0x3148 #意识到这个指令的测试点了吗？后面可是jalr- - 所以会进入一个死循环，看看你死循环的地址是不是3148和314c吧

































