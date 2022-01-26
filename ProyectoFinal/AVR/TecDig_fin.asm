.include"m8535def.inc"
	.def aux =r16
	.def col=r17
	.def tec = r19
	.def tecf = r20
	.equ G  = $40;  gui?n =$40 G=$7d
	.equ A0 = $3F
	.equ A1 = $06
	.equ A2 = $5B
	.equ A3 = $4F
	.equ A4 = $66
	.equ A5 = $6D
	.equ A6 = $7D
	.equ A7 = $07
	.equ A8 = $7F
	.equ A9 = $67
	.equ SUM = $70
	.equ RES = $40
	.equ MULT = $76
	.equ DIV = $64
	.equ ONC = $77
	.equ EQU = $49


.macro ldb
	ldi aux,@1
	mov @0, aux
	.endm
.macro mensaje
;	ldb r9,@0 
;	ldb r8,@1
	ldb r7,@0 
	ldb r6,@1
	ldb r5,@2 
	ldb r4,@3
	ldb r3,@4 
	ldb r2,@5
	ldb r1,@6 
	ldb r0,@7
	.endm

reset:
	rjmp main ; vector de reset
	rjmp mueve;verctor INT0
	rjmp borra; vector INT1
	.org $009
	rjmp barre;vector timer0
main:
	ldi aux,low(ramend)
	out spl,aux
	ldi aux,high(ramend)
	out sph,aux
	rcall config_io
	rcall texto0
	clr zh
	clr zl
	ldi col,1
	out portc,col
	ld aux,z
	out porta,aux
uno:nop
	nop
	nop
	rjmp uno

config_io:
	ser aux
	out ddra,aux
	out portb,aux
	out ddrc,aux
	out portd,aux
	ldi aux,3
	out tccr0,aux; preescala ck/64
;	ldi aux,3
;	out tccr1b,aux
	ldi aux,$01; 0000 0001
	out timsk,aux; toie0
	ldi r18,193; para contar 63 4ms
	ldi aux,$03; 0000 0011
	out mcucr,aux
	ldi aux,$C0; 1100 0000
	out gicr,aux; habilito INT0 e INT1
	sei
	ret

texto0:
	mensaje G,G,G,G,G,G,G,G
	ret
barre:
	out tcnt0,r18
	out porta,zh
	inc zl
	lsl col
	brne dos; si z = 0
	ldi col,1
	clr zl
dos:
	out portc,col
	ld aux,z
	out porta,aux
	reti

mueve:
	mov r8,r7
	mov r7,r6
	mov r6,r5
	mov r5,r4
	mov r4,r3
	mov r3,r2
	mov r2,r1
	mov r1,r0
	in tec,pinb
	cpi tec,$77
	breq K7
	cpi tec,$7B
	breq K4
	cpi tec,$7D
	breq K1
	cpi tec,$7E
	breq KB
	cpi tec,$B7
	breq K8
	cpi tec,$BB
	breq K5
	cpi tec,$BD
	breq K2
	cpi tec,$BE
	breq K0
	cpi tec,$D7
	breq K9
	cpi tec,$DB
	breq K6
	cpi tec,$DD
	breq K3
	cpi tec,$DE
	breq KEQU
	cpi tec,$E7
	breq KA
	cpi tec,$ED
	breq KRES
	cpi tec,$EE
	breq KSUM
	cpi tec, $EB
	breq KMUL
suelta:
	in tecf,pinb
	cp tecf,tec
	breq suelta  
	reti
K0: ldb r0,A0
	rjmp suelta
K1: ldb r0,A1
	rjmp suelta
K2: ldb r0,A2
	rjmp suelta
K3: ldb r0,A3
	rjmp suelta
K4: ldb r0,A4
	rjmp suelta
K5: ldb r0,A5
	rjmp suelta
K6: ldb r0,A6
	rjmp suelta
K7: ldb r0,A7
	rjmp suelta
K8: ldb r0,A8
	rjmp suelta
K9: ldb r0,A9
	rjmp suelta
KA: ldb r0,DIV
	rjmp suelta
KB: ldb r0,ONC
	rjmp suelta
KSUM:ldb r0,SUM
	rjmp suelta
KRES:ldb r0,RES
	rjmp suelta
KMUL:ldb r0,MULT
	rjmp suelta
KEQU:ldb r0,EQU
	rjmp suelta

borra:
	;rutina que borra ultima tecla
	ldb r9,G
	mov r0,r1
	mov r1,r2
	mov r2,r3
	mov r3,r4
	mov r4,r5
	mov r5,r6
	mov r6,r7
	mov r7,r8
	mov r8,r9
	reti
