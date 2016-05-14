	.file	"demo.s"

	.data
Xnicks:
	.long	0
Xque:
	.long	0
Xthu:
	.long	0
Xx:
	.long	0

	.text
	.globl	XinitGlobals
XinitGlobals:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$10, %eax
	movl	%eax, Xnicks(%rip)
	movl	$73, %eax
	movl	$2, %edi
	imull	%edi, %eax
	movl	%eax, Xque(%rip)
	movl	$0, %eax
	movl	%eax, Xthu(%rip)
	movl	$0, %eax
	movl	%eax, Xx(%rip)
	movq	%rbp, %rsp
	popq	%rbp
	ret

	.globl	Xmain
Xmain:
	pushq	%rbp
	movq	%rsp, %rbp
	jmp	l1
l0:
	movl	Xque(%rip), %eax
	movl	$24601, %edi
	subl	%edi, %eax
	movl	%eax, Xque(%rip)
	movl	Xque(%rip), %edi
	call	Xprint
l1:
	movl	Xque(%rip), %eax
	movl	Xnicks(%rip), %edi
	cmpl	%eax, %edi
	jz	l0
	movl	Xnicks(%rip), %edi
	movl	$1, %esi
	addl	%esi, %edi
	movl	$23, %esi
	subl	%esi, %edi
	call	Xprint
	movl	$6, %edi
	movl	Xque(%rip), %esi
	imull	%esi, %edi
	movl	$4, %esi
	call	Xhorn
	movq	%rax, %rdi
	call	Xprint
	movq	%rbp, %rsp
	popq	%rbp
	ret

	.globl	Xmaze
Xmaze:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$3, %eax
	movl	%edi, %esi
	cmpl	%eax, %esi
	jnz	l2
	movl	Xnicks(%rip), %eax
	movl	%edi, %esi
	imull	%esi, %eax
	movq	%rbp, %rsp
	popq	%rbp
	ret
l2:
	pushq	%rdi
	movl	-8(%rbp), %edi
	movl	$12, %esi
	subl	%esi, %edi
	call	Xmaze
	popq	%rdi
	movq	%rbp, %rsp
	popq	%rbp
	ret

	.globl	Xdraw
Xdraw:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edx, %eax
	movl	%r8d, %r10d
	subl	%r10d, %eax
	movl	$5, %r10d
	addl	%r10d, %eax
	movl	%edi, %r10d
	addl	%r10d, %eax
	pushq	%rax
	movl	Xx(%rip), %eax
	orl	%eax, %eax
	jz	l3
	pushq	%r9
	pushq	%r8
	pushq	%rdx
	pushq	%rcx
	pushq	%rsi
	pushq	%rdi
	movl	$978457164, %edi
	call	Xprint
	popq	%rdi
	popq	%rsi
	popq	%rcx
	popq	%rdx
	popq	%r8
	popq	%r9
l3:
	movl	%esi, %eax
	movl	%esi, %r10d
	addl	%r10d, %eax
	movl	16(%rbp), %r10d
	addl	%r10d, %eax
	pushq	%rax
	movl	-8(%rbp), %eax
	movl	-16(%rbp), %r10d
	cmpl	%eax, %r10d
	je	l4
	movl	$0, %eax
	jmp	l5
l4:
	movl	$1, %eax
l5:
	movq	%rbp, %rsp
	popq	%rbp
	ret

	.globl	Xhorn
Xhorn:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	Xque(%rip), %eax
	movl	%esi, %ecx
	imull	%ecx, %eax
	pushq	%rax
	pushq	%rsi
	pushq	%rdi
	movl	$99, %edi
	movl	-8(%rbp), %esi
	imull	%esi, %edi
	call	Xmaze
	popq	%rdi
	popq	%rsi
	movq	%rbp, %rsp
	popq	%rbp
	ret

