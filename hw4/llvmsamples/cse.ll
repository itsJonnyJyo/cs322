; declare external runtime library functions
declare void @Xprint(i32)

; function definitions
define void @XinitGlobals() {
entry:
  ret void
}

define void @Xmain() {
  ; g(1, 1);
entry:
  call void @g(i32 1, i32 1)
  ret void
}

define void @g(i32 %x, i32 %y) {
  ; print f(x+y) + f(x+y);
entry:
  %t1 = add i32 %x, %y
  %r1 = call i32 @f(i32 %t1)
  %t2 = add i32 %x, %y
  %r2 = call i32 @f(i32 %t2)
  %sum = add i32 %r1, %r2
  call void @Xprint(i32 %sum)
  ret void
}

define i32 @f(i32 %z) {
entry:
  ; return z * z;
  %square = mul i32 %z, %z
  ret i32 %square
}
