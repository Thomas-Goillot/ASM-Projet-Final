; Auteur : Ibrahim OUBIHI / Thomas GOILLOT / Joshua TANG TONG HI
; Date : 24 fevvrier 2023
; Description : Projet Assembleur x64


; -------------------------------------------------------------

; external functions from X11 library
extern XOpenDisplay
extern XDisplayName
extern XCloseDisplay
extern XCreateSimpleWindow
extern XMapWindow
extern XRootWindow
extern XSelectInput
extern XFlush
extern XCreateGC
extern XSetForeground
extern XDrawLine
extern XDrawPoint
extern XFillArc
extern XNextEvent
extern srand

; external functions from stdio library (ld-linux-x86-64.so.2)    
extern printf
extern exit

%define	StructureNotifyMask	131072
%define KeyPressMask		1
%define ButtonPressMask		4
%define MapNotify		19
%define KeyPress		2
%define ButtonPress		4
%define Expose			12
%define ConfigureNotify		22
%define CreateNotify 16
%define QWORD	8
%define DWORD	4
%define WORD	2
%define BYTE	1

global main

section .bss
tab_coord: resd 6
display_name:	resq	1
screen:			resd	1
depth:         	resd	1
connection:    	resd	1
width:         	resd	1
height:        	resd	1
window:		resq	1
gc:		resq	1
determinant:    resd    1
X1: resd    1
X2: resd    1
Y1: resd    1
Y2: resd    1
Angle1: resd    1
Angle2: resd    1
Angle3: resd    1

section .data
number: dd 400
tour_triangle: db 6 
nombre_triangle: dd 7
test: dd "nombre = %d",10,0

event:		times	24 dq 0

tour_couleur:   dd  0

x1:	dd	0
x2:	dd	0
y1:	dd	0
y2:	dd	0

x1:	dd	0
x2:	dd	0
y1:	dd	0
y2:	dd	0

section .text
	
;##################################################
;########### PROGRAMME PRINCIPAL ##################
;##################################################

; -------------------------------------------------------------


;##################################################
;########### FONCTION COULEUR  ####################
;##################################################

global couleur_triangle
couleur_triangle:
push rbp

    cmp r12d,4
    jge rouge

    cmp r12d,3
    jge vert

    cmp r12d,2
    jge violet

    cmp r12d,1
    jge bleu

    noir:
    ;couleur de la ligne 1
    mov rdi,qword[display_name]
    mov rsi,qword[gc]
    mov edx,0x000000	; Couleur du crayon ; noir
    call XSetForeground
    jmp fin1

    rouge:
    ;couleur du point 1
    mov rdi,qword[display_name]
    mov rsi,qword[gc]
    mov edx,0xFF0000	; Couleur du crayon ; rouge
    call XSetForeground
    jmp fin1
    
    vert:
    ;couleur du point 2
    mov rdi,qword[display_name]
    mov rsi,qword[gc]
    mov edx,0x00FF00	; Couleur du crayon ; vert
    call XSetForeground
    jmp fin1

    violet:
    ;couleur du point 4
    mov rdi,qword[display_name]
    mov rsi,qword[gc]
    mov edx,0xFF00FF	; Couleur du crayon ; violet
    call XSetForeground
    jmp fin1

    bleu:
    ;couleur du point 3
    mov rdi,qword[display_name]
    mov rsi,qword[gc]
    mov edx,0x0000FF	; Couleur du crayon ; bleu
    call XSetForeground
    

fin1:
mov eax, r12d
pop rbp
ret




;##################################################
;########### FONCTION CALCUL        ###############
;##################################################


global calcul
calcul:
push rbp

    sub edx,edi
    mov dword[X1], edx
    
    sub r8d,edi
    mov dword[X2], r8d
    
    sub ecx,esi
    mov dword[Y1], ecx

    sub r9d,esi
    mov dword[Y2], r9d

    mov eax, dword[Y2]
    mul dword[X1]
    mov dword[X1], eax

    mov eax, dword[Y1]
    mul dword[X2]
    mov dword[X2], eax

    mov eax,dword[X2]
    sub dword[X1],eax


    mov eax,dword[X1];RESULTAT DU CALCUL

fin2:
pop rbp
ret

;##################################################
;########### FONCTION VAL        ##################
;##################################################

global val
val:
    push rbp
    mov rbp, rsp
    
    ; Générer un nombre aléatoire avec la fonction RDRAND
    mov ecx, 10 ; Limite le nombre de tentatives à 10
    loop:
        xor eax, eax
        rdrand eax
        jc success
        loop loop
        mov eax, [number] ; Si la génération aléatoire a échoué, prendre la valeur 400


    success:
    ; S'assurer que la valeur générée est entre 0 et 399
    xor edx, edx
    div dword [number]
    mov eax, edx
    
    pop rbp
    ret


main:



xor     rdi,rdi
call    XOpenDisplay	; Création de display
mov     qword[display_name],rax	; rax=nom du display

; display_name structure
; screen = DefaultScreen(display_name);
mov     rax,qword[display_name]
mov     eax,dword[rax+0xe0]
mov     dword[screen],eax

mov rdi,qword[display_name]
mov esi,dword[screen]
call XRootWindow
mov rbx,rax

mov rdi,qword[display_name]
mov rsi,rbx
mov rdx,10
mov rcx,10
mov r8,400	; largeur
mov r9,400	; hauteur
push 0xFFFFFF	; background  0xRRGGBB
push 0x00FF00
push 1
call XCreateSimpleWindow
mov qword[window],rax

mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,131077 ;131072
call XSelectInput

mov rdi,qword[display_name]
mov rsi,qword[window]
call XMapWindow

mov rsi,qword[window]
mov rdx,0
mov rcx,0
call XCreateGC
mov qword[gc],rax

mov rdi,qword[display_name]
mov rsi,qword[gc]
mov rdx,0x000000	; Couleur du crayon
call XSetForeground

boucle: ; boucle de gestion des évènements
mov rdi,qword[display_name]
mov rsi,event
call XNextEvent

cmp dword[event],ConfigureNotify	; à l'apparition de la fenêtre
je dessin							; on saute au label 'dessin'

cmp dword[event],KeyPress			; Si on appuie sur une touche
je closeDisplay						; on saute au label 'closeDisplay' qui ferme la fenêtre
jmp boucle

;#########################################
;#		DEBUT DE LA ZONE DE DESSIN		 #
;#########################################

dessin:


debut_boucle:
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


mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,qword[gc]
mov ecx, [tab_coord + 0 * 4]	; coordonnée source en x
mov r8d, [tab_coord + 1 * 4]	; coordonnée source en y
mov r9d, [tab_coord + 2 * 4]	; coordonnée destination en x
mov r12d, [tab_coord + 3 * 4]	; coordonnée destination en y
push r12	; coordonnée destination en y
call XDrawLine

mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,qword[gc]
mov ecx, [tab_coord + 2 * 4]	; coordonnée source en x
mov r8d, [tab_coord + 3 * 4]	; coordonnée source en y
mov r9d, [tab_coord + 4 * 4]; coordonnée destination en x
mov r12d,[tab_coord + 5 * 4]; coordonnée destination en y
push r12	; coordonnée destination en y
call XDrawLine

mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,qword[gc]
mov ecx, [tab_coord + 0 * 4]	; coordonnée source en x
mov r8d, [tab_coord + 1 * 4]	; coordonnée source en y
mov r9d, [tab_coord + 4 * 4]; coordonnée destination en x
mov r12d,[tab_coord + 5 * 4]; coordonnée destination en y
push r12	; coordonnée destination en y
call XDrawLine

call val


;ENVOIE DES COORDONNEES A LA FONCTION CALCUL
mov edi, [tab_coord + 0 * 4]
mov esi, [tab_coord + 1 * 4]
mov edx, [tab_coord + 2 * 4]
mov ecx, [tab_coord + 3 * 4]
mov r8d, [tab_coord + 4 * 4]
mov r9d, [tab_coord + 5 * 4]
call calcul

;TRIANGLE DIRECT OU INDIRECT
mov dword[determinant],eax


mov dword[pt_coord + 0 * 4],0
mov dword[pt_coord + 0 * 4],0

remise_a_zero:
    mov dword[pt_coord + 0 * 4],0

boucle1:
    inc dword[pt_coord + 1 * 4]

    mov edi, [tab_coord + 0 * 4]
    mov esi, [tab_coord + 1 * 4]
    mov edx, [pt_coord + 0 * 4]
    mov ecx, [pt_coord + 1 * 4]
    mov r8d, [tab_coord + 2 * 4]
    mov r9d, [tab_coord + 3 * 4]
    call calcul

    ;ANGLE1
    mov dword[Angle1],eax

    mov edi, [tab_coord + 4 * 4]
    mov esi, [tab_coord + 5 * 4]
    mov edx, [pt_coord + 0 * 4]
    mov ecx, [pt_coord + 1 * 4]
    mov r8d, [tab_coord + 0 * 4]
    mov r9d, [tab_coord + 1 * 4]
    call calcul

    ;ANGLE2
    mov dword[Angle2],eax

    mov edi, [tab_coord + 4 * 4]
    mov esi, [tab_coord + 5 * 4]
    mov edx, [pt_coord + 0 * 4]
    mov ecx, [pt_coord + 1 * 4]
    mov r8d, [tab_coord + 0 * 4]
    mov r9d, [tab_coord + 1 * 4]
    call calcul

    ;ANGLE3
    mov dword[Angle3],eax

    ;change la couleur
    mov r12d, dword[tour_couleur]
    call couleur_triangle
    mov dword[tour_couleur], eax

    mov rdi,qword[display_name]
    mov rsi,qword[window]
    mov rdx,qword[gc]
    mov ecx,[pt_coord + 0 * 4]	; coordonnée source en x
    mov r8d,[pt_coord + 1 * 4]	; coordonnée source en y
    call XDrawPoint


dec dword[nombre_triangle]
cmp dword[nombre_triangle],1
jg debut_boucle



; ############################
; # FIN DE LA ZONE DE DESSIN #
; ############################


  boucle2:
    inc dword[pt_coord + 0 * 4]

    cmp dword[pt_coord + 0 * 4],400
    jge flush

    cmp dword[pt_coord + 1 * 4],400
    jge remise_a_zero

    cmp dword[pt_coord + 0 * 4],400
    jge boucle2

jmp flush


jmp flush

flush:
mov rdi,qword[display_name]
call XFlush
jmp boucle
mov rax,34
syscall

closeDisplay:
    mov     rax,qword[display_name]
    mov     rdi,rax
    call    XCloseDisplay
    xor	    rdi,rdi
    call    exit
	

