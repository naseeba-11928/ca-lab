# Task 2
main:
    li x10, 1  # g
    li x11, 2  # h
    li x12, 3  # i
    li x13, 4  # j
    li sp, 0x200

    addi sp,sp,-16  

    lw x18, 0(sp)
    lw x19, 4(sp)
    lw x20, 8(sp)

    add x18,x10, x11
    add x19,x12, x13
    sub x20,x18, x19

    sw x18,0(sp)
    sw x19,4(sp)
    sw x20,8(sp)

    addi sp, sp, 16

end:
    j end

