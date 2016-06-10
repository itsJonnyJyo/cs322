; This is a simple LLVM source file that can be used
; to illustrate basic use of LLVM tools like llc.

define void @Xmain() {
  ; print 22 + 33

entry:
  %r1 = add i32 22, 33
  call void @Xprint(i32 %r1)
  ret void
}

; declare external runtime library functions
declare void @Xprint(i32)

; function definitions
define void @XinitGlobals() {
entry:
  ret void
}

