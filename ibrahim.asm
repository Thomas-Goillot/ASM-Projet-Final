extern printf
extern scanf
extern srand
extern xdraw

global main

section .data
response: db "La valeur est %d",10,0
number: dd 400
tour_triangle: db 6
triangle: dd 0, 0, 0, 0, 0, 0

section .bss
tab_coord: resd 6

section .text

; Fonction pour générer un nombre aléatoire entre 0 et 399
global val
val:
push rbp
mov rbp, rsp

; Générer un nombre aléatoire avec la fonction RDRAND
mov ecx, 10 ; Limite le nombre de tentatives à 10
.loop:
    xor eax, eax
    rdrand eax
    jc .success
    loop .loop
    mov eax, [number] ; Si la génération aléatoire a échoué, prendre la valeur 400


.success:
; S'assurer que la valeur générée est entre 0 et 399
xor edx, edx
div dword [number]
mov eax, edx

pop rbp
ret

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
mov byte[tour_triangle], 6
.jumpe_triangle:
    call val
    mov [r8], eax
    add r8, 4
    dec byte[tour_triangle]
    cmp byte[tour_triangle], 0    
    jg .jumpe_triangle

; Mettre les valeurs dans le tableau triangle pour la fonction xdraw
mov r8, tab_coord
mov r9, triangle
mov eax, [r8]
mov [r9], eax
add r8, 4
add r9, 4
mov eax, [r8]
mov [r9], eax
add r8, 4
add r9, 4
mov eax, [r8]
mov [r9], eax
add r8, 4
add r9, 4
mov eax, [r8]
mov [r9], eax
add r8, 4
add r9, 4
mov eax, [r8]
mov [r9], eax
add r8, 4
add r9, 4
mov eax, [r8]
mov [r9], eax

; Appeler la fonction xdraw pour tracer le triangle
mov rdi, triangle
call xdraw

; Afficher les valeurs de tab_coord
mov rdi, response
mov esi, [tab_coord + 0 * 4]
call printf

mov rdi, response
mov esi, [tab_coord + 1 * 4]
call printf

mov rdi, response
mov esi, [tab_coord + 2 * 4]

mov eax, 0
ret

; Dessine un trait horizontal avec la fonction xdraw
global xdraw_horizontal
xdraw_horizontal:
push rbp
mov rbp, rsp

; Arguments :
; rdi : x de départ
; rsi : y de départ
; rdx : longueur du trait

; Déterminer l'adresse de la fonction xdraw dans la section .data
lea rax, [rel xdraw]
mov rax, [rax]

; Appeler la fonction xdraw avec les arguments
mov rcx, 0 ; Couleur noire
call rax

pop rbp
ret

; Dessine un triangle avec la fonction xdraw
global xdraw_triangle
xdraw_triangle:
push rbp
mov rbp, rsp

; Arguments :
; rdi : x de départ
; rsi : y de départ
; rdx : longueur des côtés

; Dessiner les trois côtés du triangle
mov rcx, rdi ; x1
mov r8, rsi ; y1
call xdraw_horizontal
mov rcx, rdi ; x2
add r8, rdx ; y2
call xdraw_horizontal
mov rcx, rdi ; x3
sub rsi, rdx ; y3
call xdraw_horizontal

pop rbp
ret

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
mov byte[tour_triangle], 6
.jumpe_triangle:
    call val
    mov [r8], eax
    add r8, 4
    dec byte[tour_triangle]
    cmp byte[tour_triangle], 0    
    jg .jumpe_triangle

; Dessiner le triangle
mov rdi, [tab_coord + 0 * 4] ; x de départ
mov rsi, [tab_coord + 1 * 4] ; y de départ
mov rdx, [tab_coord + 2 * 4] ; longueur des côtés
call xdraw_triangle

pop rbp

; Pour fermer le programme proprement :
mov    eax, 0
ret
