; declare external runtime library functions
declare void @Xprint(i32)
declare i8*  @XallocArray(i32, i32)

; declare global variables

; function definitions
define void @XinitGlobals() {
entry:
  ret void
}

define void @Xmain() {
entry:
  %t0 = call i32 @Xbelow(i32 3, i32 4, i32 5)
  call void @Xprint(i32 %t0)
  ret void
}

 ; this is crazy and convoluted. Unnecessary branches.
 ; L1 is not needed if we branch to L6 or L0  on %t3 in L0.
 ; L3 is ridiculous and pointless.
 ; L6 should branch to L4 or L5 on %t6
 ; the current possible paths of execution hurt my brain.

define i32 @Xbelow(i32 %x.param, i32 %y.param, i32 %z.param) {
entry:
  %z = alloca i32
  %y = alloca i32
  %x = alloca i32
  store i32 %x.param, i32* %x
  store i32 %y.param, i32* %y
  store i32 %z.param, i32* %z
  br label %L0
L6:
  %t4 = load i32* %x
  %t5 = load i32* %z
  %t6 = icmp slt i32 %t4, %t5
  br label %L3
L5:
  %t0 = load i32* %x
  ret i32 %t0
L4:
  %t8 = load i32* %x
  %t9 = add i32 %t8, 1
  store i32 %t9, i32* %x
  br label %L0

 ;a label that just goes to a label????
L3:
  br label %L2
L2:
  %t7 = phi i1 [ %t3, %L1 ], [ %t6, %L3 ]
  br i1 %t7, label %L4, label %L5

 ;L1 is not really necessary
L1:
  br i1 %t3, label %L6, label %L2
L0:
  %t1 = load i32* %x
  %t2 = load i32* %y
  %t3 = icmp slt i32 %t1, %t2
 ;goes to new label just to check the result of the cmp
  br label %L1
}

