
;declare external runtime library functions
declare void @Xprint(i32)

; function definitions
define void @XinitGlobals() {
entry:
  ret void
}

define void @Xmain() {
  ; print below(3, 4, 5);
  entry:
    %blw = call i32 @Xbelow(i32 3, i32 4, i32 5)
    call void @Xprint(i32 %blw)
    ret void
}

define i32 @Xbelow(i32 %xe, i32 %y, i32 %z) {
  entry:
    
    br label %tst
    
  tst:
    %x = phi i32 [ %xe, %entry ], [ %xb, %body ]
    %cmp = icmp slt i32 %x, %y
    br i1 %cmp, label %tst2, label %done

  tst2:
    %comp1 = icmp slt i32 %x, %z
    br i1 %comp1, label %body, label %done

  body:
    %xb = add i32 %x, 1
    br label %tst

  done:
    ret i32 %x

}
