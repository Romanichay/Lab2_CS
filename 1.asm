.686
.model flat, stdcall
include \masm32\include\msvcrt.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\msvcrt.lib
includelib \masm32\lib\kernel32.lib

.data
X word 00F00Dh  ; Result = X * Y
Y word 00BABAh  ;

fmt  DB  "Result: %lu", 13, 10, 0

.code
_start:
mov AX, X ; Put X in EAX
mov BX, Y ; Put Y in ECX
shl EBX, 16 ; Move Y to be in proper place for the algorythm
xor EDX, EDX ; Zero EDX

mov ECX, 16

_mult:

xor ESI, ESI

test AX, 1 ; Check if bit of X is 1
jz mult_nop

add EDX, EBX ; If 1 add Y
jnc mult_nop
mov ESI, 80000000h

mult_nop:

shr EAX, 1
shr EDX, 1
or EDX, ESI

loop _mult

invoke crt_printf, addr fmt, EDX
invoke ExitProcess, 0

ret
end _start