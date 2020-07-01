; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -S -passes=attributor -aa-pipeline='basic-aa' -attributor-disable=false -attributor-max-iterations-verify -attributor-max-iterations=2 < %s | FileCheck %s

; CHECK-NOT: %X

define internal i32 @foo(i32 %X) {
  %Y = call i32 @foo( i32 %X )            ; <i32> [#uses=1]
  %Z = add i32 %Y, 1              ; <i32> [#uses=1]
  ret i32 %Z
}

define void @bar() {
; CHECK-LABEL: define {{[^@]+}}@bar()
; CHECK-NEXT:    unreachable
;
  call i32 @foo( i32 17 )         ; <i32>:1 [#uses=0]
  ret void
}
