#ת�������ļ�
#������������֮�������ָ��
#�����������������⣬������qianlxc@126.com
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
             addi $k0,$k0,1#���ڼ��addu��jr�Ƿ���ڶ���ת�������ޣ�$k0����Ϊ2������У�$k0Ϊ1
             jr $a2
             nop
fR_B_Rs: addu $t1,$a1,$0
             nop
             beq $a1,$t1,beqreturn1#���ڼ��R-R��beq�Ƿ���ڶ���ת�������ޣ�����תʧ�ܣ�$k1����Ϊ1
             nop
             addi $k1,$k1,1#k1����R-R��beq������
             jr $ra
             nop
fR_R_Rs: addu $t1,$a0,$0
             addu $t2,$t1,$a1 #1��ת��
             sw $t2,0($0)
             addu $t3,$t2,$a1 #2��ת��
             nop
             sw $t3,4($0)
             addu $t4,$t3,$a1 #3��ת��
             sw $t4,8($0) #   ��DM���ǵ�4���ӣ���ת��������
             jr $ra
             nop
fR_I_Rs:  addu $t1,$s1,$0 #t1Ϊccdd0000
             ori $t2,$t1,0xccdd #1��ת��
             sw $t2,12($0)
             slti  $t3,$t2,30 #2��ת��
             xori $t4,$t2,20 #3��ת��
             sw $t3,16($0)  
             sw $t4,20($0)
             jr $ra
             nop
fR_L_Rs: sub $t1,$a1,$0 #t1Ϊ4
            lw $t2,8($t1)#1��ת��
            lbu $t3,9($t1)#2��ת��
            sw $t2,24($0)
            sw $t3,28($0)
            jr $ra
            nop
fR_MD_Rs: or  $t1,$s1,$0 #t1=0xccdd0000
                mult $t1,$a1  #���Գ˷��Ƿ���ȷ
                mfhi $t2
                mflo $t3
                sw $t2,32($0)
                sw $t3,36($0)
                jr $ra
                nop
fR_MT_Rs: slt  $t1,$s1,$0 #˳�����slt�Ƿ���ȷ ��ȷt1Ϊ1
                mthi $t1 #hiΪ1
                mfhi $t2 #t2Ϊ1
                sw $t2,40($0) #����ģ�
                jr $ra
                nop
fR_S_Rt:     xor $t2,$s0,$a2
                sw $t2,40($a1) #����ֻ��Ҫת������Ҫ��ͣ
                jr $ra
                nop
fR_R_Rt:    sllv  $t1,$s1,$a1 #˳�����sllv
               xor $t2,$a1,$t1  
               sw $t2,48($0)
               srav $t3,$s1,$t2 #����srav
               sw $t3,52($0)
               nop
               nor $t4,$a2,$t3
               sw $t4,56($0)
               jr $ra
               nop
fR_MD_Rt: sra $t1,$s1,3 #��sra
                div $s1,$t1
                mfhi $t2 #hiΪ���
                mflo $t3 #loΪ���
                sw $t2,60($0)
                sw $t3,64($0)
                jr $ra
                nop

#   I-and others
fI_B_Rs:  slti $t1,$s1,0x0011
             nop
             beq $s1,$t1,beqreturn1#���ڼ��R-R��beq�Ƿ���ڶ���ת�������ޣ�����תʧ�ܣ�$k1����Ϊ1
             nop
             addi $k1,$k1,1#k1����I��beq������
             jr $ra
             nop
fI_R_Rs:  andi $0,$a2,100  #����0�� ��Ҳ�Ҫ����
             nor $t2,$0,$a2  
             sw $t2,68($0)
             sub $t3,$0,$s1 #�����ܲ���ʶ����
             sw $t3,72($0)
             nop
             addu $t4,$t3,$0
             sw $t4,76($0)
             jr $ra
             nop
fI_I_Rs:   addiu $t1,$s0,200
             addiu $t2,$t1,10  #1��ת��
             sw $t2,80($0)
             addiu $t3,$t2,30  #2��ת��
             sw $t3,84($0)
             nop             
             sltiu $t4,$a1,20  #3��ת��
             sw $t4,88($0)
             jr $ra
             nop
fI_L_Rs: addiu $t1,$0,84
            lhu $t2,-6($t1)  #��һ�¿���û�����濴ָ���lhu�ĵ�ַҲ�Ƿ�����չ
            lbu $t3,1($t1)
            sw $t2,92($0)
            sw $t3,96($0)
            jr $ra
            nop
fI_MD_Rs: addiu $t1,$0,0xffff
                multu $t1,$s1 #����multu�Բ���
                mfhi $t2
                mflo $t3
                sw $t2,100($0)
                sw $t3,104($0)
                jr $ra
                nop
