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
    addi t3, t3, -1     # o decrescimo da quantidade de repeticoes que faltam
    blez t3, end_outer		# se t3 <= 0, terminou e envia para o end_outer
    
    li t4, 0			#  um contador j para representar a cada varredura, a cada varredura o t4/j reinicia
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
    				
    				# no caso, so vai ocorrer de t4 ser inferior a t3( n-1-i), isso ocorre no fluxo normal de desordenado, se esse blt nao ocorrer, é 
    				# porque o nosso j/t4 ja é igual ou superior ao nosso t3
    				
    				# aqui se nao vaipara o inner loop desce aqui
    				# ------- se for para o inner loop, faz o inner loop inteiro e desce para o skip sawp de novo
    
    addi t2, t2, 1		# incrementa no nosso t2, que é o nosso i
    j outer_loop		# simplesmente um " jump 'para onde pular' " , em suma, vai mandar para o outer_loop para atualizar o valor do t3( nosso limite de quanatas faltam)

end_outer:			# aqui ja temos o nosso vetor totalmente ordenado
    la s0, vetor		# coloca em s0 o endereco de 'vetor'
    lw s1, tamanho		# coloca o valor que esta dentro de 'tamanho' em s1
    li s2, 0			# colocamos o valor imediato 0 no s2

print_loop:
    lw a0, 0(s0)		# coloco em a0 o que esta no endereco s0, mas sem fazer salto 
    li a7, 1			# jogo no meu a7 o valor imediato 1, que no caso em a7 vai ativar o codigo de servico 1, que é imprimir int
    ecall			# chamada do sistema para imprimir o numero na tela
    
    la a0, espaco		# coloca em a0 o endereco onde esta o " "
    li a7, 4			# coloco em a7 o valor imediato 4, que no caso em a7 vai ativar o codigo de servico 4, que é imprimir string, (vamos imprimir " ", espaco em branco)
    ecall		# chamada do sistema para imprimir espaco branco na tela
    
    addi s0, s0, 4	# incrementa o endereco inicial do vetor em 4, assim ele agora aponta para o endereco da proxima word
    addi s2, s2, 1	# incremento o valor de s2, em 1 unidade
    blt s2, s1, print_loop 	# salta, se o valor de s2 < s1, salta para o print loop, faz uma recursao, e faz a impressao de novo, assim vamos continuar imprimindo, 
    
    li a7, 10 			# colocamos no a7 o valor 10, por meio do imediato, e colocar 10 no a7 ativa o "encerrar"
    ecall 

# lembara que: o bubusort tem um i e um j, o j se incrementa a cada iteracao, mas o i so se incrementa a cada varredura completa, logo temos que o
# nosso j vai iniciar chegar crescer e ser reiniciado a cada nova varredura completa i, 
