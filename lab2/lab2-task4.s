main:
    li x10, 0x200
    li x5, 4  #a
    li x6, 3  #b
    li x7, 0  #i

loop_main:
    beq  x7, x5, end   #if i==a
    li   x29, 0  #j=0

loop_nest:
    beq  x29, x6, increment_i # if j==b
    add  x11,x7,x29 # i+j
    slli x12, x29, 4   #j*16
    add  x12, x10, x12  #address of D[4*j]

    sw   x11, 0(x12)  # D[4*j]=i+j

    addi x29, x29, 1  # j++

    j loop_nest

increment_i:
    addi x7, x7, 1   # i++
    j loop_main

end:
    j end













# main:
    # li x10, 0x200
    # li x5, 3  #a
    # li x6, 2  #b
    # li x7, 0  #i
    # li x29, 0  #j

# loop_main:
#     beq x7,x5, end

# loop_nest:
#     beq x29, x6, increment_i
    
#     add x11, x7,x29  #i+j
#     slli x12,x29,4 # (j*4)*4(offset)
#     add x12,x10,x12 # 0x200 + (j*4)*4(offset)
#     sw x11,0(x12)  # D[4*j]=i+j

#     addi x29,x29,1
#     bne x29,x6,loop_nest

# increment_i:
#     addi x7,x7,1
#     bne x7,x5,loop_main

# end:
#     j end