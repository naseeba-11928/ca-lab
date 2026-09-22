main:
    li x10, 5    # n=5
    jal x1, fact          
    addi x11, x10, 0    
    li x10, 1    # print integer
    ecall
    j end

fact:
    addi sp, sp,-8 # adjust stack for 2 items
    sw x1, 4(sp) # save return address
    sw x10, 0(sp) # save argument n

    addi x5, x10,-1 # x5 = n-1
    blt x0, x5, L1 # if (n-1) >= 0, go to L1

    addi x10, x0, 1 # return 1
    addi sp, sp, 8 # pop stack
    jalr x0, 0(x1) # return

L1:
    addi x10, x10,-1 # argument = n-1
    jal x1, fact # recursive call
    
    addi x6, x10, 0 # save result of fact(n-1)
    lw x10, 0(sp) # restore original n
    lw x1, 4(sp) # restore return address
    addi sp, sp, 8 # pop stack

    add x10, x10, x6 # n + fact(n-1)
    jalr x0, 0(x1) # return

end:
    j end