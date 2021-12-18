;
; elevator.asm
;
; Created: 17/12/2021 20:08:04
; Author : Jhonnye
;

.def andar_atual = r16
.def input = r17
.def temp = r18

.equ DelayMs = 5
.equ ClockMHz = 16

jmp reset

delay5ms:

	ldi r22, byte3(ClockMHz*1000*DelayMs/5)
	ldi r21,high(ClockMHz*1000*DelayMs/5)
	ldi r20,low(ClockMHz*1000*DelayMs/5)

	subi r20, 1
	sbci r21, 0
	sbci r22, 0
	brcc pc-3

	ret

check_floor:

	; --------Terceiro-----------
	
	mov temp, input
	andi temp, 0b00001000
	cpi temp, 0b00001000
	breq terceiro_andar

	mov temp, input
	andi temp, 0b10000000
	cpi temp, 0b10000000
	breq terceiro_andar

	; --------Segundo-----------

	mov temp, input
	andi temp, 0b00000100
	cpi temp, 0b00000100
	breq segundo_andar

	mov temp, input
	andi temp, 0b01000000
	cpi temp, 0b01000000
	breq segundo_andar

	; --------Primeiro-----------

	mov temp, input
	andi temp, 0b00000010
	cpi temp, 0b00000010
	breq primeiro_andar

	mov temp, input
	andi temp, 0b00100000
	cpi temp, 0b00100000
	breq primeiro_andar

	; --------Térreo-----------

	mov temp, input
	andi temp, 0b00000001
	cpi temp, 0b00000001
	breq terreo

	mov temp, input
	andi temp, 0b00010000
	cpi temp, 0b00010000
	breq terreo

	rjmp loop

reset:
	ldi temp, $FF
	out DDRC, temp

    ldi temp, 0b00000000
	out DDRB, temp

	ldi temp, 0b00000011
	out DDRD, temp

	ldi temp, 0b00001000
	out PORTD, temp

	rjmp loop

terceiro_andar:

	ldi andar_atual, 3
	out PORTC, andar_atual
	rjmp parado
	
segundo_andar:

	ldi andar_atual, 2
	out PORTC, andar_atual
	rjmp parado
	
primeiro_andar:

	ldi andar_atual, 1
	out PORTC, andar_atual
	rjmp parado
	
terreo:

	ldi andar_atual, 0
	out PORTC, andar_atual
	rjmp parado

parado:
	
	rcall delay5ms
	ldi temp, 0b00000101
	out PORTD, temp

	rcall delay5ms
	ldi temp, 0b00000110
	out PORTD, temp

	rcall delay5ms
	ldi temp, 0b00001000
	out PORTD, temp

	rjmp loop

loop:

	in input, PINB
	jmp check_floor
	rjmp loop
