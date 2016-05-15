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
    #create variable == 25
	movl	$25, %eax
    #give variable a place in memory
	pushq	%rax
    #compute address in memory of said variable
        leaq    -8(%rbp), %rdx
    #put said address in 'rdi' to be passed into 'byref()'
        movq    %rdx, %rdi
    #repeat above steps for second variable to be passed to 'byref()'
        movl    $23, %eax
        pushq   %rax
        leaq    -16(%rbp), %rdx
        movq    %rdx, %rsi
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
    #save arguments on stack for protection, we want to maintain
    #the correct address's for x & y
	pushq	%rsi
	pushq	%rdi
    #move 'x' to rdi to be passed to redirect
	movq	-16(%rbp), %rdi
	call	Xredirect
    #restore rdi&rsi then save them on the stack again
	popq	%rdi
	popq	%rsi
	pushq	%rsi
	pushq	%rdi
    #move 'y' into rdi to be passed to redirect
	movq	-8(%rbp), %rdi
	call	Xredirect
    #restore rdi&rsi
	popq	%rdi
	popq	%rsi
    #get current values of x&y from memory 
	movl	(%rdi), %eax
	movl	(%rsi), %ecx
    #return x+y
	addl	%ecx, %eax
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

