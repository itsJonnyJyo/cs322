; Using this file as a template, write a simple LLVM
; program that will print out the factorials of the
; numbers from 0 to 10.

define void @Xmain() {
  ; you could sketch out your algorithm here
  ; in pseudo code if you find it helpful to
  ; do so ...

entry:
  ; ... and then begin the llvm code proper
  ; right here ...

  ; ... until, eventually, you're done and are
  ; ready to return!
  ret void
}


; declare external runtime library functions
declare void @Xprint(i32)

; function definitions
define void @XinitGlobals() {
entry:
  ret void
}

