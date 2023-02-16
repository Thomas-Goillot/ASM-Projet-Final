extern printf
extern scanf


global main


section .data
    response: db    "Le valeur est %d",10,0
    number: db 400

section .bss

section .text




global val
val:
    push rbp

value:
    mov ax, 0
    rdrand ax
    jnc value

modulo:
    mov bx, di
    mov dx, 0
    div bx
    mov ax, dx

pop rbp
ret


main:

push rbp

mov rdi, 0
mov rdi, [number]
call val


mov rsi, 0
mov rdi, response
mov si, ax
mov rax, 0
call printf


fin:
pop rbp
; Pour fermer le programme proprement :
mov    rax, 60
mov    rdi, 0
syscall

ret
