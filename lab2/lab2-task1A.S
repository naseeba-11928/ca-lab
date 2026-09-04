# Task 1a
main:
    li x19, 0
    li x20, 1
    li x21, 2
    li x22, 3
    li x23, 4

    bne x22, x23, Else
    add x19, x20, x21
    beq x0, x0, end
Else: sub x19, x20, x21

end:
    j end



