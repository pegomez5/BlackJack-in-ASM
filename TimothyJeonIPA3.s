;CS274
;Timothy Jeon

;data
X_0: dw 7 ;initial value
X_k: dw 1 ;accumulated value from prior iteration
a: dw 11 ;a value that is odd co-prime to m
m: dw 4133 ;a large prime
playerBet: dw 55 ;hexadecimal value of 55 is 37 shown in memory
computerBet: dw 100
playerWins: dw 0 ;tracks player wins
plrTurnInput: dw 0
computerWins: dw 0 ;tracks computer wins
playerHandValue: db 0 ;amount of value in player's hand
computerHandValue: db 0 ;amount of value in computer's hand
playerMoney: dw 1000 ;amount player has
computerMoney: dw 1000 ;amount computer has
cardUsed: dw 0 ;counts amount of cards used from deck
plr_consent: dw "N"
decksUsed: dw 0
deck: db [0x00, 0x34]
bet_mode: dw "N"


; Messages
mode_msg: db "Choose the CPU's betting mode (C, N, A)"     ; Conservative, Normal, Aggressive
plr_input_msg: db "Hit (H), Stand (S), Forfeit (F)"
wealth_msg: db "How much money will you start out with?"
decks_msg: db "How many decks will you use?"
bet_msg: db "Place bet ($10 - $1000)"
consent_msg: db "Continue playing? (Y/N)"
lost_msg: db "You lost :("
won_msg: db "You won!"

def init_wealth {
    ; Ask initial wealth
    mov ah, 0x13
    mov cx, 39
    mov bx, 0
    mov es, bx
    mov bp, offset wealth_msg
    int 0x10
    
    ; Get input
    mov ah, 0x0a
    mov dx, offset playerMoney
    mov si, dx
    int 0x21
    ret
}

def init_decks {
    ; Ask deck amount
    mov ah, 0x13
    mov cx, 28
    mov bx, 0
    mov es, bx
    mov bp, offset decks_msg
    int 0x10
    
    ; Get input
    mov ah, 0x0a
    mov dx, offset decksUsed
    mov si, dx
    int 0x21
    ret
}

def init_betting_mode {
    ; Ask betting mode
    mov ah, 0x13
    mov cx, 39
    mov bx, 0
    mov es, bx
    mov bp, offset mode_msg
    int 0x10
    
    ; Get input
    mov ah, 0x0a
    mov dx, offset decksUsed
    mov si, dx
    int 0x21
    ret
}

def init_difficulty {
    ; Ask difficulty
    mov ah, 0x13
    mov cx, 28
    mov bx, 0
    mov es, bx
    mov bp, offset bet_mode
    int 0x10
    
    ; Get input
    mov ah, 0x0a
    mov dx, offset decksUsed
    mov si, dx
    int 0x21
    ret
}

def init_risk_level {
    ret
}

;Gets the random index
def computerRisk {
}

def getComputerInput {
    ; Calculate random number between 0, 100
    mov dx, 0
    mov si, offset X_k ;moves offset of X_k to si
    mov ax, word [si]  ;moves value of X_k to ax
    mov bp, offset m   ;moves offset of m to bp
    mov bx, word [bp]  ;moves value of m to bx
    mov di, offset a   ;moves offset of a to di
    mul word [di]      ;multplies X_k by a
    div bx             ;divides (X_k * a) by m. dx stores remainder
    mov word [si], dx  ;moves dx(remainder) to X_k
    mov ax, dx         ;moves remainder to ax
    mov cx, 100        ;moves 100 to cx where cx = 100
    div cx             ;divides X_k by cx(100) where it'll be stored in al

    ; CPU Risk: Forfeit (al < 20), Hit (19 < al < 50), Stand (al > 49) 
    cmp al, 49
    jg cpu_stand

    cmp al, 19
    jg cpu_hit

    cmp al, -1
    jg gameloop
    
    ret
}

