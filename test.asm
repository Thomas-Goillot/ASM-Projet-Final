section .text

global  _start

_start:

mov esi, 0 ; compteur
loop:
mov eax, 9 ; définit eax à 9
cdq ; convertit eax en dx:ax
mov ebx, 0 ; ebx à 0 
mov ecx, 9 ; ecx à 9

mov edx, 5 ; edx à 5

div edx ; eax = eax/edx et le reste dans edx

mov ebx, eax ; ebx = eax

mov eax, 9 ; eax à 9
cdq ; convertit eax en dx:ax

mov edx, 3 ; edx à 3

div edx ; eax = eax/edx et le reste dans edx

mov ecx, eax ; ecx = eax


; afficher les variables
mov edx, ebx ; définit edx = ebx
mov eax, 4 ; définit eax = 4
int 0x80 ; afficher ebx

mov edx, ecx ; définit edx = ecx
mov eax, 4 ; définit eax = 4
int 0x80 ; afficher ecx

; saut de ligne
mov edx, 1 ; définit edx à 1
mov ecx, 10 ; définit ecx à 10
mov ebx, 1 ; définit ebx à 1
mov eax, 4 ; définit eax à 4
int 0x80 ; afficher le saut de ligne

inc esi ; incrémente compteur
cmp esi, 5 ; compare esi à 5
jne loop ; saute si pas égal


mov eax,1 ; code retour
int 0x80 ; quitte le programme