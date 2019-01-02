.macro DEBUG_PRINT reg
csrw 0x7b2, \reg
.endm

.text
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
		bge t2,zero, loop #i>=0
	addi a0, t0,0
	addi a1, t1,0 

	# load every register you stored above
	lw ra, 0(sp)
	addi sp,sp,32 	# Free up stack space
	ret

.global main		# Export the symbol 'main' so we can call it from other files
.type main, @function
main:
	sw ra, 0(sp)
	addi    a0, zero, 12    # a0 <- 12
        addi    a1, zero, 4     # a1 <- 4
        call    div
        DEBUG_PRINT a0          # display the quotient
        DEBUG_PRINT a1          # display the remainder

        addi    a0, zero, 93    # a0 <- 93
        addi    a1, zero, 7     # a1 <- 7
        call    div
        DEBUG_PRINT a0          # display the quotient
        DEBUG_PRINT a1          # display the remainder

        lui     a0, (0x12345000>>12)
        ori     a0, a0, 0x678   # a0 <- 0x12345678
        addi    a1, zero, 255   # a1 <- 255
        call    div
        DEBUG_PRINT a0          # display the quotient
        DEBUG_PRINT a1          # display the remainder	addi sp,sp,-32 	# Allocate stack space
	lw ra, 0(sp)
	ret
