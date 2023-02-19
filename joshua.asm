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
mov byte[tour_triangle], 6
jumpe_triangle:
    call val
    mov [r8], eax
    add r8, 4
    dec byte[tour_triangle]
    cmp byte[tour_triangle], 0    
    jg jumpe_triangle
    
; Tracer les 3 traits
mov r8, tab_coord
mov eax, [r8]
mov edx, [r8+4]
mov rdi, response
mov esi, eax
mov edi, edx
call printf

add r8, 4
mov eax, [r8]
mov edx, [r8+4]
mov rdi, response
mov esi, eax
mov edi, edx
call printf

add r8, 4
mov eax, [r8]
mov edx, [tab_coord]
mov rdi, response
mov esi, eax
mov edi, edx
call printf

pop rbp

; Pour fermer le programme proprement :
mov    eax, 60
xor    edi, edi
syscall

ret