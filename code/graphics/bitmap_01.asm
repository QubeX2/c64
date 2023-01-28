BasicUpstart2(start)
*=$1000

	.var screenMem = $2000
    .var colorMem = $0400
start:
    // use bank 3
    lda #3
    sta $DD00

	// set to 25 line text mode and turn on the screen
    lda $D011
    ora #%00100000
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

    lda #<colorMem
    sta $f7
    lda #>colorMem
    sta $f8

    // clear clr   
	ldx #$00
loop:
	ldy #$00
	lda #$10
ilop:
	sta ($f7),y
	iny
	bne ilop

	inc $f8
	inx
	cpx #$04
	bne loop

    // clear scr
	ldx #$00
loop2:
	ldy #$00
	lda #$00
ilop2:
	sta ($fb),y
	iny
	bne ilop2

	inc $fc
	inx
	cpx #$20
	bne loop2

	lda #<screenMem
	sta $fb
	lda #>screenMem
	sta $fc

main:
    jmp main

	rts

// A = X, X = Y
writePixel: {
    lda #200    // divide by 8
    lsr
    lsr
    lsr
    tay     // ROW in Y
    txa
    lsr
    lsr
    lsr
    tax     // CHAR in X
    and #7  // LINE


}
