; declare external runtime library functions
declare void @Xprint(i32)

; function definitions
define void @XinitGlobals() {
entry:
  ret void
}

define void @Xmain() {
  ; h(1); h(2);
entry:
  call void @h(i32 1)
  call void @h(i32 2)
  ret void
}

define void @h(i32 %x) {
  ; g(x, x);
  call void @g(i32 %x, i32 %x)
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
