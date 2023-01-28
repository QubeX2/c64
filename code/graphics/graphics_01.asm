BasicUpstart2(start)
*=$1000

	.var screenMem = $0400

start:
	// set to 25 line text mode and turn on the screen
	lda #$1B        // %00010000 
	sta $D011

	// disable SHIFT-Commodore  
	lda #$80
	sta $0291

	// set screen memory ($0400) and charset bitmap offset ($2000)
	lda #%00011000
	sta $D018

	// set border color
	lda #$0E
	sta $D020
	
	// set background color
	lda #$00
	sta $D021

	.break

	lda #<screenMem
	sta $fb
	lda #>screenMem
	sta $fc

	ldx #$00
loop:
	ldy #$00
ilop:
	lda #$00
	sta ($fb),y
	iny
	bne ilop

	inc $fc

	inx
	cpx #$04
	bne loop

main:
    jmp main

	rts




*=$2000

    .byte %11111111,%10000000,%10000000,%10000000,%10000000,%10000000,%10000000,%10000000
    .byte %11111111,%11111111,%11111111,%11111111,%11111111,%11111111,%11111111,%11111111