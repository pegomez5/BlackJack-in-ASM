;CS274
;Timothy Jeon

;data
X_0: dw 7 ;initial value
X_k: dw 1 ;accumulated value from prior iteration
a: dw 11 ;a value that is odd co-prime to m
m: dw 4133 ;a large prime
playerBet: dw 55 ;hexadecimal value of 55 is 37 shown in memory
playerWins: dw 0
money: dw 1000
deck: db [0x00, 0x34]
hand1: db [0xff, 0x04]
hand2: db [0xff, 0x04]

def betInput {
    mov ah, 0x01
    int 0x21
    mov word [offset playerBet], ax
    ret
}

;3.1. Representing cards, bets and wins on screen
;Gets the random index
def randomIndex {
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
    call store_card
    ret
}

def computerTurn {
    call betInput
    call randomIndex
    call getCardValue
    call store_card
    ret
}

def determineWinner {

    ret
}




start:
    
    
loop:
    call playerTurn
    call computerTurn
    call determineWinner



    
    
    
    


   
   
    

    
    


