main:
    li x20, 4  # x
    li x22, 6  # b
    li x23, 4  # c

    li x7, 1
    beq x20, x7, Case1

    li x7, 2
    beq x20, x7, Case2

    li x7, 3
    beq x20, x7, Case3

    li x7, 4
    beq x20, x7, Case4

    beq x0, x0, default

Case1:
    add x21,x22,x23  #b+c
    beq x0, x0, Exit

Case2:
    sub x21,x22,x23  #b-c
    beq x0, x0, Exit

Case3:
    slli x21,x22,2   # shifts left (multiplies)
    beq x0, x0, Exit

Case4:
    srai x21,x22,2   #shifts right (divides)
    beq x0, x0, Exit

default:
    li x21,0

Exit:

end:
    j end