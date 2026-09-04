#Task 1b
main:

    li x22, 1
    li x24, 2
    li x25, 3
    li x10, 4

Loop: slli x10,x22, 2
    add x10, x10, x25
    lw x9, 0(x10)
    bne x9, x24, end
    addi x22, x22, 1
    beq x0, x0, Loop

end:
    j end