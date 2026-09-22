# for printing the disk shift
.data
msg1: .asciiz "Move disk "
msg2: .asciiz ": "
msg3: .asciiz " to "
newline: .asciiz "\n"
.text
.globl main

main:
    li x10, 3  # disks=3
    li x11, 1  # source rod 1
    li x12, 2  # auxiliary rod 2
    li x13, 3  # destination rod 3
    
    jal x1, hanoi # calling "tower of hanoi"

    li x10, 10
    ecall

# parameters:
# x10 = disk
# x11 = source
# x12 = auxiliary
# x13 = destination

hanoi:
    addi sp, sp, -20
    sw x10, 0(sp)       # store no. of disks
    sw x11, 4(sp)       # store source
    sw x12, 8(sp)       # store auxiliary
    sw x13, 12(sp)      # store destination
    sw x1, 16(sp)       # store return address

    li x5, 1
    beq x10, x5, base  #if n == 1, move disk directly

    # first recursive call
    addi x10, x10, -1   #disk-1
    lw x12, 12(sp)
    lw x13, 8(sp)

    jal x1, hanoi

    # restore original values
    lw x10, 0(sp)
    lw x11, 4(sp)
    lw x12, 8(sp)
    lw x13, 12(sp)

# printing tasks
    li x10, 4    # "Move disk "
    la x11, msg1
    ecall

    lw x11, 0(sp)   # disk number
    li x10, 1
    ecall

    li x10, 4     # ": "
    la x11, msg2
    ecall

    lw x11, 4(sp)    # source rod
    li x10, 1
    ecall

    li x10, 4        # " to "
    la x11, msg3
    ecall

    lw x11, 12(sp)   # destination rod
    li x10, 1
    ecall

    li x10, 4           # newline
    la x11, newline
    ecall

# second recursive call
    lw x10, 0(sp)
    addi x10, x10, -1

    lw x11, 8(sp)  # source=old auxiliary
    lw x12, 4(sp)  # auxiliary=old source
    lw x13, 12(sp) # destination stays the same

    jal x1, hanoi

    lw x1, 16(sp)  #restore return address
    addi sp, sp, 20
    jalr x0, 0(x1)  # return


base:
# printing tasks
    li x10, 4    # "Move disk "
    la x11, msg1
    ecall

    lw x11, 0(sp)   # disk number
    li x10, 1
    ecall

    li x10, 4     # ": "
    la x11, msg2
    ecall

    lw x11, 4(sp)    # source rod
    li x10, 1
    ecall

    li x10, 4        # " to "
    la x11, msg3
    ecall

    lw x11, 12(sp)   # destination rod
    li x10, 1
    ecall

    li x10, 4           # newline
    la x11, newline
    ecall

    lw x1, 16(sp)  #restore return address
    addi sp, sp, 20
    jalr x0, 0(x1)

