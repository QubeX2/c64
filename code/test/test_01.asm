BasicUpstart2(start)
        * = $1000 "Main Program"

        .var d = $D000

start:  lda #$0D    // sprite pointers        
        sta $7F8
        
        ldx #62     // sprite data
        lda #$ff
loop:   sta $340,x
        dex
        bpl loop

        lda #1      
        ldy #21
        sta d,y     //enable sprite 1
        ldy #39
        sta d,y     //set sprite 0 color

        lda #100
        ldy #1
        sta d,y     //set sprite 0 y pos

        lda #0      // sprite 0 x pos
        ldy #16
        sta d,y

        lda #50
        sta d

        jmp start
