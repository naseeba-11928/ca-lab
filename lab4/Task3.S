main:
    li x10, 0x200
    li x5, 3
    sw x5, 0(x10)     # a[0]= 3
    li x5, 2
    sw x5, 4(x10)     # a[1]= 2
    li x5, 1
    sw x5, 8(x10)     # a[2]= 1
    li x5, 4
    sw x5, 12(x10)    # a[3]= 4
    li x5, 5
    sw x5, 16(x10)    # a[4]= 5
    li x10, 0x200
    li x11, 5
    jal x1, bubble   # bubble(array, 5)
    j end

bubble:   # if (a==NULL ||len==0)
    beq x10, x0, done     # if a==NULL, return
    beq x11, x0, done     # if len==0, return
    li x5, 0

outer:
    bge x5, x11, done  # if (i>=len), finish
    addi x6, x5, 0  # j=i

inner:
    bge x6, x11, next_i  # if (j>=len), go to next i

    # for i
    slli x28, x5, 2        # x28=i*4
    add x28, x10, x28      # x28=address of a[i]
    lw x30, 0(x28)         # x30=a[i]

    # for j
    slli x29, x6, 2        # x29=j*4
    add x29, x10, x29      # x29=address of a[j]
    lw x31, 0(x29)         # x31=a[j]

    bge x30, x31, no_swap  # if a[i]>=a[j], no swap

    addi x7, x30, 0        # temp=a[i]
    sw x31, 0(x28)         # a[i]=a[j]
    sw x7, 0(x29)          # a[j]=temp

no_swap:
    addi x6, x6, 1        # j++
    j inner

next_i:
    addi x5, x5, 1        # i++
    j outer

done:
    jalr x0, 0(x1)        # return

end:
    j end
