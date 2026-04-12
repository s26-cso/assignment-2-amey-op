.section .text
.globl make_node
.globl insert
.globl get
.globl getAtMost
#value:0
#left:8
#right:16
#----------------------make_node----------------------
make_node:
    addi sp,sp,-16
    sd ra,8(sp) #store return address
    sd a0,0(sp) #save value

    li a0,24
    call malloc #total 24 bytes for 3 things: left,right and value

    mv t0,a0
    ld t1,0(sp)

    sw t1,0(t0) #node->val=val;
    sd zero,8(t0) #node->left=NULL;
    sd zero,16(t0) #node->right=NULL;

    mv a0,t0

    ld ra,8(sp) #load return address
    addi sp,sp,16 #reset stack
    ret

#----------------------insert----------------------
insert:
    addi sp,sp,-24
    sd ra,16(sp) #store return address
    sd s0,8(sp) #save root
    sd s1,0(sp) #save val
    mv s0,a0
    mv s1,a1

    beq a0,x0,insert_new #if root==NULL create root

    lw t0,0(a0)

    blt a1,t0,go_left #node->val>val go left
    bgt a1,t0,go_right #node->val<val go right
    mv a0,s0 #equal so we found the node
    j insert_done

go_left:
    ld t1,8(a0) #get the left pointer

    mv a0,t1 #get to left node
    mv a1,s1
    call insert

    sd a0,8(s0) #parent->left=returned node
    mv a0,s0 #parent as return
    j insert_done

go_right:
    ld t1,16(a0) #get the right pointer

    mv a0,t1 #get to right node
    mv a1,s1
    call insert

    sd a0,16(s0) #parent->right=returned node
    mv a0,s0 #parent as return
    j insert_done

insert_new:
    mv a0,s1
    call make_node

insert_done:
    ld s1,0(sp) #load val
    ld s0,8(sp) #load root
    ld ra,16(sp) #load return address
    addi sp,sp,24 #reset stack
    ret

#----------------------get----------------------
get:
    addi sp,sp,-16
    sd ra,8(sp) #store return address
    sd s0,0(sp) #save root
    mv s0,a0
    beq a0,x0,get_null #root==NULL

    lw t0,0(a0)

    beq t0,a1,get_found #found
    blt a1,t0,get_left #get left

    ld a0,16(a0) #get right
    call get
    j get_done

get_left:
    ld a0,8(a0) #shift to left
    call get
    j get_done

get_found:
    mv a0,s0
    j get_done

get_null:
    li a0,0 #store 0

get_done:
    ld s0,0(sp) #load root
    ld ra,8(sp) #load return address
    addi sp,sp,16 #reset stack
    ret


#----------------------getAtMost----------------------
getAtMost:
    addi sp,sp,-24
    sd ra,16(sp) #store return address
    sd s0,8(sp) #save val
    sd s1,0(sp) #save current answer
    mv s0,a0
    beq a1,x0,noanswer

    lw t0,0(a1)

    bgt t0,a0,go_left2 #node->val>val

    mv s1,t0 #possible ans

    ld a1,16(a1) #go right
    mv a0,s0
    call getAtMost

    li t2,-1
    beq a0,t2,curr #if -1 use current(for edge case of negative integers)...
    blt a0,s1,curr
    j get_done2

noanswer:
    li a0,-1
    j get_done2

go_left2:
    ld a1,8(a1)
    mv a0,s0
    call getAtMost
    j get_done2

curr:
    mv a0,s1

get_done2:
    ld s1,0(sp) #load current answer
    ld s0,8(sp) #load val
    ld ra,16(sp) #load return address
    addi sp,sp,24 #reset stack
    ret
