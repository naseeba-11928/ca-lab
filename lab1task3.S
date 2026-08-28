main:
    li x1, 5   #a=5
    li x2, 0   #b=0
    li x3, 0   #d=0
    li x4, 5
    
    addi x2,x2,0 # 0+0=b

    addi x1,x2,32  # a=b+32=32

    add x3,x1,x2  #x3 
    
    sub x3,x3,x4 # d=(a=b)-5

    sub x5,x1,x3 # a-d
    sub x6,x2,x1 #b-a
    add x7,x5,x6 #e=(a-d)+(b-a)
    add x7,x7,x3 #e=(a-d)+(b-a)+d

    add x8, x1, x2    # x8=a+b
    add x8, x8, x3    # x8=a+b+d
    add x7, x8, x7    # e=a+b+d+e

end:
    j end