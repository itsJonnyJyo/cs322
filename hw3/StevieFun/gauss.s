	.file	"demo.s"

	.data
XN:
	.long	0

	.text
	.globl	XinitGlobals
XinitGlobals:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$16, %eax
	movl	%eax, XN(%rip)
	movq	%rbp, %rsp
	popq	%rbp
	ret

	.globl	Xmain
Xmain:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$0, %eax
	pushq	%rax
	movl	$1, %eax
	pushq	%rax
	movl	$0, %eax
	pushq	%rax
	jmp	l1
l0:
	movl	-8(%rbp), %edi
	call	Xprint
	movl	-8(%rbp), %eax
	movl	-16(%rbp), %edi
	addl	%edi, %eax
	pushq	%rax
	movl	-16(%rbp), %eax
	movl	%eax, -8(%rbp)
	movl	-32(%rbp), %eax
	movl	%eax, -16(%rbp)
	movl	-24(%rbp), %eax
	movl	$1, %edi
	addl	%edi, %eax
	movl	%eax, -24(%rbp)
	addq	$8, %rsp
l1:
	movl	XN(%rip), %eax
	movl	-24(%rbp), %edi
	cmpl	%eax, %edi
	jl	l0
	movl	XN(%rip), %edi
	call	Xdemo
	movq	%rbp, %rsp
	popq	%rbp
	ret

	.globl	Xdemo
Xdemo:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$0, %eax
	pushq	%rax
	jmp	l3
l2:
	pushq	%rdi
	movl	-8(%rbp), %edi
	call	Xrecfib
	movq	%rax, %rdi
	call	Xprint
	popq	%rdi
	movl	-8(%rbp), %eax
	movl	$1, %esi
	addl	%esi, %eax
	movl	%eax, -8(%rbp)
l3:
	movl	%edi, %eax
	movl	-8(%rbp), %esi
	cmpl	%eax, %esi
	jl	l2
	movq	%rbp, %rsp
	popq	%rbp
	ret

	.globl	Xrecfib
Xrecfib:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$2, %eax
	movl	%edi, %esi
	cmpl	%eax, %esi
	jnl	l4
	movl	%edi, %eax
	movq	%rbp, %rsp
	popq	%rbp
	ret
l4:
	pushq	%rdi
	movl	-8(%rbp), %edi
	movl	$1, %esi
	subl	%esi, %edi
	call	Xrecfib
	popq	%rdi
	pushq	%rax
	pushq	%rdi
	movl	-16(%rbp), %edi
	movl	$2, %esi
	subl	%esi, %edi
	call	Xrecfib
	movq	%rax, %rsi
	popq	%rdi
	popq	%rax
	addl	%esi, %eax
	movq	%rbp, %rsp
	popq	%rbp
	ret

