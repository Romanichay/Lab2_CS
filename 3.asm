.686
.model flat, stdcall
include \masm32\include\msvcrt.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\msvcrt.lib
includelib \masm32\lib\kernel32.lib

.data
X dword 43640000h ; Result = X * Y
Y dword 44a72000h ; 

fmt  DB  "Result: %lx", 13, 10, 0

.code
_start:

; Initialize all required registers
mov EAX, X   ; First float
mov EDX, Y   ; Second float
mov EBX, EAX ; Copy of X for calculations
mov ESI, EDX ; Copy of Y for calculations
mov EDI, EDX ; Copy of Y for calculations

; Calculate sign
xor EDI, EBX
and EDI, 80000000h

; Add Exponents
    ; Remove signs
shl EBX, 1 
shl ESI, 1
    ; Cut exponents
shr EBX, 24        ; Get exponent of X
shr ESI, 24        ; Get exponent of Y
    ; Addition
add ESI, EBX      ; Add exponents together
sub ESI, 127       ; Substract static shift

; Multiply Mantisas
and EAX , 7FFFFFh ; Get X Mantissa
or EAX, 800000h   ;

and EDX , 7FFFFFh ; Get Y Mantissa
or EDX, 800000h   ;

mul EDX ; Multiply
shld EDX, EAX, 9 ; Move result to proper place

; Normalize Exponents
test EDX, 1000000h ; Check if we have to normalize
jz normalize_end
shr EDX, 1 ; Move result to proper place
inc ESI ; And normalize Exponent

normalize_end:

and EDX, 007FFFFFh ; Cut 1

; Finishing up Exponent addition
and ESI, 000000FFh ; Remove overflows if occured
shl ESI, 23        ; Move exponent back to its proper place

or EDX, EDI ; Set Sign
or EDX, ESI ; Set Exponent

invoke crt_printf, addr fmt, EDX
invoke ExitProcess, 0

ret
end _start