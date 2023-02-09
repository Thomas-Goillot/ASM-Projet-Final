section .data
    seed dd 0x0 ; Seed initial
    random dd 0x0 ; Nombre aléatoire

section .text
    global _start
 
_start:
    ; Initialisation du générateur
    mov eax, [seed]
    add eax, 0x3D
    rol eax, 0x7
    mov [seed], eax
 
    ; Calcul du nombre aléatoire
    mov eax, [seed]
    xor eax, 0x3F
    and eax, 0xFF
    mov [random], eax
 
    ; Fin de programme
    mov eax, 60 ; syscall exit
    xor edi, edi ; exit code 0
    syscall
