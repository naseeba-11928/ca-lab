# Task 4
main:
    li x10, 0x200     #x 
    li x11, 0x210     #y 
    li x19, 0         #i 

    li x28, 99    #    c
    sw x28, 0(x11)
    li x28, 111   #    o
    sw x28, 1(x11)
    li x28, 112   #    p
    sw x28, 2(x11)
    li x28, 121   #    y
    sw x28, 3(x11)
    li x28, 0     #    /0
    sw x28, 4(x11)


loop_strcpy:
    add x5, x19, x11  # address of y[i+offset(x19)]
    lbu x6, 0(x5)     # x6=y[i]

    add x7, x19, x10  # address of x[i+offset(x19)]
    sb x6, 0(x7)      # x[i]=y[i]

    beq x6, x0, end   # if y[i]=='\0', end

    addi x19, x19, 1  # i++
    j loop_strcpy     # repeat

end:
    j end