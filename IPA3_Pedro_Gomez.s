start:
    ; Game initialization
    call deal_initial_hands

; Main game loop
game_loop:
    ; Player's turn
    call player_turn

    ; Computer's turn
    call computer_turn

    ; Determine winner and update money
    call determine_winner

    ; Ask user to play next turn
    ; Implement input/output handling for user interaction

    ; Check game end conditions
    ; If end condition met, jump to game_end
    jmp game_loop

game_end:
    ; Display winner and final scores
    ; Implement input/output handling for user interaction

    ; Exit program

deal_initial_hands:
    ; Implement dealing cards to player and computer

def playerTurn {
    call betInput
    call randomIndex
    call getCardValue
    add byte [offset playerHandValue], dl
    MOV bl, 16
    MUL bl
    ADD ax, dx
    mov di, offset deck
    add si, di
    mov byte [si], al
    ret
}

def computerTurn {
    call betInput
    call randomIndex
    call getCardValue
    add byte [offset computerHandValue], dl
    MOV bl, 16
    MUL bl
    ADD ax, dx
    mov di, offset deck
    add si, di
    mov byte [si], al
    ret
}

compareHandValues:
    ; Load player and computer hand values
    mov al, [offset playerHandValue]
    mov bl, [offset computerHandValue]

    ; Check if either player or computer has busted (gone over 21)
    cmp al, 21
    jg playerBusted     ; If player has busted, computer wins
    cmp bl, 21
    jg computerBusted   ; If computer has busted, player wins

    ; Compare player and computer hand values
    cmp al, bl
    jl computerWins    ; If computer has higher hand value, computer wins
    jg playerWins      ; If player has higher hand value, player wins

    ; If the hand values are equal, it's a draw
    ; You can handle the draw condition here if needed

    ret

def determineWinner {
    mov al, byte [offset playerHandValue]
    mov bl, byte [offset computerHandValue]
    
    ;check if gone over 21
    cmp al, 21
    jg playerLost
    cmp bl, 21
    jg computerLost
    
    ;cmp both player and computer
    cmp al, bl
    jg playerWin
    jl computerWin
    ret
}


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
    mov dx, 0
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
    dec ax
    mov dx, 0
    mov bx, 13
    div bx
    inc dx
    
    ; loop to test
    jmp start
