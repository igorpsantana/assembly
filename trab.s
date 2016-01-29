.section .data

abertura:						.asciz	"Começando...\n"
pedeLinhaA: 				.asciz	"Digite o número de linhas da matriz A\n"
pedeColunaAeLinhaB: .asciz	"Digite o número de colunas da matriz A e o número de linhas da matriz B\n"
pedeColunaB:				.asciz	"Digite o número de colunas da matriz B\n"

formatoNumero:			.asciz	"%d"
tamanhoAPrint:			.asciz	"Tamanho A: %d \n"
tamanhoBPrint:			.asciz	"Tamanho B: %d \n"
barraN:							.asciz	"\n"

matrizAelemento:		.asciz	"A[%d][%d]: "
matrizBelemento:		.asciz	"B[%d][%d]: "

elemento:						.asciz	"[%d]\t"

mensagemMatrizA:		.asciz	"\nMatriz A: \n"
mensagemMatrizB:		.asciz	"\nMatriz B: \n"
mensagemMatrizR:		.asciz	"\nMatriz Resultante: \n"

m:									.int	0
n:									.int	0
p:									.int 	0

tamanhoMatrizA:			.int 	0
tamanhoMatrizB:			.int 	0
tamanhoMatrizR:			.int 	0

var:								.int 	0

jumpA:							.int 	0
jumpB:							.int 	0

vetor1:							.space 900
vetor2:							.space 900
vetorR:							.space 900

.section .text

.globl	_start

_start:

	pushl $abertura
	call	printf

	addl $4, %esp

# Começa pedindo os valores de m, n e p.
# Matriz A: A[m][n] 
# Matriz B: B[n][p]

linhaA:

	pushl	$pedeLinhaA
	call 	printf
	pushl	$m
	pushl	$formatoNumero
	call 	scanf

	addl $12, %esp

	movl m, %eax
	cmpl $0, %eax
	jle  linhaA

colunaALinhaB:

	pushl $pedeColunaAeLinhaB
	call 	printf
	pushl	$n
	pushl	$formatoNumero
	call 	scanf

	addl $12, %esp 

	movl n, %eax
	cmpl $0, %eax
	jle  colunaALinhaB

colunaB:

	pushl $pedeColunaB
	call 	printf
	pushl	$p
	pushl	$formatoNumero
	call 	scanf

	addl $12, %esp 

	movl	p, %eax
	cmpl	$0, %eax
	jle   colunaB

# Faz o cálculo do tamanho da Matriz A e da Matriz B.
# O tamanho das matrizes será utilizado para controlar os loops.
# Para o cálculo do tamanho da matriz, foi feita a multiplicação i*j, onde A[i][j].

tamanhoMatrizes:

	movl	m, %eax
	movl	n, %ebx
	mull	%ebx

	movl 	$tamanhoMatrizA, %ebx
	movl 	%eax, (%ebx)

	movl	n, %eax
	movl	p, %ebx
	mull	%ebx

	movl 	$tamanhoMatrizB, %ebx
	movl 	%eax, (%ebx)


# Começa o preenchimento da Matriz A e B
# Ele adiciona o endereço de memória no registrador %edi 
#	O registrador %ebx fica responsável pelo loop das linhas
# e o registrador %eax fica responsável pelo loop das colunas.
# A operação "pop %ecx" foi utilizada para remover os valores da pilha.

comecaPreencherMatrizA:
	movl $vetor1, %edi

	movl $1, %ebx   #linha
	movl $0, %eax   #coluna

preencheColunaA:
	
	incl %eax

	pushl %eax
	pushl %ebx

	pushl $matrizAelemento

	call 	printf

	pop 	%ecx

	popl 	%ebx
	popl 	%eax

  push 	%eax
  push 	%ebx
	pushl $var
	pushl $formatoNumero
	call 	scanf

	pop 	%ecx
	pop 	%ecx
	pop 	%ebx
	pop 	%eax

	movl 	var, %edx
	movl 	%edx, (%edi)

	addl 	$4, %edi

	cmp 	n, %eax
	
	jne		preencheColunaA

alteraLinhaA:

	movl 	$0, %eax
	incl 	%ebx

	cmp  m,%ebx
	jle  preencheColunaA

printaBarraN:

	pushl $barraN
	call 	printf
	popl	%ecx

comecaPreencherMatrizB:

	movl 	$vetor2, %edi

	movl 	$1, %ebx   #linha
	movl 	$0, %eax   #coluna

preencheColunaB:
	
	incl %eax

	pushl %eax
	pushl %ebx

	pushl $matrizBelemento

	call 	printf

	popl 	%ecx

	popl 	%ebx
	popl 	%eax

  push 	%eax
  push 	%ebx
	pushl $var
	pushl $formatoNumero
	call 	scanf

	popl 	%ecx
	popl 	%ecx
	popl 	%ebx
	popl 	%eax

	movl 	var, %edx
	movl 	%edx, (%edi)

	addl 	$4, %edi

	cmp 	p, %eax
	
	jne		preencheColunaB

alteraLinhaB:

	movl 	$0, %eax
	incl 	%ebx

	cmp  n,%ebx
	jle  preencheColunaB

# Os jumps são calculados multiplicando 4*no de colunas. 
# Eles são utilizados para pular de uma linha para a outra

calculaJumpB:
	movl	p,	%eax
	movl	$4, %ecx
	mull  %ecx

	movl	$jumpB, %ebx
	movl	%eax,	(%ebx)

