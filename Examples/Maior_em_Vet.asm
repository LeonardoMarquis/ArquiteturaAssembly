.text
la s0, VETOR	# Carraga o endereço de vetor no registrador s0
la s1, SIZE	# Carrega o endereço de SIZE no registrador s1
la s2, MAIOR
li t0, 0	# Armazena o valor imediato zero em t0

LOOP:
slli t1, t0, 2
add t2, t1, s0
lw t3, 0(t2)
lw t4, 0(s2)
blt t4, t3, UPDATE_BIGER
addi t0, t0, 1
lw t5, 0(s1)
blt t0, t5, LOOP
li a7, 10
ecall

UPDATE_BIGER:
sw t3, 0(s2)
addi t0, t0, 1
lw t5, 0(s1)
blt t0, t5, LOOP
li a7, 10
ecall

.data
VETOR: .word 1, 3, 2
SIZE: .word 3
MAIOR: .word 0