;Timbre activado con flanco de bajada en INT0
;frecuencia de timbre de 440 Hz (timer/counter 2)
;duración 5 segundos (timer/counter 1)

;USAREMOS LA EEPROM PARA MANTENER EL CONTEO DE LOS CLIENTES GANADORES.
	.include"m8535def.inc"
	.def dato = r16
	.def dirl = r17
	.def dirh = r18
	.def aux  = r19
	.def msk  = r20
	.def cta_cte  = r21 ; para contar los clientes 
	.def cta_time = r22
	.def cta_eepr = r23
	.def t1h = r24
	.def t1l = r25
	
	.macro eepr_w
		ldi dirh,@0  ;para leer el contenido del registro seria mov
		ldi dirl,@1
		mov dato,@2
		rcall EEPROM_write
	.endm

	.macro eepr_r
		ldi dirh,@0
		ldi dirl,@1
		rcall EEPROM_read
		mov cta_eepr, dato
	.endm

reset:
	rjmp main
	.org $004
	rjmp onda    ;DESBORDAMIENTO TIMER COUNTER 2 = $004
	.org $008
	rjmp tmpo    ;DESBORDAMIENTO TIMER COUNTER 1 = $008
	rjmp cliente ;DESBORDAMIENTO TIMER COUNTER 0 = $009
	.org $012
	rjmp clr_eepr ; INTERRUPT REQUEST 2
	
main:
;INICIALIZAMOS EL SP
	ldi aux,low(ramend)
	out spl,aux
	ldi aux,high(ramend)
	out sph,aux

;ESTABLECEMOS EL PUERTO A y C COMO SALIDA
	ser aux
	out ddra,aux
	out ddrc,aux
	out ddrd,aux

;HABILITAMOS LOS PULL-UPS DEL PUERTO B
	out portb,aux

;HABILITAMOS LA DETECTION DEL FLANCO DE BAJADA EN EL INT2
	ldi aux,0b01000000
	out mcucsr, aux

	ldi aux, $20
	out gicr,aux

;CARGAREMOS LA PREESCALA AL TCCR0
	ldi aux,6 ; Cargamos la escala a 6 = Detecta el flaco de bajada (Página 85)
	out tccr0,aux

;HABILITAMOS LA INTERRUPCIÓN POR DESBORDAMIENTO DEL TC0, TC1 y DEL TC2
	ldi aux,0b01000101
	out timsk,aux

;HABILITAMOS GLOBALMENTE LAS INTERRUPCIONES
	sei 

;CARGAMOS 1 EN LA MASCARA
	ldi msk,1


;INICIALIZAMOS MANDAMOS AL TCNT0 LA CUENTA PARA EMPEZAR A CONTAR LOS CLIENTES
	ldi aux, 256-6
	out tcnt0, aux

;INICIALIZAMOS T1H Y T1L
	ldi t1h, $B3
	ldi t1l, $B5

	ldi cta_cte, 6
	ldi cta_time, 251

;Leemos lo que hay en la eeprom
	eepr_r $00,$00
	out portd,cta_eepr 

ciclo: ;para perder el tiempo XF
	in aux, tcnt0
	cp aux, cta_time
	breq cuentas
imprime:
	out portc,cta_cte
	rjmp ciclo
	
cuentas:
	clr aux
	cpse cta_cte,aux
	dec cta_cte
	inc cta_time
	rjmp imprime

cliente:

;LEEMOS LO DE LA EEPROM 
	eepr_r $00,$00
	inc cta_eepr

;GUARDAMOS LA CUENTA A LA EEPROM
	eepr_w $00,$00,cta_eepr

	out portd,cta_eepr 
	
;CARGAREMOS LA PREESCALA AL TCCR2
	ldi aux,2 ; Cargamos la escala a 2 QUE se tarda 2048(8*256) ciclos = 2048 micro seg
	out tccr2,aux
	
;INICIALIZAMOS TCNT1 PARA EMPEZAR A CONTAR LOS 5 SEGUNDOS
	out tcnt1h,t1h
	out tcnt1l,t1l

;CARGAREMOS LA PREESCALA AL TCCR1
	ldi aux,4
	out tccr1b,aux

	reti

;TIENE QUE ENTRAR CADA 1150 MICROSEG
onda:
;INICIALIZAMOS y MANDAMOS AL TNCT0 la cuenta de la onda PARA QUE SE TARDE 1150 Micro segundos 
	ldi aux, 256-143 ;(256 ciclos - (1150/8))
	out tcnt2, aux

;LEER EL PUERTO
	in aux,pina

;HACEMOS OR EXCLUSIVA CON EL BIT (PARA EL CAMBIO)
	eor aux, msk

;REGRESAMOS AL PUERTO EL RESULTADO DE LA OR EXCLUSIVA
	out porta,aux
	reti

tmpo:
;RESETEA LOS VALORES DEL TIEMPO Y DE LA SEÑAL PARA MANDAR A CERO LA SEÑAL
	out tcnt1h,t1h
	out tcnt1l,t1l
	ldi aux,0
	out tccr2,aux
	ldi aux,0
	out tccr1b,aux

;RESETEAMOS EL TCNT0 PARA VOLVER A ESPERAR LA CUENTA
	ldi aux, 256-6
	out tcnt0, aux

;RESETEAMOS CTA PARA CONTAR LOS CLIENTES
	ldi cta_cte, 6
	ldi cta_time, 251

	reti

EEPROM_write:
	; Wait for completion of previous write
	sbic EECR,EEWE
	rjmp EEPROM_write
	; Set up address (r18:r17) in address register
	out EEARH, r18
	out EEARL, r17
	; Write data (r16) to Data Register
	out EEDR,r16
	; Write logical one to EEMWE
	sbi EECR,EEMWE
	; Start eeprom write by setting EEWE
	sbi EECR,EEWE
	ret

EEPROM_read:	 
	; Wait for completion of previous write
	sbic EECR,EEWE
	rjmp EEPROM_read
	; Set up address (r18:r17) in Address Register
	out EEARH, r18
	out EEARL, r17
	; Start eeprom read by writing EERE
	sbi EECR,EERE
	; Read data from Data Register
	in r16,EEDR
	ret

clr_eepr:
;RESETEAMOS LA EEPROM, SU VALOR
	clr cta_eepr
	eepr_w $00,$00,cta_eepr
	out portd,cta_eepr 
	reti
