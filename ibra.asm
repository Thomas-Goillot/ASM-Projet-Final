 
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
%define nombre_repetition 3

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

section .data
number: dd 400
tour_triangle: db 6 
repetition_atteint: dd nombre_repetition
test: dd "nombre = %d",10,0

event:		times	24 dq 0

x1:	dd	0
x2:	dd	0
y1:	dd	0
y2:	dd	0

section .text
	
;##################################################
;########### PROGRAMME PRINCIPAL ##################
;##################################################

;##################################################
;########### FCT VAL             ##################
;##################################################

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

; couleurs sous forme RRGGBB où RR esr le niveau de rouge, GG le niveua de vert et BB le niveau de bleu
; 0000000 (noir) à FFFFFF (blanc)

;couleur du point 1
mov rdi,qword[display_name]
mov rsi,qword[gc]
mov edx,0xFF0000	; Couleur du crayon ; rouge
call XSetForeground

; Dessin d'un point rouge : coordonnées (100,200)
mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,qword[gc]
mov ecx,100	; coordonnée source en x
mov r8d,200	; coordonnée source en y
call XDrawPoint

;couleur du point 2
mov rdi,qword[display_name]
mov rsi,qword[gc]
mov edx,0x00FF00	; Couleur du crayon ; vert
call XSetForeground

; Dessin d'un point vert: coordonnées (100,250)
mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,qword[gc]
mov ecx,100	; coordonnée source en x
mov r8d,250	; coordonnée source en y
call XDrawPoint

;couleur du point 3
mov rdi,qword[display_name]
mov rsi,qword[gc]
mov edx,0x0000FF	; Couleur du crayon ; bleu
call XSetForeground

; Dessin d'un point bleu : coordonnées (200,200)
mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,qword[gc]
mov ecx,200	; coordonnée source en x
mov r8d,200	; coordonnée source en y
call XDrawPoint

;couleur du point 4
mov rdi,qword[display_name]
mov rsi,qword[gc]
mov edx,0xFF00FF	; Couleur du crayon ; violet
call XSetForeground

; Dessin d'un point violet : coordonnées (200,250)
mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,qword[gc]
mov ecx,200	; coordonnée source en x
mov r8d,250	; coordonnée source en y
call XDrawPoint

;couleur de la ligne 1
mov rdi,qword[display_name]
mov rsi,qword[gc]
mov edx,0x000000	; Couleur du crayon ; noir
call XSetForeground
; coordonnées de la ligne 1 (noire)
mov dword[x1],50
mov dword[y1],50
mov dword[x2],200
mov dword[y2],350
; dessin de la ligne 1
mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,qword[gc]
mov ecx,dword[x1]	; coordonnée source en x
mov r8d,dword[y1]	; coordonnée source en y
mov r9d,dword[x2]	; coordonnée destination en x
push qword[y2]		; coordonnée destination en y
call XDrawLine

;couleur de la ligne 2
mov rdi,qword[display_name]
mov rsi,qword[gc]
mov edx,0xFFAA00	; Couleur du crayon ; orange
call XSetForeground
; coordonnées de la ligne 1 (noire)
mov dword[x1],300
mov dword[y1],50
mov dword[x2],50
mov dword[y2],350
; dessin de la ligne 1
mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,qword[gc]
mov ecx,dword[x1]	; coordonnée source en x
mov r8d,dword[y1]	; coordonnée source en y
mov r9d,dword[x2]	; coordonnée destination en x
push qword[y2]		; coordonnée destination en y
call XDrawLine


; ----------------------------------------------teyvuhb jknzl, fgljHJKNML?F GLZHBJZNEFQNLKFMEZMLZKEN  



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

dec dword[repetition_atteint]
cmp dword[repetition_atteint],1
jg debut_boucle



; ############################
; # FIN DE LA ZONE DE DESSIN #
; ############################
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
	
