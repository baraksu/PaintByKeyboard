.MODEL small
.STACK 100h


.DATA
msg1 db 13, 10, '  ____                   ____  _                 _           $'
msg2 db 13, 10, ' |  _ \ ___   ___  ___  / ___|| |__   __ _ _ __ (_)_ __ __ _ $'
msg3 db 13, 10, ' | |_) / _ \ / _ \/ _ \ \___ \|  _ \ / _  |  _ \| |  __/ _  |$'
msg4 db 13, 10, ' |  _ < (_) |  __/  __/  ___) | | | | (_| | |_) | | | | (_| |$'
msg5 db 13, 10, ' |_| \_\___/ \___|\___| |____/|_| |_|\__,_| .__/|_|_|  \__,_|$'
msg6 db 13, 10, '                                          |_|                $' 
msg7 db 13, 10, '  ___      _     _   ___      _  __         _                      _   $'
msg8 db 13, 10, ' | _ \__ _(_)_ _| |_| _ )_  _| |/ /___ _  _| |__  ___  __ _ _ _ __| |  $' 
msg9 db 13, 10, ' |  _/ _` | | ' \  _| _ \ || | ' </ -_) || | '_ \/ _ \/ _` | '_/ _` |_ $'
msg10 db 13, 10, ' |_| \__,_|_|_||_\__|___/\_, |_|\_\___|\_, |_.__/\___/\__,_|_| \__,_(_)$'
msg11 db 13, 10, '                         |__/          |__/                            $'
msg12 db 13, 10, 'Press 1 to start: $'    

char db ?                         
x dw 1h
y dw 1h
column dw 150
row dw 95 
w equ 10
h equ 5
ColorChanged db 0
ColorChangedUpDown db 0 
     
.CODE

BeforeProject proc
    lea DX,msg1 ;Show msg1 
    mov AH,09h 
    int 21h
    
    lea DX,msg2 ;Show msg2 
    mov AH,09h 
    int 21h  
    
    lea DX,msg3 ;Show msg3 
    mov AH,09h 
    int 21h   
    
    lea DX,msg4 ;Show msg4 
    mov AH,09h 
    int 21h  
    
    lea DX,msg5 ;Show msg5 
    mov AH,09h 
    int 21h  
    
    lea DX,msg6 ;Show msg6 
    mov AH,09h 
    int 21h
    
    lea DX,msg7 ;Show msg7 
    mov AH,09h 
    int 21h
    
    lea DX,msg8 ;Show msg8 
    mov AH,09h 
    int 21h
    
    lea DX,msg9 ;Show msg9 
    mov AH,09h 
    int 21h
    
    lea DX,msg10 ;Show msg10 
    mov AH,09h 
    int 21h
    
    lea DX,msg11 ;Show msg11 
    mov AH,09h 
    int 21h 
    
    lea DX,msg12 ;Show msg11 
    mov AH,09h 
    int 21h 
ReadLoop:    
    mov AH, 01h ;Read a character 17
    int 21h 
    mov char,AL
    
    cmp char,'1' ;If character less then 0 : Somthing else 20
    jne ReadLoop
    
ret     
  
DrawSquare Macro x0,y0,w,h
  LOCAL Draw, DoneColums, DoneColums,doneDraw 

    mov cx,x0
	add cx,w
	
	mov dx,y0
	add dx, h
	
	
Draw: 
	cmp dx,y0
	jb DoneDraw 
	cmp cx,x0
	jb DoneColums
	
    ;mov cx, x  ; column
	;mov dx, y  ; row
	mov al, 15  ; white
	mov ah, 0ch ; put pixel
	int 10h
	
	dec cx
	jmp Draw
	
DoneColums:
	dec dx
	mov cx,x0
	add cx,w
	jmp Draw

DoneDraw:
    nop   
ENDM
     
DrawWithColor proc
    push bp
    mov bp, sp
    
    mov cx, [bp + 12]
    add cx, [bp + 8]
    mov dx, [bp + 10]
    add dx, [bp + 6]
    
DrawColor:
    cmp dx, [bp +10]
    jb DoneDrawColor
    cmp cx, [bp + 12]
    jb DoneColumsColor
    
    mov al, [bp + 4] 
	mov ah, 0ch 
	int 10h
	
	dec cx
	jmp DrawColor
	
DoneColumsColor:
    dec dx
	mov cx, [bp + 12]
    add cx, [bp + 8]
	jmp DrawColor
	
DoneDrawColor:
    pop bp
    ret 8     		
                
DrawRow proc
    
    push BP     ; save BP on stack
    mov BP, SP  ; set BP to current SP      
    push cx
    push dx        
    
    mov dx, [bp+10]; row
    mov cx, [bp+8];column
    add cx, [bp+6];w
    
    mov al,byte ptr [bp+4]  ; color
	mov ah, 0ch ; put pixel
    
NextColumn:
    int 10h
    dec cx
    cmp cx, [bp+8]
    jnb NextColumn
    
    pop dx
    pop cx      
    POP BP          ; restore BP from stack
    RET 8
        
DrawRow endp    

DrawColumn proc
     
    push BP         ; save BP on stack
    mov BP, SP      ; set BP to current SP 
    push cx
    push dx

    mov cx, [bp+10]; column
    mov dx, [bp+8];row
    add dx, [bp+6];h
    
    ;mov cx ; column
	;mov dx  ; row
	
	mov al,byte ptr [bp+4]  ; color
	mov ah, 0ch ; put pixel
