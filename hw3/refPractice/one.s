	.file	"one.s"

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
	movl	$5, %eax
	pushq	%rax
	leaq	-8(%rbp), %rdx
        movq    %rdx, %rdi
	call	Xincriment
	movl	-8(%rbp), %edi
	call	Xprint
	movq	%rbp, %rsp
	popq	%rbp
	ret

	.globl	Xincriment
Xincriment:
	pushq	%rbp
	movq	%rsp, %rbp
        pushq   %rdi
        movq    -8(%rbp), %rax
        movl    (%rax), %eax
	movl	$1, %ecx
	addl	%ecx, %eax
	movl	%eax, %edx
        popq    %rax
        movl    %edx, (%rax)
	movq	%rbp, %rsp
	popq	%rbp
	ret

