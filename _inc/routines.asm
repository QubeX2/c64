waitRaster: {
wait:
    lda $d012
    cmp #$ff
    bne wait
    rts    
}