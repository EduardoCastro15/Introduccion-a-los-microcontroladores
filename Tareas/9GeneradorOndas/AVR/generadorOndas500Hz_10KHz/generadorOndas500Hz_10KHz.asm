;Este codigo genera dos ondas,  10KHz y 500 Hz
	.include"m8535def.inc"
	.def aux = r16
	.def msk = r17
	.def msk2 =r19
	.def sem = r18
	.def sem2 = r20
reset:
	rjmp main
	.org $004
	rjmp onda1
	.org $009
	rjmp onda0
main:
	ldi aux,low(ramend)
	out spl,aux
	ldi aux,high(ramend)
	out sph,aux
	ser aux
	out ddra,aux
	ldi aux,1
	out tccr0,aux
	ldi aux,2
	out tccr2,aux
	ldi aux,0b01000001
	out timsk,aux
	sei
	ldi msk,0b00000001
	ldi msk2,0b00000010
	ldi sem,256-50+9
	ldi sem2,256-125
nada:
	rjmp nada

onda0:
	nop
	out tcnt0,sem
	in aux,pina
	eor aux,msk
	out porta,aux
	reti
onda1:
	out tcnt2,sem2
	in aux,pina
	eor aux,msk2
	out porta,aux
	reti