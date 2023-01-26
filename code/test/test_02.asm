BasicUpstart2(start)
        * = $1000 "Main Program"

start:  jsr write_string
        rts

my_string: 
        .text "this is a string"
        .byte 0

write_string: {
        ldx #0
loop:   lda my_string,x
        beq done
        sta $0400,x
        inx
        jmp loop
done:   rts
}
