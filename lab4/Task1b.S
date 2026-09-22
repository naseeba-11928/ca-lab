main:
    li x10, 5    # n=5
    jal x1, fact          
    addi x11, x10, 0    
    li x10, 1    # print integer
    ecall
    j end

fact:
    li x6, 1       # acc = 1

L1:
    bge  x0, x10, L2      # if n <= 0, go to L2

    mul  x6, x6, x10      # acc = acc * n
    addi x10, x10, -1     # n = n - 1
    jal  x0, L1           # repeat loop

L2:
    addi x10, x6, 0       # return acc
    jalr x0, 0(x1)        # return

end: j end