def getPlrInput { 
    ; Ask H, S, F
    mov ah, 0x13
    mov cx, 31
    mov bx, 0
    mov es, bx
    mov bp, offset plr_input_msg
    int 0x10
    
    ; Get input
    mov ah, 0x0a
    mov dx, offset plrTurnInput
    mov si, dx
    int 0x21
    
    ; Store input into ax for comparison
    add si, 2
    mov al, byte [si]

    ; Compare input , if F, jmp to computerWin
    mov bl, 0x46
    cmp al, bl
    je computerWin

    ; Compare input, if H, jmp to givePlrCard
    mov bl, 0x48
    cmp al, bl
    je givePlayerCard

    ; Otherwise, input is assumed to be S, meaning we can
    ; continue the gameflow, moving onto the computers turn
    ret
}

def get_consent {

    ; Print consent request
    mov ah, 0x13
    mov cx, 23
    mov bx, 0
    mov es, bx
    mov bp, offset consent_msg
    int 0x10
    
    ; Get input
    mov ah, 0x0a
    mov dx, offset plr_consent
    mov si, dx
    int 0x21
    
    ; Store input into ax for comparison
    add si, 2
    mov al, byte [si]

    ; Compare input , if not continuing play, jmp to determine winner
    mov bl, 0x4e
    cmp al, bl
    je determineWinner
    ret
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
    mov si, dx
    int 0x21

    ; Store input into ax for comparison
    add si, 2
    mov al, byte [si]
    
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
def store_plr_card {
    add byte [offset playerHandValue], dl
    MOV bl, 16
    MUL bl
    ADD ax, dx
    mov di, offset deck
    add si, di
    mov byte [si], al
    ret
}

def store_cpu_card {
    add byte [offset computerHandValue], dl
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
    inc word [offset cardUsed]
    ret
}

;increments player win count
playerWin:
    inc word [offset playerWins]
    jmp beginRound

;increments computer win count
computerWin:
    inc word [offset computerWins]
    jmp beginRound
    
playerWinsGame:
    ; Print stff
    
    mov ah, 0x13
    mov cx, 8
    mov bx, 0
    mov es, bx
    mov bp, offset won_msg
    int 0x10
    jmp game_end
    
computerWinsGame:
    ;print stuff
    
    mov ah, 0x13
    mov cx, 11
    mov bx, 0
    mov es, bx
    mov bp, offset lost_msg
    int 0x10
    jmp game_end
    
def compareHandValues {
    mov al, byte [offset playerHandValue]
    mov bl, byte [offset computerHandValue]
    
    ;check if gone over 21
    cmp al, 21
    jg computerWin
    cmp bl, 21
    jg playerWin
    
    ;cmp both player and computer
    cmp al, bl
    jg playerWin
    jl computerWin
    ret
}

;Checks if player or computer has no money.
def checkMoney {
    mov ax, word [offset playerMoney]
    cmp ax, 0
    je determineWinner
    mov bx, word [offset computerMoney]
    cmp bx, 0
    je determineWinner
    ret
}

;Checks the number of cards that have been pulled. 
;If greater than 51, all the cards have been pulled.
def checkCardAmount {
    mov ax, word [offset cardUsed]
    cmp ax, 51
    jg determineWinner
    ret
}

;Game end which is only called if human or computer money = 0, no more cards in deck, or human indicates termination of game.
determineWinner:
    mov ax, word [offset playerWins]
    mov bx, word [offset computerWins]
    cmp ax, bx
    jg playerWinsGame
    jl computerWinsGame    

; ----------------- Game configuration -----------------
start:
    ;initial wealth
    call init_wealth
    
    ;number of card decks
    call init_decks
    
    ;computer betting mode
    call init_betting_mode
    
    ;computer risk level
    call init_risk_level
    
    ;difficulty
    call init_difficulty
; ----------------- Beginning of each round -----------------
beginRound:
    ; Check money 
    call checkMoney
    ; Check number of cards pulled
    call checkCardAmount.
    
playerTurn:
    call betInput
    call getPlrInput

computerTurn:
    call betInput
    call getComputerInput

gameLoop:
    call compareHandValues

    ; Ask player to continue play
    ; if no, determine_winner
    call get_consent
    
    jmp gameLoop
; ----------------- End of round -----------------

; ----------------- Conditional labels -----------------

givePlayerCard:
    call randomIndex
    call getCardValue
    call store_plr_card
    jmp playerTurn

giveComputerCard:
    ; Implement computer betting 
    call randomIndex
    call getCardValue
    call store_cpu_card
    jmp computerTurn
    
; ----------------- End of game -----------------
game_end:
   
