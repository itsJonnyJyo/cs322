; This is a simple LLVM source file that can be used
; to illustrate the effects of constant folding.

define void @Xmain() {
  ; print 1+(2+(3+(4+(5+6))))

entre:
  %r1 = add i32 5, 6
  %r2 = add i32 4, %r1
  %r3 = add i32 3, %r2
  %r4 = add i32 2, %r3
  %r5 = add i32 1, %r4
  call void @Xprint(i32 %r5)
  ret void
}

; declare external runtime library functions
declare void @Xprint(i32)

; function definitions
define void @XinitGlobals() {
entry:
  ret void
}

