; Using this file as a template, write a simple LLVM
; program that will print out the factorials of the
; numbers from 0 to 10.

define void @Xmain() {
  ; i = 0
  ; f = 1
  ; while (i<=10) {
  ;   print f
  ;   i = i + 1
  ;   f = f * i
  ; }

entry:
  br label %tst

tst:
  %i = phi i32 [0, %entry], [%ib, %body]
  %f = phi i32 [1, %entry], [%fb, %body]
  %cmp = icmp sle i32 %i, 10
  br i1 %cmp, label %body, label %done

body:
  call void @Xprint(i32 %f)
  %ib = add i32 %i, 1
  %fb = mul i32 %f, %ib
  br label %tst

done:
  ret void
}


; declare external runtime library functions
declare void @Xprint(i32)

; function definitions
define void @XinitGlobals() {
entry:
  ret void
}

