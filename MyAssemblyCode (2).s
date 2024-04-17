; CS 274
; Pedro Gomez
; Lab 7: randomized indeces

;initialize constants
curr_X: dw 1
X: dw 5
a: dw 55735
m: dw 65521

suits: db "CHSD"

; this will be used in 3.2 to store the values of the cards 
; that have been handed out, and the current hand 
deck: db [0x00, 0x34]
hand: db [0xff, 0x04]


; places new random index in the dx
def lehmer_index_generator {

    ; store curr_x in ax
    mov si, offset curr_X
    mov ax, word[si]
    
    mul word[offset a]  ; multiply curr_x by a
    div word[offset m]  ; divide by m
    mov word[si], dx    ; store the remainder in curr_X
    
    mov ax, dx
    mov cx, 52
    div cx              ; remainder = index
    ret
}

start:
    call lehmer_index_generator
    
    ; this section will determine the suit and value of the card based on this formula:
    ; ((index - 1) / 13) + 1
    ; result = card value,  remainder = suit index
    mov ax, dx          ; load the index into ax to prepare for division
    ;dec ax
    mov dx, 0
    mov bx, 13
    div bx
    ;inc dx
    
    ; loop to test
    jmp start