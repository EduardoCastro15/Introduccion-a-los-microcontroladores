 .include "m8535def.inc"
 .def aux = r16
 rjmp main
data:
 .db $3f, $06, $5b, $4f, $66, $6d, $7d, $07, $7f, $6f
 .db $77, $7c, $39, $5e, $79, $71, $00 ;Para repedir el ciclo, usamos el $00
main:
 ldi aux, low(RAMEND)
 out spl, aux
 ldi aux, high(RAMEND)
 out sph, aux
 ser aux
 out ddra, aux
otro:
 ldi zh, high(data<<1)
 ldi zl, low(data<<1)
sig:
 lpm aux, z+
 cpi aux, $00
 breq otro
 out porta, aux
 rcall retardo
 rjmp sig
 nop
 nop
retardo:
 ldi  r18, 4
 ldi  r19, 207
 ldi  r20, 2
L1: dec  r20
 brne L1
 dec  r19
 brne L1
 dec  r18
 brne L1
 nop
 nop
 ret
