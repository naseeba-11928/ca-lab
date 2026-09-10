# Task 3
main:
    li x10, 0x200  # k
    li x11, 1      # v

    # array initialization
    # v=[10,20,30]
    li x5, 10    
    sw x5, 0(x10) 
    li x5, 20
    sw x5, 4(x10)
    li x5, 30
    sw x5, 8(x10)

swap:
    slli x6, x11, 2 #shifts twice
    add  x6, x10, x6 #(baseadd+offset)

    lw   x5, 0(x6)  #v[k] 
    lw   x7, 4(x6)  #x7=v[k+1] (k+1 being the next address)

    sw   x7, 0(x6)  #v[k]=v[k+1]
    sw   x5, 4(x6)  #v[k+1]=x5 (used as temp stored the value of v[k])

end: 
    j end