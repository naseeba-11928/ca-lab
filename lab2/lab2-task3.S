main:
    li x22, 0  # i=0

loop1:
    li x24, 10
    beq x22, x24, loop_prep

    slli x25, x22, 2
    addi x25, x25, 0x200
    sw x22, 0(x25)     #a[i]=i

    addi x22, x22, 1
    beq x0, x0, loop1

loop_prep:
    li x22, 0          #i=0
    li x23, 0          #sum=0

loop2:
    li x24, 10
    beq x22, x24, end

    slli x25, x22, 2
    addi x25, x25, 0x200
    lw x26, 0(x25)

    add x23,x23, x26  #sum+=a[i]

    addi x22,x22,1
    beq x0,x0,loop2

end:
    j end