extern printf
extern scanf

global main

section .data

section .bss

section .text
main:

push rbp


    mov ah, 0ch    ; Prépare le mode 0Ch
    mov al, 0h     ; Active le mode 0Ch
    int 10h        ; Appel interrupt 10h
    
    mov bh, 0h     ; Définit le plan de couleur a 0
    mov bl, 1h     ; Définit la couleur à 1
    
    mov cx, 0h     ; Défini le compteur cx à 0
    mov dx, 0h     ; Défini le compteur dx à 0
    
Boucle:
    mov ah, 0ch    ; Prépare le mode 0Ch
    int 10h        ; Appel interrupt 10h
    inc cx         ; Incrémente le compteur cx
    cmp cx, 25     ; Compare si cx est égal à 25
    jne Boucle     ; Si non, retourne à la boucle
    jmp Fin        ; Sinon, saute à Fin

Fin:
    ; Fin du programme
    mov ah


fin:
pop rbp
; Pour fermer le programme proprement :
mov    rax, 60
mov    rdi, 0
syscall

ret