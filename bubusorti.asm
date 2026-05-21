.data
    vetor: .word 5, 2, 8, 1, 9, 3
    tamanho: .word 6
    espaco: .asciz " " # imprimir em branco entre os numeros

.text
main:
    la t0, vetor # faco um load address, carrega o endereco base do vetor em t0
    lw t1, tamanho # guardo em t1 o valor dentro de "tamanho"
    li t2, 0 # carrega direto um valor imediato constante em um registrador escolhido
    
outer_loop:
    sub t3, t1, t2 # t3 sera o limite do nosso loop interno, t1 - t2, tamanho - o valor i, o valor i é tipo de onde comeca o valor i
    		    # preparado para comecar de um i diferente, ex: 6 - 3, porque o i so cresce quando nao troca, tipo ja ordenou essa parte, ai o i
    		    # aumenta em 1 unidade, para nao obirgar ler tudo de novo
    addi t3, t3, -1     # o decrescimo da quantidade de repeticoes que teremos
    blez t3, end_outer		# se t3 <= 0, terminou e envia para o end_outer
    
    li t4, 0			#  um contador j para ?
    la t0, vetor                # restaurar o valor de t0
    
inner_loop:
    lw a0, 0(t0)		# carrega o valor vetor[j]
    lw a1, 4(t0)		# carrega o valor vetor[j+1]
    
    ble a0, a1, skip_swap       # um branch less equal, se o valor em a0 <= a1 ( vetor[j]<= vetor[j+1] ) entao nao troca, e pula para o skip swap
    	
    				# faco a troca entre um valor em uma posicao e outro valor na posicao a frente, eles trocam de posicao
    sw a1, 0(t0)		# guardar o valor de a1 na posicao 0(t0) que é a posicao do valor que veio parar em a0
    sw a0, 4(t0)		# guardar o valor de a0 na posicao 0(t0) que é a posicao do valor que veio parar em a1

skip_swap:
    addi t0, t0, 4	# avanca para o proximo valor base de t0, que vai ser o 4(t0) da ultima comparacao realizada
    addi t4, t4, 1	# incrementa o t4/j para dizer que ja fez 1 comparacao
    blt t4, t3, inner_loop	# branch less than, se o t4/j for inferior ao t3, onde guardamos quantas comparacoes devem ser realizadas, manda para o 
    				# inner loop
    
    addi t2, t2, 1		# incrementa no nosso t2, que é o nosso i
    j outer_loop

end_outer:
    la s0, vetor
    lw s1, tamanho
    li s2, 0

print_loop:
    lw a0, 0(s0)
    li a7, 1
    ecall
    
    la a0, espaco
    li a7, 4
    ecall
    
    addi s0, s0, 4
    addi s2, s2, 1
    blt s2, s1, print_loop
    
    li a7, 10 
    ecall



