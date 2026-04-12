.section .data
fmt: .string "%d "
fmt2: .string "%d\n"

.section .text
.globl main
#s0=n
#s1=arr
#s2=ans
#s3=stack
#s4=stack top
#s5=argv
#s6=char_to_int lopp index
#s7=print loop index
main:
    addi sp,sp,-80
    sd ra,72(sp) #store return address
    sd s0,64(sp) #store all the long term values on stack as well as the s registers just to be safe.
    sd s1,56(sp)
    sd s2,48(sp)
    sd s3,40(sp)
    sd s4,32(sp)
    sd s5,24(sp)
    sd s6,16(sp)
    sd s7,8(sp)

    mv t0,a0 #argc
    mv s5,a1 #argv

    addi t0,t0,-1 #n=argc-1
    mv s0,t0 #s0=n

    slli a0,s0,2
    call malloc
    mv s1,a0 #pointer to arr where we store the int values

    slli a0,s0,2
    call malloc
    mv s2,a0 #pointer to ans

    slli a0,s0,2
    call malloc
    mv s3,a0 #pointer to stack

    li s6,1 # t2 i=1
    j char_to_int

#t2=i
char_to_int:
    bgt s6,s0,char_to_int_done #if i>=n done

    slli t3,s6,3 #i*8
    add t3,t3,s5 #get address of element
    ld a0,0(t3) #argv[i] loaded

    call atoi

    addi t4,s6,-1 #t4=i-1
    slli t4,t4,2 #t4*4 as int is 4 bytes
    add t4,s1,t4
    sw a0,0(t4)

    addi s6,s6,1 #i++
    j char_to_int

char_to_int_done:
    li s4,-1 #stack-top=-1
    addi t0,s0,-1 #i=n-1
    j nge_loop

#t0=i=n-1
nge_loop:
    blt t0,x0,nge_done

    j pop

pop:
    blt s4,x0,pop_done #stack is empty

    slli t1,s4,2
    add t1,s3,t1
    lw t2,0(t1) # stack[top]

    slli t3,t2,2
    add t3,s1,t3
    lw t3,0(t3) #arr[stack[top]]

    slli t4,t0,2
    add t4,s1,t4
    lw t4,0(t4) #arr[i]

    bgt t3,t4,pop_done #3nd condition not satisfied

    addi s4,s4,-1 #stack top pointer--
    j pop

pop_done:
    slli t5,t0,2
    add t5,s2,t5 #get address for ans[i]

    blt s4,x0,noanswer

    slli t1,s4,2 #ans[i]=stack[top]
    add t1,s3,t1 #got stack[top]
    lw t2,0(t1)

    sw t2,0(t5)
    j push

noanswer:
    li t6,-1
    sw t6,0(t5)

push:
    addi s4,s4,1 #top++
    slli t1,s4,2
    add t1,s3,t1
    sw t0,0(t1) #store index on stack

    addi t0,t0,-1
    j nge_loop

nge_done:
    li s7,0
    j print

print:
    bge s7,s0,print_done

    slli t1,s7,2
    add t1,s2,t1
    lw a1,0(t1)

    addi t2,s0,-1
    beq s7,t2,last

    la a0,fmt
    call printf

    addi s7,s7,1
    j print

last:
    la a0,fmt2
    call printf

    addi s7,s7,1
    j print

print_done:
    li a0,0
    ld s7,8(sp)
    ld s6,16(sp)
    ld s5,24(sp)
    ld s4,32(sp)
    ld s3,40(sp)
    ld s2,48(sp)
    ld s1,56(sp)
    ld s0,64(sp)
    ld ra,72(sp)
    addi sp,sp,80
    ret
