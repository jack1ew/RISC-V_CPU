# 18 bit binary to 6 digit decimal 32 fractional bits
#li x1, 765432
csrrw x1, 0xf00, x0
lui x2, 0
lui x3, 0x19999
lui x8, 0x99A
srli x8, x8, 12
or x3, x3, x8
lui x4, 10
srli x4, x4, 12

mul x7,x1,x3
mulhu x1, x1, x3
mulhu x7, x7, x4

or x2, x2, x7

mul x7,x1,x3
mulhu x1, x1, x3
mulhu x7, x7, x4
slli x7, x7, 4

or x2, x2, x7

mul x7,x1,x3
mulhu x1, x1, x3
mulhu x7, x7, x4
slli x7, x7, 8

or x2, x2, x7

mul x7,x1,x3
mulhu x1, x1, x3
mulhu x7, x7, x4
slli x7, x7,12

or x2, x2, x7

mul x7,x1,x3
mulhu x1, x1, x3
mulhu x7, x7, x4
slli x7, x7,16

or x2, x2, x7

mul x7,x1,x3
mulhu x1, x1, x3
mulhu x7, x7, x4
slli x7, x7, 20

or x2, x2, x7

csrrw x0,0xf02,x2