calculaJumpA:
	movl	n, %eax
	movl	$4,	%ecx
	mull  %ecx

	movl	$jumpA, %ebx
	movl	%eax,	(%ebx)

# Neste trecho, são movidos os vetores para os registradores que serão utilizados na multiplicação
# Os registradores que serão utilizados serão zerados e a variável que será utilizada como contadora
# também foi zerada.

inicializaMultiplicacao:

	movl	$vetor1,	%ebp
	movl	$vetor2,	%edi
	movl	$vetorR,	%esi
	movl	$0,	%eax
	movl	$0,	%ebx
	movl	$0,	%ecx
	
	movl	$var, %edx
	movl	$0,		(%edx)

	movl	$0,	%edx

	movl m,	%ecx

# Guarda o valor de %ecx para o loop e move p, que são as colunas de B para o %ecx,
# para que o próximo loop possa rodar nelas.

multiLinhasA:

	pushl %ecx

	movl	$0,	%ebx
	pushl	%ebx
	movl 	p,	%ecx

	# Guarda o valor de %ecx para o loop e move n, que são as colunas de A para que
	# o próximo loop possa rodar nelas
	multiColunaB:

	pushl	%ecx

	movl	n,	%ecx
		# Guarda o valor de %ecx para que não seja modificado por nenhuma outra expressão
		multiColunaA:

		pushl	%ecx

		# Pulado para o próximo registro da matriz A.

		# Move os valores que estavam nos vetores para os registradores %eax e %ebx,
		# para que eles possam ser multiplicados
		movl	(%ebp),	%eax
		movl	(%edi),	%ebx
		mull  %ebx

		addl	$4,	%ebp

		# Após ir para o próximo registro do vetor, o valor de jumpB é adicionado na matriz B,
		# para ir para a primeira coluna da próxima linha. 
		addl	jumpB,	%edi

		# Move o endereço de memória do acumulador para o registrador %ebx, para
		# que seja adicionado o valor que foi multiplicado. 
		movl	$var,	%ebx
		addl	%eax,	(%ebx)

		# Retorna o %ecx para que o loop possa ser feito.
		popl	%ecx

		loop	multiColunaA

		adicionaC:

		# Move o que foi calculado para o registro da matriz Resultado.
		movl	var,	%ebx
		movl	%ebx,	(%esi)

		# Vai para o próximo registro da matriz Resultado.
		addl	$4,	%esi

		# Limpa o acumulador para fazer a próxima multiplicação
		movl	$var,	%edx
		movl	$0,	(%edx)

	continuaColunaB:
	
	# Remove o %ecx para poder continuar este loop.
	popl	%ecx

	subl jumpA, %ebp

	# Move o endereço do primeiro elemento da matriz B para o registrador
	movl $vetor2, %edi

	popl	%ebx

	# Move o ponteiro da matriz B para a segunda coluna
	addl	$4,	%ebx
	addl	%ebx,	%edi

	# Guarda novamente o ebx
	pushl	%ebx

	loop multiColunaB

continuaLinhaA:

movl	$vetor2,	%edi

popl	%ebx
popl	%ecx

# Movep para a próxima linha da Matriz A.
addl	jumpA,	%ebp

loop multiLinhasA	

# Utilizado para printar a matriz resultante:

calculaTamanhoMatrizR:

	movl	m, %eax
	movl	p, %ebx
	mull	%ebx

	movl 	$tamanhoMatrizR, %ebx
	movl 	%eax, (%ebx)

printMatrizR:

	pushl $mensagemMatrizR
	call 	printf
	popl	%ebx

	movl	$vetorR,	%edi
	movl	tamanhoMatrizR,	%ecx

	movl	$0, %ebx
	movl	$0,	%edx
	jmp 	printNumerosMatrizR

quebraR:

	pushl	%ecx
	pushl $barraN
	call 	printf

	popl	%ebx
	popl	%ecx

	movl	$0, %edx

printNumerosMatrizR:
	cmp		n, %edx
	je 		quebraR

	movl 	(%edi), %eax
	addl 	$4, %edi
	
	pushl %ecx
	pushl %edx
	pushl	%eax
	pushl $elemento

	call  printf

	popl 	%ebx
	popl 	%eax
	popl 	%edx
	popl 	%ecx

	incl	%edx
	loop	printNumerosMatrizR

finaliza:
	pushl $barraN
	call 	printf
	popl	%ebx

	call exit









# printMatrizB:

# 	pushl $mensagemMatrizB
# 	call 	printf
# 	popl	%ebx

# 	movl	$vetor2,	%edi
# 	movl	tamanhoMatrizB,	%ecx

# 	movl	$0, %ebx
# 	movl	$0,	%edx
# 	jmp 	printNumerosMatrizB

# quebraB:

# 	pushl	%ecx
# 	pushl $barraN
# 	call 	printf

# 	popl	%ebx
# 	popl	%ecx

# 	movl	$0, %edx

# printNumerosMatrizB:
# 	cmp		n, %edx
# 	je 		quebraB

# 	movl 	(%edi), %eax
# 	addl 	$4, %edi
	
# 	pushl %ecx
# 	pushl %edx
# 	pushl	%eax
# 	pushl $elemento

# 	call  printf

# 	popl 	%ebx
# 	popl 	%eax
# 	popl 	%edx
# 	popl 	%ecx

# 	incl	%edx
# 	loop	printNumerosMatrizB

# finaliza:
# 	pushl $barraN
# 	call 	printf
# 	popl	%ebx

# 	call exit
