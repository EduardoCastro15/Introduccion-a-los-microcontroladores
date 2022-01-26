	.include"m8535def.inc"
	.def aux = r16
	ldi aux,low(ramend)
	out spl,aux
	ldi aux,high(ramend)
	out sph,aux
	ser aux
	out ddra,aux
	out portb,aux

checa:
	sbis pinb,0			;0
	rcall cero
	sbis pinb,1			;25.71
	rcall veinte5
	sbis pinb,2			;51.42
	rcall cincuenta1
	sbis pinb,3			;77.14
	rcall setenta7
	sbis pinb,4			;102.85
	rcall cien2
	sbis pinb,5			;128.57
	rcall cien28
	sbis pinb,6			;154.28
	rcall cien54
	sbis pinb,7			;180
	rcall cien80
	rjmp checa

cero:
	sbi porta,0
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	cbi porta,0
	ldi aux,43
cta0:
	rcall medms
	dec aux
	brne cta0
	ret

veinte5:
	sbi porta,0
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	cbi porta,0
	ldi aux,42
cta1:
	rcall medms
	dec aux
	brne cta1
	ret

cincuenta1:
	sbi porta,0
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	cbi porta,0
	ldi aux,41
cta2:
	rcall medms
	dec aux
	brne cta2
	ret

setenta7:
	sbi porta,0
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	cbi porta,0
	ldi aux,40
cta3:
	rcall medms
	dec aux
	brne cta3
	ret

cien2:
	sbi porta,0
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	cbi porta,0
	ldi aux,39
cta4:
	rcall medms
	dec aux
	brne cta4
	ret

cien28:
	sbi porta,0
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	cbi porta,0
	ldi aux,38
cta5:
	rcall medms
	dec aux
	brne cta5
	ret

cien54:
	sbi porta,0
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	cbi porta,0
	ldi aux,37

cta6:
	rcall medms
	dec aux
	brne cta6
	ret

cien80:
	sbi porta,0
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	rcall medms
	cbi porta,0
	ldi aux,36

cta7:
	rcall medms
	dec aux
	brne cta7
	ret

medms:
	; Assembly code auto-generated
	; by utility from Bret Mulvey
	; Delay 136 cycles
	; 136us at 1 MHz
	ldi  r18, 45

L1: dec  r18
    brne L1
    nop
	ret
