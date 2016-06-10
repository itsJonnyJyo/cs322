; An alternative way to reach SSA form by allocating
; stack frame locations in memory where the temporary
; variables can be stored.  A subsequent use of the
; LLVM mem2reg pass will transform this to look more
; like the ssa1.ll.

; declare external runtime library functions
declare void @Xprint(i32)

; function definitions
define void @XinitGlobals() {
entry:
  ret void
}

define void @Xmain() {
  ; int t=0;
  ; int i=0;
  ; while (i<10) {
  ;    t = t+i
  ;    i = i+1
  ; }
  ; print t

entry:
  %t.addr = alloca i32
  %i.addr = alloca i32
  store i32 0, i32* %t.addr
  store i32 0, i32* %i.addr
  br label %tst

tst:
  %i.tst = load i32* %i.addr
  %cmp = icmp slt i32 %i.tst, 10
  br i1 %cmp, label %body, label %done

body:
  %t.body = load i32* %t.addr
  %i.body = load i32* %i.addr
  %t.new  = add i32 %t.body, %i.body
  store i32 %t.new, i32* %t.addr
  %i.new  = add i32 1, %i.body
  store i32 %i.new, i32* %i.addr
  br label %tst

done:
  %t.done = load i32* %t.addr
  call void @Xprint(i32 %t.done)
  ret void
}

