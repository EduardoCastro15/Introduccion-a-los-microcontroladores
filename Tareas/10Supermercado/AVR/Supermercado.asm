	.include"m8535def.inc"
	.def aux = r16
	.def msk = r17
	.def ini = r18
	.def tc1h = r19
	.def tc1l = r20
	.def auc = r21 

reset:
	rjmp main
	.org $004
	rjmp onda
	.org $008
	rjmp tmpo
	rjmp cliente
main:
	ldi aux,low(ramend)
	out spl,aux
	ldi aux,high(ramend)
	out sph,aux
	ser aux
	out ddra,aux
	out ddrc,aux
	out portb,aux
	ldi aux,6
	out tccr0,aux
	ldi aux,0b01000101
	out timsk,aux
	sei
	ldi aux,250
	out tcnt0,aux
	ldi msk,1
	ldi ini,256-141
	ldi tc1h,$B3
	ldi tc1l,$B5
	out tcnt1h,tc1h
	out tcnt1l,tc1l
nada:
	in auc,tcnt0
	clr aux
	sub aux,auc
	out portc,aux
	rjmp nada
onda:
	out tcnt2,ini
	in aux,pina
	eor aux,msk
	out porta,aux
	reti
tmpo:
	ldi aux,0
	out tccr2,aux
	out tccr1b,aux
	ldi aux,250
	out tcnt0,aux
	reti
cliente:
	ldi aux,2
	out tccr2,aux
	ldi aux,4
	out tccr1b,aux
    out tcnt1h,tc1h
	out tcnt1l,tc1l
	reti
; 

; para 5 segundos se necesitan 5,000,000 ciclos
;           19531.25x256=5000000
;      65536-19531=46005=$b3b5
;                tcnt1h <= $B3
;                tcnt1l <= $B5
