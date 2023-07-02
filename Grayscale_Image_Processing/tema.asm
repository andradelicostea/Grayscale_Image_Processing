;Pseudocode:
;-Vector declaration, processing type, number of lines and number of columns
;-Stack initialization
;-Subroutine call
;---Adding registers to the stack
;---Calculation of vector length
;---Selection of the type of processing
;---Vector processing
;---The register values are removed from the stack
;---Return from subroutine
;-Exit the program

section .data
    matr db 23, 124, 245, 254 ;maximum 100x100 elements with values between 0 and 255, the last element should be 0
    type db 1
    n db 2 ; maximum 100
    m db 2 ; maximum 100
    matr_len db 0 ; the variable that will store the length of the matr vector
    N equ 100

section .bss
    stack resb N ; the stack memory area, initialized with 100h of 0 elements

section .text
    global _start

_start:
    ; Subroutine call
    call image_proc
    
    
    ; Exit the program
    mov eax, 1 ; we set eax to the value 1 (sys_exit)
    mov ebx,0           ; we exit the code
    int 0x80 ; call the kernel

; functie
image_proc:
    ;save on the stack
    push ax
    push bx
    push cx
    push dx

    ;we save the value of the function type in ch
    mov ch, [type]

    ;initialize the ax register with 0
    xor ax, ax

    ;finding the length of the vector
    mov dl, 0 ;we set the dl register to 0
    mov esi, matr ;we memorize matr
    matr_len_loop:
        cmp byte [esi], 0 ; we check if the current element of the vector is zero
        je exit_loop ; if the first element is zero, we exit the loop
        add esi, 1 ; we increment SI to point to the next element in the vector
        inc dl ; we increment the loop counter
        jmp matr_len_loop ; we jump back to the beginning of the loop
    exit_loop:
        mov [matr_len], dl 

    ;we save the matrix in si
    mov esi, matr

    ; we check the value of type
    cmp ch, 0
    je conversie
    cmp ch, 1
    je comp_negre
    cmp ch, 2
    je comp_albe

    conversie:
        mov al, [esi] ;we save the current value from the matrix in al
        cmp al, 127 ;we compare the value
        jbe negru ;if it is less than or equal to the value from the next instruction, we jump
        cmp al, 128 ;we compare the value
        jae alb ;if it is greater than or equal to the value from the next instruction, we jump
    negru:
        mov al, 0 ;0 is the value for black
        mov [esi], al
        inc esi ;we move to the next value
        dec byte  [matr_len] ;we decrement the length
        jnz conversie ;we return to continue with the following values
        jmp exit ; if no more values, exit function
    alb:
        mov al, 255 ; set al to 255 (white)
        mov [esi], al
        inc esi ; move to next element in vector
        dec byte  [matr_len] ; we decrement the length of the vector
        jnz conversie ; jump back to start of loop if there are more values
        jmp exit ;if there are no flights left, we exit
    
    comp_negre:
        mov al, [esi]      ;we save the current value from the matrix in al
        cmp al, 30        ;we compare the value
        jbe negru1        ;if it is less than or equal to the value from the next instruction, we jump
            inc esi        ;we move to the next value
            dec byte [matr_len] ; we decrement the length of the vector
            jnz comp_negre   ;we return to continue with the following values
            jmp exit      ;if there are no flights left, we exit
        negru1:
            mov al, 0     ;0 is the value for black
            mov [esi], al ;we save the new value in the matrix
            inc esi        ;we move to the next value
            dec byte [matr_len] ; we decrement the length of the vector
            jnz comp_negre   ;we return to continue with the following values
            jmp exit      ;if there are no flights left, we exit
            
    comp_albe:
        mov al, [esi]      ;we save the current value from the matrix in al
        cmp al, 225       ;we compare the value
        jae alb1          ;if it is greater than or equal to the value from the next instruction, we jump
            inc esi        ;we move to the next value
            dec byte [matr_len] ; we decrement the length of the vector
            jnz comp_albe ;we return to continue with the following values
            jmp exit      ;if there are no flights left, we exit
        alb1:
            mov al, 255   ;255 is the value for white
            mov [esi], al ; we store the new value in the matrix
            inc esi        ;we move to the next value
            dec byte [matr_len] ; we decrement the length of the vector
            jnz comp_albe ;we return to continue with the following values
            jmp exit      ;if there are no flights left, we exit
            
    exit:
    pop ax
    pop bx
    pop cx
    pop dx
    
    ret
    
