extern printf
extern scanf

global main

section .data

message: db "la valeur est de %d", 0

section .bss

section .text
main:
push rbp

mov eax, 10
push eax
push message
call printf
add esp, 8

message:
db "%d", 0


fin:
pop rbp
; Pour fermer le programme proprement :
mov    rax, 60
mov    rdi, 0
syscall

ret