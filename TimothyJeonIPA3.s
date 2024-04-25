;CS274
;Timothy Jeon
;For this program, we implemented code where the random input will give
;a card from the standard deck of 52 cards. The 4 suits of clubs,
;hearts, spades, and diamonds are represented by 0, 1, 2, and 3 which
;will be shown by the A register while the card value will be shown by 
;the D register which ranges from 1-13. 1 would be Ace while 11, 12, and 13
;would be Jack, Queen, and King. Some examples would be the random input 
;of 31 giving the 5 of spades and the random input of 15 giving the 2 of hearts.

;data
X_0: dw 7 ;initial value
X_k: dw 1 ;accumulated value from prior iteration
a: dw 11 ;a value that is odd co-prime to m
m: dw 4133 ;a large prime

def betInput {
    mov a
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




start:
    call betInput
    call randomIndex
    call getCardValue
    
loop:
    
    call playerTurn
    
    call computerTurn
    



    
    
    
    


   
   
    

    
    


