	.file	"demo.ll"
	.text
	.globl	XinitGlobals
	.align	16, 0x90
	.type	XinitGlobals,@function
XinitGlobals:                           # @XinitGlobals
	.cfi_startproc
# BB#0:                                 # %entry
	ret
.Ltmp0:
	.size	XinitGlobals, .Ltmp0-XinitGlobals
	.cfi_endproc

	.globl	Xmain
	.align	16, 0x90
	.type	Xmain,@function
Xmain:                                  # @Xmain
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rax
.Ltmp2:
	.cfi_def_cfa_offset 16
	movl	$3, %edi
	movl	$4, %esi
	movl	$5, %edx
	callq	Xbelow
	movl	%eax, %edi
	callq	Xprint
	popq	%rax
	ret
.Ltmp3:
	.size	Xmain, .Ltmp3-Xmain
	.cfi_endproc

	.globl	Xbelow
	.align	16, 0x90
	.type	Xbelow,@function
Xbelow:                                 # @Xbelow
	.cfi_startproc
# BB#0:                                 # %entry
	movl	%edi, -12(%rsp)
	movl	%esi, -8(%rsp)
	movl	%edx, -4(%rsp)
	jmp	.LBB2_7
.LBB2_1:                                # %L6
                                        #   in Loop: Header=BB2_7 Depth=1
	movl	-12(%rsp), %eax
	cmpl	-4(%rsp), %eax
	setl	%cl
	movb	%cl, -13(%rsp)          # 1-byte Spill
	jmp	.LBB2_4
.LBB2_2:                                # %L5
	movl	-12(%rsp), %eax
	ret
.LBB2_3:                                # %L4
                                        #   in Loop: Header=BB2_7 Depth=1
	movl	-12(%rsp), %eax
	addl	$1, %eax
	movl	%eax, -12(%rsp)
	jmp	.LBB2_7
.LBB2_4:                                # %L3
                                        #   in Loop: Header=BB2_7 Depth=1
	movb	-13(%rsp), %al          # 1-byte Reload
	movb	%al, -14(%rsp)          # 1-byte Spill
	jmp	.LBB2_5
.LBB2_5:                                # %L2
                                        #   in Loop: Header=BB2_7 Depth=1
	movb	-14(%rsp), %al          # 1-byte Reload
	testb	$1, %al
	jne	.LBB2_3
	jmp	.LBB2_2
.LBB2_6:                                # %L1
                                        #   in Loop: Header=BB2_7 Depth=1
	movb	-15(%rsp), %al          # 1-byte Reload
	testb	$1, %al
	movb	%al, -14(%rsp)          # 1-byte Spill
	jne	.LBB2_1
	jmp	.LBB2_5
.LBB2_7:                                # %L0
                                        # =>This Inner Loop Header: Depth=1
	movl	-12(%rsp), %eax
	cmpl	-8(%rsp), %eax
	setl	%cl
	movb	%cl, -15(%rsp)          # 1-byte Spill
	jmp	.LBB2_6
.Ltmp4:
	.size	Xbelow, .Ltmp4-Xbelow
	.cfi_endproc


	.section	".note.GNU-stack","",@progbits
