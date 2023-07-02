;Pseudocod:
;-Declarare vector, tipul prelucrarii, numar linii si numa coloane
;-Initializere stiva
;-Apel subrutina
;---Adaugare registre pe stiva
;---Calculare lungime vector
;---Selectarea tipului prelucrarii
;---Prelucrarea vectorului
;---Se scot din stiva valorile din registre
;---Revenire din subprogram
;-Iesire din program

section .data
    matr db 23, 124, 245, 254 ;maxim 100x100 elemente cu valori intre 0 si 255, ultimul element sa fie 0
    type db 1
    n db 2 ; maxim 100
    m db 2 ; maxim 100
    matr_len db 0 ; variabila care va memora lungimea vectorului matr
    N equ 100

section .bss
    stack resb N ; zona de memorie a stivei, initializata cu 100h de elemente 0

section .text
    global _start

_start:
    ; apelam subrutina
    call image_proc
    
    
    ; iesim din program
    mov eax, 1 ; setam eax la valoarea 1 (sys_exit)
    mov ebx,0           ; iesim din cod
    int 0x80 ; call the kernel

; functie
image_proc:
    ;salvam pe stiva
    push ax
    push bx
    push cx
    push dx

    ;salvam valoarea tipului funtiei in ch
    mov ch, [type]

    ;initializam registrul ax cu 0
    xor ax, ax

    ;aflarea lungimii vectorului
    mov dl, 0 ;setam registrul dl la 0
    mov esi, matr ;memoram matr
    matr_len_loop:
        cmp byte [esi], 0 ; verificam daca elementul curent al vactorului este zero
        je exit_loop ; daca primul element este zero, iesim din bucla
        add esi, 1 ; incrementam SI pentru a pointa la urmatorul element din vector
        inc dl ; incrementam contorizorul buclei
        jmp matr_len_loop ; sarim inapoi la inceputul buclei
    exit_loop:
        mov [matr_len], dl 

    ;salvam matricea in si
    mov esi, matr

    ; verificam valoarea lui type
    cmp ch, 0
    je conversie
    cmp ch, 1
    je comp_negre
    cmp ch, 2
    je comp_albe

    conversie:
        mov al, [esi] ;valoarea actuala din matrice o salvam in al 
        cmp al, 127 ;comparam valoarea
        jbe negru ;daca este mai mica sau egala valoarea de la instructiunea urmatoare sarim
        cmp al, 128 ;comparam valoarea
        jae alb ;daca este mai mare sau egala valoarea de la instructiunea urmatoare sarim
    negru:
        mov al, 0 ;0 este valoarea pentru negru
        mov [esi], al
        inc esi ;trecem la urmatoarea valoare
        dec byte  [matr_len] ;decrementam lungimea
        jnz conversie ;revenim pentru a continua cu urmatoarele valori
        jmp exit ; if no more values, exit function
    alb:
        mov al, 255 ; set al to 255 (white)
        mov [esi], al
        inc esi ; move to next element in vector
        dec byte  [matr_len] ; ddecrementam lungimea vectorului
        jnz conversie ; jump back to start of loop if there are more values
        jmp exit ;daca nu au mai ramas volori, iesim
    
    comp_negre:
        mov al, [esi]      ;valoarea actuala din matrice o salvam in al
        cmp al, 30        ;comparam valoarea
        jbe negru1        ;daca este mai mica sau egala valoarea de la instructiunea urmatoare sarim
            inc esi        ;trecem la urmatoarea valoare
            dec byte [matr_len] ; decrementam lungimea vectorului
            jnz comp_negre   ;revenim pentru a continua cu urmatoarele valori
            jmp exit      ;daca nu au mai ramas volori, iesim
        negru1:
            mov al, 0     ;0 este valoarea pentru negru
            mov [esi], al ;salvam noua valoare in matrice
            inc esi        ;trecem la urmatoarea valoare
            dec byte [matr_len] ; decrementam lungimea vectorului
            jnz comp_negre   ;revenim pentru a continua cu urmatoarele valori
            jmp exit      ;daca nu au mai ramas volori, iesim
            
    comp_albe:
        mov al, [esi]      ;valoarea actuala din matrice o salvam in al
        cmp al, 225       ;comparam valoarea
        jae alb1          ;daca este mai mare sau egala valoarea de la instructiunea urmatoare sarim
            inc esi        ;trecem la urmatoarea valoare
            dec byte [matr_len] ; decrementam lungimea vectorului
            jnz comp_albe ;revenim pentru a continua cu urmatoarele valori
            jmp exit      ;daca nu au mai ramas volori, iesim
        alb1:
            mov al, 255   ;255 este valoarea pentru alb
            mov [esi], al ; stocam noua valoare in matrice
            inc esi        ;trecem la urmatoarea valoare
            dec byte [matr_len] ; decrementam lungimea vectorului
            jnz comp_albe ;revenim pentru a continua cu urmatoarele valori
            jmp exit      ;daca nu au mai ramas volori, iesim
            
    exit:
    pop ax
    pop bx
    pop cx
    pop dx
    
    ret
    