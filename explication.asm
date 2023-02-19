extern printf
extern scanf

global main

section .data

valeur: db 10

section .bss

section .text
main:
push rbp

mov ax, 0
mov ax, response
call printf


fin:
pop rbp
; Pour fermer le programme proprement :
mov    rax, 60
mov    rdi, 0
syscall

ret