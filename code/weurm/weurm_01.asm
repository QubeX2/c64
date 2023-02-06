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
clrs:   lda #$20
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
        bne clrs
        
main:   
        ldx #$20        // space (32)
        jsr draw
        
// ---------------------------------------------------------------
// MOVE
// ---------------------------------------------------------------
        lda #<list
        sta $f7
        lda #>list
        sta $f8
        
        lda dir
cmp0:   cmp #0                  // up
        bne cmp1
        ldy #1
        lda ($f7),y
        sec
        sbc #1
        sta ($f7),y

cmp1:   lda dir
        cmp #1                  // right
        bne cmp2
        ldy #0
        lda ($f7),y
        clc
        adc #1
        sta ($f7),y

cmp2:   lda dir
        cmp #2                  // down
        bne cmp3
        ldy #1
        lda ($f7),y
        clc
        adc #1
        sta ($f7),y

cmp3:   lda dir
        cmp #3                  // left
        bne cmpd
        ldy #0
        lda ($f7),y
        sec
        sbc #1
        sta ($f7),y

cmpd:   ldx #$51
        jsr draw
        ldx #$10
wr:     jsr waitRaster
        jsr key
        dex
        bne wr
        jmp main

// ---------------------------------------------------------------
// DRAW
// ---------------------------------------------------------------
draw:   lda #<screenMem         // lsb
        sta $fb                 // 00
        lda #>screenMem         // msb
        sta $fc                 // 04

        ldy list + 1            // y-coord
        beq col
row:    lda $fb
        clc
        adc #40
        sta $fb
        bcc row2
        inc $fc                 // inc y if carry
row2:   dey                     // loop add #40
        bne row        

col:    lda $fb
        clc
        adc list
        sta $fb
        bcc d
        inc $fc        

d:      ldy #0
        txa
        sta ($fb), y 
        rts

// ---------------------------------------------------------------
// KEY
// ---------------------------------------------------------------
key:    lda $c5
        cmp #$12        // d
        bne key1
        ldy #1
        sty dir

key1:   cmp #$0d        // s
        bne key2
        ldy #2
        sty dir

key2:   cmp #$0a        // a
        bne key3
        ldy #3
        sty dir

key3:   cmp #$09        // w
        bne keyd
        ldy #0
        sty dir
keyd:   rts


        *=$2000
dir:    .byte 2                 // 0 = up, 1 = right, 2 = down, 3 = left
end:    .byte 1
list:   .fill 256, [0, 0]
