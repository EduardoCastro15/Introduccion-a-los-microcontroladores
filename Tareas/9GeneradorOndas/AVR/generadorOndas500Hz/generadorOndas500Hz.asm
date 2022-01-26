	.include"m8535def.inc"
	.def aux = r16
	.def aux2 = r17

reset:
	rjmp main
	.org $009
	rjmp onda
main:
	ldi aux,low(RAMEND)
	out spl,aux
	ldi aux,high(RAMEND)
	out sph,aux
	rcall config_io
fin:
	nop
	nop
	rjmp fin
config_io:
	ser aux
	out ddra,aux
	ldi aux,2
	out tccr0,aux
	ldi aux,1
	out timsk,aux
	sei
	ldi aux2,132
	ret
onda:
	nop
	out tcnt0,aux2
	in aux,pina
	com aux
	out porta,aux
	reti
