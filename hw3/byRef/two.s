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
	movl	$25, %eax
	pushq	%rax
	leaq	-8(%rbp), %rdx
        movq    %rdx, %rdi
	call	Xbyref
	movq	%rax, %rdi
	call	Xprint
	movl	-8(%rbp), %edi
	call	Xprint
	movq	%rbp, %rsp
	popq	%rbp
	ret

	.globl	Xbyref
Xbyref:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rdi
	movq	-8(%rbp), %rdi
	call	Xredirect
	popq	%rdi
	movl	(%rdi), %eax
	movq	%rbp, %rsp
	popq	%rbp
	ret

	.globl	Xredirect
Xredirect:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rdi
	movq	-8(%rbp), %rdi
	call	Xincrement
	popq	%rdi
	movq	%rbp, %rsp
	popq	%rbp
	ret

	.globl	Xincrement
Xincrement:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	(%rdi), %eax
	movl	$1, %esi
	addl	%esi, %eax
	movl	%eax, (%rdi)
	movq	%rbp, %rsp
	popq	%rbp
	ret