NextRow:   
    int 10h
	dec dx       
	cmp dx,[bp+8]
	jnb NextRow   

    pop dx
    pop cx      
    POP BP          ; restore BP from stack
    RET 8           ; return from the function and clean up the stack 
    
DrawColumn endp

start:
	mov ax, @data
    mov ds, ax
    
    call BeforeProject   
	
	mov ah, 0   ; set display mode function.
	mov al, 13h ; mode 13h = 320x200 pixels, 256 colors.
	int 10h     ; set it!


DrawSquare column,row,w,h 
 

Redraw:
    ; is key press    
    mov ah,01h
    int 16h
    
    jz Redraw
    ; Get the pressed key
    mov ah,00h
    int 16h
        
    cmp ah,4Dh ;right arrow key 
    je moveRight
    
    cmp ah,4Bh ;left arrow key
    je MoveLeft
    
    cmp ah,48h ;up arrow key
    je MoveUp
    
    cmp ah,50h ;down arrow key
    je MoveDown
    
    cmp al, 62h
    je BluePut
    
    cmp al, 72h
    je RedPut 
    
    cmp al, 67h
    je GreenPut
    
    cmp al, 79h
    je YellowPut
    
    cmp al, 70h
    je PurplePut
    
    cmp al, 6Fh
    je OrangePut        

moveRight:

    cmp ColorChanged,0
    jne ColorChangedRightLabel
    mov ColorChangedUpDown, 0
    
    ; draw the left column with black   
    push column
    push row
    push h
    push 0h; color Black
    call DrawColumn
    jmp ColorNotChangedRightLabel
      
ColorChangedRightLabel:
    dec ColorChanged
ColorNotChangedRightLabel:
 
 ;Draw Draw the right column with white   
    add column,1
    mov cx, column
    add cx,w
    push cx ;last column
    push row
    push h
    push 0Fh ;color white
    call DrawColumn
    
	jmp Redraw
    
MoveLeft:
    
    cmp ColorChanged,0
    jne ColorChangedLeftLabel
    mov ColorChangedUpDown, 0 
        
    mov cx, column
    add cx,w
    push cx ;last column
    push row
    push h
    push 0h
    call DrawColumn
    jmp ColorNotChangedLeftLabel
      
ColorChangedLeftLabel:
    dec ColorChanged
ColorNotChangedLeftLabel:
        
    sub column,1
    mov cx, column
    push cx ;last column
    push row
    push h
    push 0Fh; color black
    call DrawColumn
       
    jmp Redraw

MoveUp: 

    cmp ColorChangedUpDown,0
    jne ColorChangedUpLabel 
    mov ColorChanged, 0
        
    mov dx, row
    add dx,h
    push dx
    push column
    push w
    push 0h   ;color black
    call DrawRow
jmp ColorNotChangedUpLabel
      
ColorChangedUpLabel:
    dec ColorChangedUpDown
ColorNotChangedUpLabel:    
       
    sub row, 1
    push row
    push column
    push w
    push 0fh  ;color white
    call DrawRow  
    
    
    jmp Redraw 
    
MoveDown:
    
    cmp ColorChangedUpDown,0
    jne ColorChangedDownLabel
    mov ColorChanged, 0
        
    mov dx, row
    push dx
    push column
    push w
    push 0h  ;color black
    call DrawRow
jmp ColorNotChangedDownLabel
      
ColorChangedDownLabel:
    dec ColorChangedUpDown
ColorNotChangedDownLabel:    
    

    add row, 1
    mov dx, row
    add dx, h    
    push dx
    push column
    push w
    push 0fh ;color white
    call DrawRow
    
    jmp Redraw

BluePut:
    push column
    push row
    push w
    push h
    push 20h
    
    call DrawWithColor 
    mov ColorChanged, w
    inc ColorChanged
    mov ColorChangedUpDown, h
    inc ColorChangedUpDown
    jmp Redraw
    
RedPut:
    push column
    push row
    push w
    push h
    push 29h
    
    call DrawWithColor
    mov ColorChanged, w
    inc ColorChanged
    mov ColorChangedUpDown, h
    inc ColorChangedUpDown
    jmp Redraw
    
GreenPut:
    push column
    push row
    push w
    push h
    push 2Fh
    
    call DrawWithColor 
    mov ColorChanged, w
    inc ColorChanged
    mov ColorChangedUpDown, h
    inc ColorChangedUpDown
    jmp Redraw
    
YellowPut:
    push column
    push row
    push w
    push h
    push 2Ch
    
    call DrawWithColor 
    mov ColorChanged, w
    inc ColorChanged
    mov ColorChangedUpDown, h
    inc ColorChangedUpDown
    jmp Redraw
    
PurplePut:
    push column
    push row
    push w
    push h
    push 22h
    
    call DrawWithColor 
    mov ColorChanged, w
    inc ColorChanged
    mov ColorChangedUpDown, h
    inc ColorChangedUpDown
    jmp Redraw
    
OrangePut:
    push column
    push row
    push w
    push h
    push 2Bh
    
    call DrawWithColor 
    mov ColorChanged, w
    inc ColorChanged
    mov ColorChangedUpDown, h
    inc ColorChangedUpDown
    jmp Redraw                            
    
exit:
;wait for keypress
  mov ah,00
  int 16h			

  mov AH,4CH
  int 21h

END start

ret
