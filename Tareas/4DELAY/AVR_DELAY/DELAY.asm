.include "m8535def.inc"
.def aux = r16
.def contador = r18

	ldi aux,low(RAMEND)
	out spl, aux
	ldi aux, high(RAMEND)
	out sph,aux
	ser aux
	out ddra, aux
	clr contador
	ldi r17, $0A ;Cargamos un diez
	ldi aux, $3f ;0
	mov r0, aux
	ldi aux, $06 ;1
	mov r1, aux
	ldi aux, $5b ;2
	mov r2, aux
	ldi aux, $4f ;3
	mov r3, aux
	ldi aux, $66 ;4
	mov r4, aux
	ldi aux, $6d ;5
	mov r5, aux
	ldi aux, $7d ;6
	mov r6, aux	
	ldi aux, $07 ;7
	mov r7, aux
	ldi aux, $7f ;8
	mov r8, aux
	ldi aux, $6f ;9
	mov r9, aux
	clr ZH
cuenta:
	ldi ZL, 0
	add ZL, contador
	ld aux, Z
	out porta,aux
	rcall retardo
	inc contador
	cp contador, r17 ;Comparamos si el contador es 10
	breq reinicio
	rjmp cuenta
retardo:
	push contador
	ldi r18, 31
	ldi r19, 113
	ldi r20, 31
L1: dec r20
	brne L1
	dec r19
	brne L1
	dec r18
	brne L1
	nop
	nop
	pop contador
	ret
reinicio:
	clr contador
	rjmp cuenta
