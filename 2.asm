.686
.model flat, stdcall
include \masm32\include\msvcrt.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\msvcrt.lib
includelib \masm32\lib\kernel32.lib


.data
X WORD 1337  ; Result = y/x
Y WORD 228   ;

fmt_rs  DB  "Result: %d", 13, 10, 0
fmt_rm  DB  "Remainder: %d", 13, 10, 0

.code
_start:

mov ECX, 16
movzx EAX, X ; Put X in EAX
mov DX, Y ; Put y in BD
shl EDX, 16 ; Shift EDX 16 to the left
xor EBX, EBX ; Zero EBX

_div:

shl EAX, 1 ; Shift EAX and EDX left
shl EBX, 1 ; 
cmp EAX, EDX
jb less

sub EAX, EDX ; sub if EAX > EDX
or EBX, 1 ; and set lsb of EDX

less:

loop _div

shr EAX, 16

push EAX

invoke crt_printf, addr fmt_rs, EBX

pop EAX

invoke crt_printf, addr fmt_rm, EAX

invoke ExitProcess, 0

ret

end _start