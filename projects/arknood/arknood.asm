    BasicUpstart2(start)
    *=$1000

    #import "../..//_inc/routines.asm"

start:
    lda #147
    jsr $ffd2

    lda $dd02
    ora #3
    sta $dd02   // 1 = bit #x in port A can be read and written

    lda $dd00
    ora #%11111100  
    sta $dd00   // select bank 3, $0000-$3fff

    lda #%00010100      // bit 1-3 character memory $1000 rom image
                        // bit 4-7 screen memory $0400-$07ff
    sta $d018
    


main:
    jmp main
	rts

