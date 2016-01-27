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

elemento:						.asciz	"%d\t"


mensagemMatrizA:			.asciz	"\nMatriz A: \n"
mensagemMatrizB:			.asciz	"\nMatriz B: \n"

m:							.int	0
n:							.int	0
p:							.int 	0
tamanhoMatrizA:	.int 	0
tamanhoMatrizB:	.int 	0
puloB:					.int 	0
var:						.int 	0

vetor1:	.space 900
vetor2:	.space 900

.section .text

.globl	_start

_start:

	pushl $abertura
	call	printf

	addl $4, %esp #Limpar a pilha

linhaA:

	pushl	$pedeLinhaA
	call 	printf
	pushl	$m
	pushl	$formatoNumero
	call 	scanf

	addl $12, %esp #Limpar a pilha

	movl m, %eax
	cmpl $0, %eax
	jle  linhaA

colunaALinhaB:

	pushl $pedeColunaAeLinhaB
	call 	printf
	pushl	$n
	pushl	$formatoNumero
	call 	scanf

	addl $12, %esp #Limpar a pilha

	movl n, %eax
	cmpl $0, %eax
	jle  colunaALinhaB

colunaB:

	pushl $pedeColunaB
	call 	printf
	pushl	$p
	pushl	$formatoNumero
	call 	scanf

	addl $12, %esp #Limpar a pilha

	movl	p, %eax
	cmpl	$0, %eax
	jle   colunaB

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

	pop %ecx

	popl 	%ebx
	popl 	%eax

  push %eax
  push %ebx
	pushl $var
	pushl $formatoNumero
	call 	scanf

	pop %ecx
	pop %ecx
	pop %ebx
	pop %eax

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

	movl $vetor2, %edi

	movl $1, %ebx   #linha
	movl $0, %eax   #coluna

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

printaMatrizA:
	
	pushl $mensagemMatrizA
	call  printf
	popl 	%ebx

	movl	$vetor1,	%edi
	movl	tamanhoMatrizA,	%ecx

	movl	$0, %ebx
	movl	$0,	%edx
	jmp 	printNumerosMatrizA

quebraA:

	pushl	%ecx
	pushl $barraN
	call 	printf

	popl	%ebx
	popl	%ecx

	movl	$0, %edx

printNumerosMatrizA:
	cmp		n, %edx
	je 		quebraA

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
	loop	printNumerosMatrizA

printMatrizB:

	pushl $mensagemMatrizB
	call 	printf
	popl	%ebx

	movl	$vetor2,	%edi
	movl	tamanhoMatrizB,	%ecx

	movl	$0, %ebx
	movl	$0,	%edx
	jmp 	printNumerosMatrizB

quebraB:

	pushl	%ecx
	pushl $barraN
	call 	printf

	popl	%ebx
	popl	%ecx

	movl	$0, %edx

printNumerosMatrizB:
	cmp		n, %edx
	je 		quebraB

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
	loop	printNumerosMatrizB

finaliza:
	pushl $barraN
	call 	printf
	popl	%ebx

	call exit
