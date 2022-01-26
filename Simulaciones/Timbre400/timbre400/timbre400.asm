;Timbre activado con flanco de bajada en INT0 [versión corregida]
;frecuencia de timbre de 400 Hz (timer/counter 0)
;duración 3 segundos (timer/counter 1)
	.include"m8535def.inc"
	.def aux = r16
	.def msk = r17
	.def icta = r18
	.def t1h = r19
	.def t1l = r20 
reset:
	rjmp main
	rjmp timbre
	.org $008
	rjmp tmpo
	rjmp onda
main:
	ldi aux,low(ramend)
	out spl,aux
	ldi aux,high(ramend)
	out sph,aux
	ser aux
	out ddra,aux
	out portd,aux
	ldi aux,2
	out mcucr,aux
	ldi aux,$40
	out gicr,aux
;	ldi aux,2
;	out tccr0,aux
;	ldi aux,3
;	out tccr1b,aux
	ldi aux,0b00000101
	out timsk,aux
	sei
	ldi msk,1
	ldi icta,256-156
	ldi t1h,$48
	ldi t1l,$E5

ciclo:
	rjmp ciclo
onda:
	out tcnt0,icta
	in aux,pina
	eor aux,msk
	out porta,aux
	reti
tmpo:
	out tcnt1h,t1h
	out tcnt1l,t1l
	ldi aux,0
	out tccr0,aux
	ldi aux,0
	out tccr1b,aux
;	clr aux
;	out timsk,aux
	reti
timbre:
	out tcnt1h,t1h
	out tcnt1l,t1l
	ldi aux,2
	out tccr0,aux
	ldi aux,3
	out tccr1b,aux
;	ldi aux,0b00000101
;	out timsk,aux
	reti
                             ;  65536-46875(=$10000-$B71B)  x64 = 3,000,000
							  ;    =18661(=$48E5)
							;	   tcnt1h <= $48
							;	   tcnt1l <= $E5
