;CS274
;Timothy Jeon

;data
X_0: dw 7 ;initial value
X_k: dw 1 ;accumulated value from prior iteration
a: dw 11 ;a value that is odd co-prime to m
m: dw 4133 ;a large prime
playerBet: dw 55 ;hexadecimal value of 55 is 37 shown in memory
computerBet: dw 100
playerWins: dw 0
computerWins: dw 0
playerHandValue: db 0
computerHandValue: db 0
playerMoney: dw 1000
computerMoney: dw 1000
cardUsed: dw 0
deck: db [0x00, 0x34]

; Messages
bet_msg: db "Place bet ($10 - $1000)"
consent_msg: db "Continue playing? (Y/N)"
lost_msg: db "You lost :("
won_msg: db "You won!"

def get_consent {
    mov ah, 0x13
    mov cx, 23
    mov bx, 0
    mov es, bx
    mov bp, offset bet_msg
    int 0x10
}

def betInput {
    ; Ask user for bet amount
    mov dx, 0
    mov ah, 0x13
    mov cx, 23
    mov bx, 0
    mov es, bx
    mov bp, offset bet_msg
    int 0x10

    mov ah, 0x0a
    mov dx, offset playerBet
    int 0x21
    ;mov word [offset playerBet], ax
    ret
}

;3.1. Representing cards, bets and wins on screen
;Gets the random index
def randomIndex {
    mov dx, 0
    mov si, offset X_k ;moves offset of X_k to si
    mov ax, word [si] ;moves value of X_k to ax
    mov bp, offset m ;moves offset of m to bp
    mov bx, word [bp] ;moves value of m to bx
    mov di, offset a ;moves offset of a to di
    mul word [di] ;multplies X_k by a
    div bx ;divides (X_k * a) by m. dx stores remainder
    mov word [si], dx ;moves dx(remainder) to X_k
    mov ax, dx ;moves remainder to ax
    mov cx, 52 ;moves 52 to cx where cx = 52
    div cx ;divides X_k by cx(52) where it'll be stored in ax
    ret
}

; Stores card value
def store_card {
    MOV bl, 16
    MUL bl
    ADD ax, dx
    mov di, offset deck
    add si, di
    mov byte [si], al
    ret
}

;3.1. Representing cards, bets and wins on screen
;Gives card value from the random index
def getCardValue {
    mov si, dx
    mov ax, dx ;moves remainder of dx to ax
    mov dx, 0 ;moves 0 to dx
    mov bx, 13 ;moves 13 to bx
    sub ax, 1 ;subtract 1 from ax
    div bx ;divides ax by bx
    add dx, 1 ;adds 1 to dx
    ret
}

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

playerLost:
    
    
computerLost:

    
    
playerWin:
    inc word [offset playerWins]
    jmp gameLoop
    
computerWin:
    inc word [offset computerWins]
    jmp gameLoop
    
playerWinsGame:
    
computerWinsGame:
    
def compareHandValues {
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

def checkMoney {
    mov ax, word [offset playerMoney]
    cmp ax, 0
    je determineWinner
    mov bx, word [offset computerMoney]
    cmp bx, 0
    je determineWinner
}

determineWinner:
    mov ax, word [offset playerWins]
    mov bx, word [offset computerWins]
    cmp ax, bx
    jg playerWinsGame
    jl computerWinsGame


    
    
start:
    ;initial wealth
    ;number of card decks
    ;computer betting mode
    ;computer risk level
    ;difficulty
    
gameLoop:
    ; Check number of cards pulled
    ; Check money 
    call checkMoney
    call playerTurn
    call computerTurn
    call compareHandValues

    ; Ask player to continue play
    ; if yes, determine_winner
    
    
    jmp gameLoop

game_end:
   
    

    
    


