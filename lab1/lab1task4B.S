main:

    li x1, 0x100        
    li x2, 0x200       
    li x3, 0x300        

    #i=0
    lb x4, 0(x1)       #a[0]
    lh  x5, 0(x2)       #b[0]
    add x6, x4, x5
    sw  x6, 0(x3)       #c[0]

    #i=1
    lb x4, 1(x1)       #a[1]
    lh  x5, 2(x2)       #b[1]
    add x6, x4, x5
    sw  x6, 4(x3)       #c[1]

    #i=2
    lb x4, 2(x1)       #a[2]
    lh  x5, 4(x2)       #b[2]
    add x6, x4, x5
    sw  x6, 8(x3)       #c[2]

    #i=3
    lb x4, 3(x1)       #a[3]
    lh  x5, 6(x2)       #b[3]
    add x6, x4, x5
    sw x6, 12(x3)

end:
    j end

