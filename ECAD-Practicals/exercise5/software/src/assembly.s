.macro DEBUG_PRINT reg
csrw 0x7b2, \reg
.endm

.text

.global div

div:
	addi sp,sp,-32	# Allocate stack space
	
	# store any callee-saved register you might overwrite
	sw ra, 0(sp)
	
	# do your work
	li t0,0 #Q=0
	li t1,0 #R =0
	
	li t2, 31 # value of i

	loop:
		slli t1, t1, 1 #R<<1
		srl  t3,a0,t2 #a0 is numerator - get ith bit
		andi t3,t3,1
		or t1, t1, t3	# r(0) :=n(i)	
		
		blt t1, a1,skipif #a1 is Divisor if(R<D)
		sub t1, t1, a1	#(R-D)
		
		li t3,1
		sll  t3,t3,t2 #a0 is numerator - get ith bit
		or t0,t0,t3 #Q(i)==1
	skipif:	
		addi t2,t2, -1 #i--
		bge t2,zero, loop
	addi a0, t0,0
	addi a1, t1,0 

	# load every register you stored above
	lw ra, 0(sp)
	addi sp,sp,32 	# Free up stack space
	ret
.global rem
rem:
	addi sp,sp,-32	# Allocate stack space
	sw ra, 0(sp)
	call div
	addi a0,a1,0
	lw ra, 0(sp)
	addi sp,sp,32 	# Free up stack space
	ret
