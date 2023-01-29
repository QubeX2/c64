BasicUpstart2(start)
*=$1000

    #import "../..//_inc/routines.asm"

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

    lda #0
    sta $fc         // y
    sta $fb         // xhi
    sta $fa         // xlow

main:
    jsr writePixel
    lda $fa
    clc
    adc #1
    sta $fa
    bcc c1
    lda $fb
    clc
    //adc #1
    sta $fb
    inc $fc
c1: jsr waitRaster

    jmp main
	rts

    // x = ($fa, $fb), y = $fc
writePixel: {
    ldy $fc            // $fc = y
    lda tl,y
    sta $fe
    lda th,y           // $fe,$ff = 8192+int(y/8)*320+(y and 7)
    clc
    adc $fb            // $fb = xh
    sta $ff
    ldx $fa            // $fa = xl
    lda power2,x       // reg_a = 2^(7-(x and 7))
    ldy xtable,x       // reg_y = int(x/8)*8
    ora ($fe),y
    sta ($fe),y
    rts
}

tl:
    .byte $00,$01,$02,$03,$04,$05,$06,$07,$40,$41,$42,$43,$44,$45,$46,$47
    .byte $80,$81,$82,$83,$84,$85,$86,$87,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7
    .byte $00,$01,$02,$03,$04,$05,$06,$07,$40,$41,$42,$43,$44,$45,$46,$47
    .byte $80,$81,$82,$83,$84,$85,$86,$87,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7
    .byte $00,$01,$02,$03,$04,$05,$06,$07,$40,$41,$42,$43,$44,$45,$46,$47
    .byte $80,$81,$82,$83,$84,$85,$86,$87,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7
    .byte $00,$01,$02,$03,$04,$05,$06,$07,$40,$41,$42,$43,$44,$45,$46,$47
    .byte $80,$81,$82,$83,$84,$85,$86,$87,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7
    .byte $00,$01,$02,$03,$04,$05,$06,$07,$40,$41,$42,$43,$44,$45,$46,$47
    .byte $80,$81,$82,$83,$84,$85,$86,$87,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7
    .byte $00,$01,$02,$03,$04,$05,$06,$07,$40,$41,$42,$43,$44,$45,$46,$47
    .byte $80,$81,$82,$83,$84,$85,$86,$87,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7
    .byte $00,$01,$02,$03,$04,$05,$06,$07

th:
    .byte $20,$20,$20,$20,$20,$20,$20,$20,$21,$21,$21,$21,$21,$21,$21,$21
    .byte $22,$22,$22,$22,$22,$22,$22,$22,$23,$23,$23,$23,$23,$23,$23,$23
    .byte $25,$25,$25,$25,$25,$25,$25,$25,$26,$26,$26,$26,$26,$26,$26,$26
    .byte $27,$27,$27,$27,$27,$27,$27,$27,$28,$28,$28,$28,$28,$28,$28,$28
    .byte $2a,$2a,$2a,$2a,$2a,$2a,$2a,$2a,$2b,$2b,$2b,$2b,$2b,$2b,$2b,$2b
    .byte $2c,$2c,$2c,$2c,$2c,$2c,$2c,$2c,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d
    .byte $2f,$2f,$2f,$2f,$2f,$2f,$2f,$2f,$30,$30,$30,$30,$30,$30,$30,$30
    .byte $31,$31,$31,$31,$31,$31,$31,$31,$32,$32,$32,$32,$32,$32,$32,$32
    .byte $34,$34,$34,$34,$34,$34,$34,$34,$35,$35,$35,$35,$35,$35,$35,$35
    .byte $36,$36,$36,$36,$36,$36,$36,$36,$37,$37,$37,$37,$37,$37,$37,$37
    .byte $39,$39,$39,$39,$39,$39,$39,$39,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a
    .byte $3b,$3b,$3b,$3b,$3b,$3b,$3b,$3b,$3c,$3c,$3c,$3c,$3c,$3c,$3c,$3c
    .byte $3e,$3e,$3e,$3e,$3e,$3e,$3e,$3e

