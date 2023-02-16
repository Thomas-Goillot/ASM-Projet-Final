section .data
    random_number dq 0

section .text
    global main

main:
    ; Appel de la fonction 'rdrand' qui genere un nombre aleatoire et le place dans la variable random_number
    mov rax, 0x1
    rdrand rax,

    ; arret du programme
    mov rax,
    xor rdi, rdi
    syscall
