BasicUpstart2(start)
        * = $1000 "Main Program"
start:  .break
        inc $d020
        jmp start