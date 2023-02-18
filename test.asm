extern printf
extern scanf
extern srand


global main

section .data
    response: db    "La valeur est %d",10,0
    number: dd 400
    tour_triangle: db 6

section .bss
    tab_coord: resd 3  ; alloue suffisamment de mémoire pour 3 coordonnées
    
section .text
main:

    push rbp

    ; Initialiser le générateur de nombres aléatoires
    rdtsc ; Utiliser l'horodatage CPU comme graine
    mov ecx, eax
    mov eax, [rsp+4]
    xor eax, ecx
    mov ecx, eax
    xor eax, ecx
    mov eax, ecx
    call srand

    mov r8, tab_coord

    ; Générer les valeurs de tab_coord
    mov byte[tour_triangle], 3  ; met à jour le compteur à 3
    .jumpe_triangle:
        call val
        mov [r8], eax
        add r8, 4
        dec byte[tour_triangle]
        cmp byte[tour_triangle], 0    
        jg .jumpe_triangle

    ; Afficher les valeurs de tab_coord
    mov rdi, response
    mov esi, [tab_coord + 0 * 4]
    call printf

    mov rdi, response
    mov esi, [tab_coord + 1 * 4]
    call printf

    mov rdi, response
    mov esi, [tab_coord + 2 * 4]
    call printf

    pop rbp

    ; Pour fermer le programme proprement :
    mov    eax, 60
    xor    edi, edi
    syscall

    ret
