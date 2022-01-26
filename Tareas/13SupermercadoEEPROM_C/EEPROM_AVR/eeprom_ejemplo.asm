	.include"m8535def.inc"
	.def dato = r16
	.def dirl = r17
	.def dirh = r18
	.def aux  = r19
	.macro eepr_w
		ldi dirh,@0  ;para leer el contenido del registro seria mov
		ldi dirl,@1
		ldi dato,@2
		rcall EEPROM_write
	.endm
	.macro eepr_r
		ldi dirh,@0
		ldi dirl,@1
		rcall EEPROM_read
	.endm
reset:
	ldi aux, low(ramend)
	out spl, aux
	ldi aux, high(ramend)
	out sph, aux
	eepr_w $00,$00,$05 ;se puede poner un registro, pero en vez de ldi sería mov
	eepr_w $00,$01,$07
	eepr_r $00,$00
	mov aux, dato
fin:
	rjmp fin

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

;CÓDIGO ANTES DE LAS MACROS XF
	;ldi aux,5
	;mov dato,aux ;copio el valor a "dato"
	;clr dirh
	;clr dirl
	;rcall EEPROM_write
	;inc dato
	;inc dirl
	;rcall EEPROM_write
	;clr dirl
	;rcall EEPROM_read
