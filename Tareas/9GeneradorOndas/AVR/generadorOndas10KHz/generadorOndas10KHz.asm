	.include"m8535def.inc"
	.def aux = r16
	.def msk = r17
	.def sem = r18
reset:
	rjmp main
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
	ldi aux,1
	out timsk,aux
	sei
	ldi msk,0b00000001
	ldi sem,214
nada:
	rjmp nada

onda0:
	nop
	out tcnt0,sem
	in aux,pina
	eor aux,msk
	out porta,aux
	reti
