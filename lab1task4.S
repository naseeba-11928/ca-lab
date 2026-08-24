main:
    li x10, 0x78786464
    li x11, 0xA8A81919

    li x1, 0x100
    li x2, 0x1F0

    sw x10, 0(x1)
    sw x11, 0(x2)

    lhu x12, 0(x1)
    lh x13,0(x1)
    lb x14, 0(x2)



end:
    j end