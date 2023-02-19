extern printf
extern srand
extern XOpenDisplay
extern XCreateSimpleWindow
extern XMapWindow
extern XSync
extern XDrawLine
extern XSetForeground
extern XCloseDisplay

global main

section .data
    response: db "La valeur est %d",10,0
    window_title: db "Triangle", 0

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
        mov eax, 400 ; Si la génération aléatoire a échoué, prendre la valeur 400

    .success:
    ; S'assurer que la valeur générée est entre 0 et 399
    xor edx, edx
    div dword [number]
    mov eax, edx

    pop rbp
    ret

; Fonction pour dessiner un triangle à l'aide de la fonction XDrawLine
global draw_triangle
draw_triangle:
    push rbp
    mov rbp, rsp

    ; Récupérer les coordonnées du triangle depuis le tableau tab_coord
    mov rsi, tab_coord
    mov eax, [rsi] ; x1
    mov ebx, [rsi + 4] ; y1
    mov ecx, [rsi + 8] ; x2
    mov edx, [rsi + 12] ; y2
    mov edi, [rsi + 16] ; x3
    mov esi, [rsi + 20] ; y3

    ; Ouvrir la fenêtre et obtenir le contexte graphique
    push 0
    call XOpenDisplay
    mov r8, rax ; Récupérer le pointeur vers l'affichage

    mov r9, [rsp+8] ; Récupérer l'ID de l'écran
    xor eax, eax
    mov ebx, 400 ; Largeur de la fenêtre
    mov ecx, 400 ; Hauteur de la fenêtre
    mov edx, 0 ; Bordure de la fenêtre
    mov esi, 0 ; Fond de la fenêtre
    push eax
    push esi
    push edx
    push ecx
    push ebx
    push r9
    call XCreateSimpleWindow
    mov r10, rax ; Récupérer le pointeur vers la fenêtre

    ; Afficher la fenêtre
    push r8
    push r10
    call XMapWindow

    ; Attendre que la fenêtre soit prête à être dessinée
    push r8
    call XSync

    ; Dessiner les lignes du triangle
    push r8
    push r10
    call XSetForeground
    mov eax, 0xFFFFFF ; Couleur blanche
    mov ebx, 1 ; Épaisseur de la ligne
    push eax
    push ebx
    push r8
