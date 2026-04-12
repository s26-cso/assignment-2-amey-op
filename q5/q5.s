.section .data
filename: .string "input.txt"
mode: .string "r"
yesmsg: .string "Yes\n"
nomsg: .string "No\n"

.section .text
.globl main

main:
    addi sp,sp,-32
    sd ra,24(sp) #store return address

#--------------fopen----------------
    la a0,filename
    la a1,mode
    call fopen
    mv s0,a0 #file pointer

#--------------fseek----------------
    mv a0,s0
    li a1,0 #0=seek set, 1=seek curr, 2=seek end
    li a2,2
    call fseek

#--------------ftell----------------
    mv a0,s0
    call ftell
    mv s1,a0 #size of file

    li s2,0 #left pointer=0
    addi s3,s1,-1 #right pointer=size-1

#--------------pointer back to start----------------  
    mv a0,s0
    li a1,0
    li a2,0
    call fseek



loop:
    bge s2,s3,yes #left>right

#--------------left----------------
    mv a0,s0
    mv a1,s2
    li a2,0
    call fseek #0 ahead of left pointer so basically set to left pointer

    addi sp,sp,-8 #to store the char
    mv a0,sp
    li a1,1 #size of each item
    li a2,1 #no of items
    mv a3,s0 #file pointer
    call fread
    

#--------------right----------------
    mv a0,s0
    mv a1,s3 #right instead of left
    li a2,0
    call fseek

    addi a0,sp,1
    li a1,1
    li a2,1
    mv a3,s0
    call fread
    

#--------------check----------------
    lb t0,0(sp)
    lb t1,1(sp)
    addi sp,sp,8
    bne t0,t1,no #if not equal
    addi s2,s2,1 #left pointer++
    addi s3,s3,-1 #right pointer--
    j loop

yes:
    la a0,yesmsg
    call printf
    j exit

no:
    la a0,nomsg
    call printf
    j exit

exit:
    mv a0,s0
    call fclose
    ld ra,24(sp) #take the return address
    addi sp,sp,32 #restore stack
    ret
