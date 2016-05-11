	.file	"demo.s"

	.data

	.text
	.globl	XinitGlobals
XinitGlobals:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rbp, %rsp
	popq	%rbp
	ret

	.globl	Xmain
Xmain:
	pushq	%rbp
	movq	%rsp, %rbp
	call	Xf
	movq	%rax, %rdi
	call	Xprint
	movq	%rbp, %rsp
	popq	%rbp
	ret

	.globl	Xf
Xf:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$0, %eax
	pushq	%rax
	movl	$0, %eax
	pushq	%rax
	jmp	l1
l0:
	movl	-16(%rbp), %eax
	movl	-8(%rbp), %edi
	addl	%edi, %eax
	movl	%eax, -16(%rbp)
	movl	-8(%rbp), %eax
	movl	$1, %edi
	addl	%edi, %eax
	movl	%eax, -8(%rbp)
l1:
	movl	$11, %eax
	movl	-8(%rbp), %edi
	cmpl	%eax, %edi
	jl	l0
	movl	-16(%rbp), %edi
	call	Xprint
	movl	-8(%rbp), %eax
	movq	%rbp, %rsp
	popq	%rbp
	ret