fI_MT_Rs:  addiu $t1,$0,400 
                mthi $t1   
                mfhi $t2
                sb $t2,105($0) #�������sb�Ƿ����0��չ�ˣ�����Ӧ�üӣ�
                sh $t2,106($0)
                jr $ra
                nop
fI_S_Rt:      ori $t1,$0,112 #����������� ����
                sh $s0,2($t1) #�������ǲ����ֳ���������sh����112��Ӧ����ʲô��
                jr $ra
                nop
fI_R_Rt:     xori  $t1,$0,100 #�������� ���ָ���������
               addu $t2,$0,$t1#1��ת��
               sw $t2,116($0)
               addu $t3,$a2,$t2 #2��ת��
               sw $t3,120($0)
               nop
               addu $t4,$t0,$t3
               sw $t4,124($0)
               jr $ra
               nop
fI_MD_Rt:  lui $t1,0xffff
                divu $a1,$s1  #������ĳ���ָ���ӳٵ�������ȷ��
                mfhi $t2
                mflo $t3
                sw $t2,128($0) #t2����һ����������������������ˣ�
                sw $t3,132($0)
                jr $ra
                nop
#MF and others
fMF_B_Rs:
             mthi $s1 
             mfhi $t2
             nop
             blez $t2,beqreturn3  #Ӧ���ʵ�����һЩ�µ�ָ�������˼���Ϊ��һ��t2�Ǹ���������α�ɸ����ˣ����������ûת������Ӧ�ò���ת������k1�ִ�
             nop
             addi $k1,$k1,1
             jr $ra
             nop
fMF_R_Rs: 
             mthi $s1
             mfhi $t2
             sub $t3,$t2,$a1 #һ��ת��
             or $t4,$t2,$a2   #����ת��
             sw $t3,136($0)
             sw $t4,140($0) #������
             jr $ra
             nop
fMF_I_Rs:  
             mthi $a0
             mfhi $t1
             addiu $t1,$t1,10#����1��ת����2��ת��ͬʱ������Ҫ��ô�죿
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
            lb $t8,1($t1)  #ע���� t8 ��t9
            lh $t9,6($t1)
            jr $ra
            nop
fMF_MD_Rs: 
                mthi $a2
                mfhi $t1
                mult $t1,$a1  #��ĳ˷��Ƿ������ˣ� #��������Ҫת����
                div $t1,$a1    #�����������ɺã�       #2��ת������ͣŶ�������2��ת������ͣŶ��
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
                mflo $t3         #����ûʲô̫���Ӱ��Ŷ= =
                sw $t3,164($0)
                jr $ra
                nop
fMF_S_Rt:  mthi $s2    #s2=156
                mfhi $t1 
                sw $t3,12($t1)  #�������˸�ɶ��
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
             lbu $t1,-22($s2) #�Ӻ�Զ�ĵط�ȡ�˸�ֵ����ɶ��
             nop
             bgtz $t1,beqreturn4 #���������ƵĲ������ء������ҵ�t1��֪�ǲ��Ǹ�����
             nop 
             addi $k1,$k1,1
             jr $ra
             nop
fL_R_Rs:  lhu $t1,186($0) #������ ���ʲô���ֺ���
             addu $t2,$t1,$s2 #1��ת�� ���������Ҫ��ͣ�ģ���֪��������û�У�
             addu $t3,$t1,$a2 #2��ת��
             sb $t1,192($0) #��������û������������������
             sh $t2,196($0)
             sw $t3,200($0)
             nop
             jr $ra
             nop
fL_I_Rs:   lhu $t1,198($0) #��Ŷ������������֪���ոյ�t1�Ǹ�ɶ����
             addiu $t2,$t1,20 #1��ת��
             sllv $t3,$t1,$a1 #2��ת��
             sw $t2,204($0) #
             sw $t3,208($0)
             jr $ra
             nop
fL_L_Rs: ori $t1,$s0,4
            sw $t1,208($0)
            lw $t1,208($0)
            lb $s5,43($s2) #������Щ���ĵĻ�������˵�ģ���Ҫ����
            lhu $s6,-22($s2)
            jr $ra
            nop
fL_MD_Rs: lw $t1,208($0) #���Ǵ�208ȡ���ݡ�����
                mult $t1,$0 #������ĳ˷����ò������Ǹ�0��Ŷ
                mfhi $t2
                mflo $t3
                sw $t2,220($0) #����ֵӦ����0��
                sw $t3,224($0)
                jr $ra
                nop
fL_MT_Rs:  lb $t1,112($0) #���Է�����չ��
                mthi $t1
                mfhi $t2
                sw $t2,228($0) #��ô����������
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
                ori $t7,$0,0x3148 #��ʶ�����ָ��Ĳ��Ե����𣿺������jalr- - ���Ի����һ����ѭ������������ѭ���ĵ�ַ�ǲ���3148��314c��

































