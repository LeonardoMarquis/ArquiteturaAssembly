.data
msg:		.asciz "Segredo!"	# string original
# msg:		.asciz "Fprgpqz4"	# string codificada
msg_cod:	.space 9		# Reserva espaço para a mensagem codificada
newline:	.asciz "\n"
end_string:	.ascii "\0"
		.align 2		# Alinha as próximas palavras em múltiplos de 4
label_dia:	.word 4			# dia (exemplo)
label_mes:	.word 10		# mês - 1 (exemplo)


.text
.globl main

main:
	la	s5, label_dia		# Endereço da Variável label_dia
	lw	s5, 0(s5)		# s5 contem dia
	la	s6, label_mes		# Endereço da Variável label_mes
	lw	s6, 0(s6)		# s6 contem mes - 1
	
#-----------------------------------#
#           Cálculo de L1           #
#-----------------------------------#
	add	s11, s5, s6		# s11 contem (dia + mes)
	li	t2, 5			# t2 contem 5
	mul	t1, t2, s11		# t1 contem 5*(dia + mes)
	li	t2, 26			# t2 contem 26
	rem	s10, t1, t2		# a1 contem (5*(dia + mes))mod 26
	addi	s10, s10, 65		# a1 contem 65 + (5*(dia + mes))mod 26

#-----------------------------------#
#           Cálculo de L2           #
#-----------------------------------#
	# s11 contem (dia + mes)
	li	t2, 7			# t2 contem 7
	mul	t1, t2, s11		# t1 contem 7*(dia + mes)
	addi	t1, t1, 11		# t1 contem 7*(dia + mes) + 11
	li	t2, 26			# t2 contem 26
	rem	s9, t1, t2		# s9 contem (7*(dia + mes) + 11)mod 26
	addi	s9, s9, 65		# s9 contem 65 + (7*(dia + mes) + 11)mod 26
	
	xor	s8, s10, s9		# s8 contem L1 XOR L2

#-----------------------------------#
# Preparação para o Laço Principal  #
#-----------------------------------#
	
	li	s0, 0			# s0 contem o Indezador
	la      s1, msg			# s1 contem o Endereço da Mensagem a ser codificada
	la      s2, end_string		
	lbu     s2, 0(s2)		# s2 contem o Terminador da mensagem
	la	s3, msg_cod		# s3 contem o endereço da mensagem codificada
	
#----------------------#
#    Laço Principal    #
#----------------------#
	
Loop:	add	t0, s0, s1		# t0 contem o endereçco do caracter a ser lido (indezador + 
	lbu     t0, 0(t0)		# t0 contem o caracter lido
	beq	t0, s2, Exit		# Encerra se caracter lido é o tetrminador
	xor	t0, t0, s8		# Codificca o caracter com Caracyter XOR L1 XOR L2
	
	add	t1, s3, s0		# A codificação e a escrita da mensagem codificada compartilham o mesmo indezador
	sb	t0, 0(t1)		# Armazena o resultado da codificação na mensagem codificada
	addi	s0, s0, 1		# Incrementa o indezador
	jal,	zero Loop		# Salta para Loop sem endereço de retorno

#---------------------------#
#    Finaliza o programa    #    
#---------------------------#

Exit:
	la      a0, msg_cod
	add	t0, s0, a0
	sb	s2, 0(t0)
	li      a7, 4			# syscall imprime string
	ecall

	li	a7, 10			# syscall encerra programa
	ecall