power2:
    .byte $80,$40,$20,$10,$08,$04,$02,$01,$80,$40,$20,$10,$08,$04,$02,$01
    .byte $80,$40,$20,$10,$08,$04,$02,$01,$80,$40,$20,$10,$08,$04,$02,$01
    .byte $80,$40,$20,$10,$08,$04,$02,$01,$80,$40,$20,$10,$08,$04,$02,$01
    .byte $80,$40,$20,$10,$08,$04,$02,$01,$80,$40,$20,$10,$08,$04,$02,$01
    .byte $80,$40,$20,$10,$08,$04,$02,$01,$80,$40,$20,$10,$08,$04,$02,$01
    .byte $80,$40,$20,$10,$08,$04,$02,$01,$80,$40,$20,$10,$08,$04,$02,$01
    .byte $80,$40,$20,$10,$08,$04,$02,$01,$80,$40,$20,$10,$08,$04,$02,$01
    .byte $80,$40,$20,$10,$08,$04,$02,$01,$80,$40,$20,$10,$08,$04,$02,$01
    .byte $80,$40,$20,$10,$08,$04,$02,$01,$80,$40,$20,$10,$08,$04,$02,$01
    .byte $80,$40,$20,$10,$08,$04,$02,$01,$80,$40,$20,$10,$08,$04,$02,$01
    .byte $80,$40,$20,$10,$08,$04,$02,$01,$80,$40,$20,$10,$08,$04,$02,$01
    .byte $80,$40,$20,$10,$08,$04,$02,$01,$80,$40,$20,$10,$08,$04,$02,$01
    .byte $80,$40,$20,$10,$08,$04,$02,$01,$80,$40,$20,$10,$08,$04,$02,$01
    .byte $80,$40,$20,$10,$08,$04,$02,$01,$80,$40,$20,$10,$08,$04,$02,$01
    .byte $80,$40,$20,$10,$08,$04,$02,$01,$80,$40,$20,$10,$08,$04,$02,$01
    .byte $80,$40,$20,$10,$08,$04,$02,$01,$80,$40,$20,$10,$08,$04,$02,$01

xtable:
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$08,$08,$08,$08,$08,$08,$08,$08
    .byte $10,$10,$10,$10,$10,$10,$10,$10,$18,$18,$18,$18,$18,$18,$18,$18
    .byte $20,$20,$20,$20,$20,$20,$20,$20,$28,$28,$28,$28,$28,$28,$28,$28
    .byte $30,$30,$30,$30,$30,$30,$30,$30,$38,$38,$38,$38,$38,$38,$38,$38
    .byte $40,$40,$40,$40,$40,$40,$40,$40,$48,$48,$48,$48,$48,$48,$48,$48
    .byte $50,$50,$50,$50,$50,$50,$50,$50,$58,$58,$58,$58,$58,$58,$58,$58
    .byte $60,$60,$60,$60,$60,$60,$60,$60,$68,$68,$68,$68,$68,$68,$68,$68
    .byte $70,$70,$70,$70,$70,$70,$70,$70,$78,$78,$78,$78,$78,$78,$78,$78
    .byte $80,$80,$80,$80,$80,$80,$80,$80,$88,$88,$88,$88,$88,$88,$88,$88
    .byte $90,$90,$90,$90,$90,$90,$90,$90,$98,$98,$98,$98,$98,$98,$98,$98
    .byte $a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a8,$a8,$a8,$a8,$a8,$a8,$a8,$a8
    .byte $b0,$b0,$b0,$b0,$b0,$b0,$b0,$b0,$b8,$b8,$b8,$b8,$b8,$b8,$b8,$b8
    .byte $c0,$c0,$c0,$c0,$c0,$c0,$c0,$c0,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8
    .byte $d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d8,$d8,$d8,$d8,$d8,$d8,$d8,$d8
    .byte $e0,$e0,$e0,$e0,$e0,$e0,$e0,$e0,$e8,$e8,$e8,$e8,$e8,$e8,$e8,$e8
    .byte $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0,$f8,$f8,$f8,$f8,$f8,$f8,$f8,$f8

