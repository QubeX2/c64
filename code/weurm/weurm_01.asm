        BasicUpstart2(start)
        *=$1000
        
        #import "../..//_inc/routines.asm"

        .var screenMem = $0400


start:
        lda $dd02
        ora #3
        sta $dd02   // 1 = bit #x in port A can be read and written

        lda $dd00
        ora #%11111100  
        sta $dd00   // select bank 3, $0000-$3fff

        lda #%00010100      // bit 1-3 character memory $1000 rom image
                                // bit 4-7 screen memory $0400-$07ff
        sta $d018
        
        lda #0
        sta $d021
        lda #1
        sta $d020

        ldx #$ff
clr:    lda #$20
        sta $0400,x
        sta $0500,x
        sta $0600,x
        sta $0700,x
        
        lda #$01
        sta $d800,x
        sta $d900,x
        sta $da00,x
        sta $db00,x
        dex
        bne clr

        lda #<screenMem
        sta $fb
        lda #>screenMem
        sta $fc

        lda #<list
        sta $f8
        lda #>list
        sta $f9

        .break
        
main:   lda dir
cmp0:   cmp #0                  // up
        bne cmp1
        lda list + 1
        sec
        sbc #1
        sta list + 1

cmp1:   lda dir
        cmp #1                  // right
        bne cmp2
        lda list
        clc
        adc #1
        sta list

cmp2:   lda dir
        cmp #2                  // down
        bne cmp3
        lda list + 1
        clc
        adc #1
        sta list + 1

cmp3:   lda dir
        cmp #3                  // left
        bne cmpd
        lda list
        sec
        sbc #1
        sta list

cmpd:   
        jsr draw
        //jsr waitRaster
        //jsr waitRaster
        jmp main

draw:   lda list + 2
        ldy list
        ldx list + 1
        sta ($fb), y
        rts

        *=$2000
dir:    .byte 1                 // 0 = up, 1 = right, 2 = down, 3 = left
end:    .byte 1
list:   .fill 256, [0, 0, $51]
