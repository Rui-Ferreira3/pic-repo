.globl main
main:

# Register t3 is also called register 28 (x28)
li t3, 0xf					# t3 = 0

REPEAT:
	addi t3, t3, -1		    # t3 = t3 - 1
	bne  t3, zero, REPEAT	# Repeat the loop
    nop

.end
