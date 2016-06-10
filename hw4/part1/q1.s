	.file	"q1.ll"
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
	movl	%esi, -4(%rsp)          # 4-byte Spill
	movl	%edx, -8(%rsp)          # 4-byte Spill
	movl	%edi, -12(%rsp)         # 4-byte Spill
	jmp	.LBB2_1
.LBB2_1:                                # %tst
                                        # =>This Inner Loop Header: Depth=1
	movl	-12(%rsp), %eax         # 4-byte Reload
	movl	-4(%rsp), %ecx          # 4-byte Reload
	cmpl	%ecx, %eax
	movl	%eax, -16(%rsp)         # 4-byte Spill
	jge	.LBB2_4
# BB#2:                                 # %tst2
                                        #   in Loop: Header=BB2_1 Depth=1
	movl	-16(%rsp), %eax         # 4-byte Reload
	movl	-8(%rsp), %ecx          # 4-byte Reload
	cmpl	%ecx, %eax
	jge	.LBB2_4
# BB#3:                                 # %body
                                        #   in Loop: Header=BB2_1 Depth=1
	movl	-16(%rsp), %eax         # 4-byte Reload
	addl	$1, %eax
	movl	%eax, -12(%rsp)         # 4-byte Spill
	jmp	.LBB2_1
.LBB2_4:                                # %done
	movl	-16(%rsp), %eax         # 4-byte Reload
	ret
.Ltmp4:
	.size	Xbelow, .Ltmp4-Xbelow
	.cfi_endproc


	.section	".note.GNU-stack","",@progbits
