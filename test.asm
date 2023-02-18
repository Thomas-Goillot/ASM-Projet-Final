extern printf
extern scanf


global main

section .data
    response: db    "Le valeur est %d",10,0
    number: db 400
    tour_triangle: db 6

section .bss
    tab_coord: resd 6
    
section .text



global val
val:
    push rbp

value:
    mov ax, 0
    rdrand ax
    cmp ax, 400
    jge value

modulo:
    mov bx, di
    mov dx, 0
    div bx
    mov ax, dx


pop rbp
ret


main:

push rbp


mov rsi, 0
mov rdi, response
mov si, ax
mov rax, 0
call printf


mov r8d, tab_coord

mov rdi, 0
mov rdi, [number]


jumpe_triangle:
    call val
    mov word[r8d], ax
    add r8d, 4
    dec byte[tour_triangle]
    cmp byte[tour_triangle], 0    
    jg jumpe_triangle
    


mov rdi, response
mov rsi , [tab_coord + 0 * 4]
mov rax, 0
call printf

mov rdi, response
mov rsi , [tab_coord + 1 * 4]
mov rax, 0
call printf

mov rdi, response
mov rsi , [tab_coord + 2 * 4]
mov rax, 0
call printf

mov rdi, response
mov rsi , [tab_coord + 3 * 4]
mov rax, 0
call printf

mov rdi, response
mov rsi , [tab_coord + 4 * 4]
mov rax, 0
call printf

mov rdi, response
mov rsi , [tab_coord + 5 * 4]
mov rax, 0
call printf




fin:
pop rbp
; Pour fermer le programme proprement :
mov    rax, 60
mov    rdi, 0
syscall

ret
