
# 1. comments for instructions that I have added or changed are 
# preceded by "(CHANGE)"

# 2. RESULTS: the two numbers output by running this program are
# '50' and '26'. Running 'byvalue.s' produces 48 and 25. 
# The difference is that by passing addresses(references) of the 
# variables, the the 'callee' functions are able to modify the 
# the value in memory where the variable was initially stored.
# The output is as expected because the series of function calls
# results in both the x and y values being passed to 'increment()'
# to be incremented by 1. Before my modifications this change was
# constrained to the scope of the function which modified them. 
# We now see that the modification done by 'increment()' is persistent
# wherever the specified address is accessable. ie. adding x and y in
# 'byref()' and when printing 'x' in 'main()'.

# 3. Optimization Opportunities. Labeled in code via comments.

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
    #(CHANGE) I am using quadword registers for addresses
    #(CHANGE) compute address where the variable was pushed on stack
        leaq    -8(%rbp), %rdx
        movq    %rdx, %rdi
    #(CHANGE) repeat above steps for second variable to be passed to
    #'byref()'
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
    # OPPORTUNITY 2:
    # If 'redirect()' was gone, a sophisticated compiler could see
    # that increment was a leaf that did not change rsi or rdi. This 
    # could justify eliminating the unnecessary save & restore events needed to
    # preserve those registers within this 'caller' function.
	pushq	%rsi
	pushq	%rdi
    #(CHANGE) move 'x' to rdi to be passed to redirect
	movq	-16(%rbp), %rdi
	call	Xredirect
	popq	%rdi
	popq	%rsi
	pushq	%rsi
	pushq	%rdi
    #(CHANGE) move 'y' into rdi to be passed to redirect
	movq	-8(%rbp), %rdi
	call	Xredirect
	popq	%rdi
	popq	%rsi
    #(CHANGE) get current values of x&y from memory 
	movl	(%rdi), %eax
	movl	(%rsi), %ecx
    #return x+y
	addl	%ecx, %eax
	movq	%rbp, %rsp
	popq	%rbp
	ret

	.globl	Xredirect

    # OPPORTUNITY 1:
    # This function is a waste.
    # Its only purpose is to call another function, increment(),
    # which could have been called by byref() in the first place.
    # It would be nice if the compiler recognized this and generated
    # code without the useless function.
Xredirect:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rdi
    #(CHANGE) use quadword rdi instead of edi for address
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
    #(CHANGE) move memory contents of address specified by rdi
    #into eax
	movl	(%rdi), %eax
    # OPPORTUNITY 3:
    # The increment operation is not as efficient as it could be.
    # An 'incl' instruction could have been used instead of moving
    # values into multiple registers, addl-ing them, then moving the
    # result again
	movl	$1, %esi
	addl	%esi, %eax
    #(CHANGE) move eax into memory at rdi
	movl	%eax, (%rdi)
	movq	%rbp, %rsp
	popq	%rbp
	ret

