main:
    li x22, 0  # i

loop1:
    li x24, 10         # x24 = 10
    beq x22, x24, sum   # if i == 10, go to second loop

    slli x25, x22, 2         # x25 = i * 4
    addi x25, x25, 0x200     # x25 = address of a[i]
    sw x22, 0(x25)           # a[i] = i

    addi x22, x22, 1         # i = i + 1
    beq x0, x0, loop1        # go back to Loop1


sum:
    # second loop: sum = sum + a[i]
    li x22, 0          # i = 0
    li x23, 0          # sum = 0

Loop2:
    li x24 10         # x24 = 10
    beq x22, x24, Exit       # if i == 10, exit

    slli x25, x22, 2         # x25 = i * 4
    addi x25, x25, 0x200     # x25 = address of a[i]
    lw x26, 0(x25)           # x26 = a[i]

    add x23, x23, x26        # sum = sum + a[i]

    addi x22, x22, 1         # i = i + 1
    beq x0, x0, Loop2        # go back to Loop2

Exit:

end:
    j end