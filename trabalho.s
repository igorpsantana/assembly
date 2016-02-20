.section .data

abertura:						.asciz	"Começando...\n"
# pedeLinhaA: 				.asciz	"Digite o número de linhas da matriz A\n"
# pedeColunaAeLinhaB: .asciz	"Digite o número de colunas da matriz A e o número de linhas da matriz B\n"
# pedeColunaB:				.asciz	"Digite o número de colunas da matriz B\n"
# formatoNumero:			.asciz	"%d"
# formatoLongFloat:		.asciz	"%lf"
# tamanhoAPrint:			.asciz	"Tamanho A: %d \n"
# tamanhoBPrint:			.asciz	"Tamanho B: %d \n"
barraN:							.asciz	"\n"


matrizAelemento:		.asciz	"A[%d][%d]: "
matrizBelemento:		.asciz	"B[%d][%d]: "

elemento:						.asciz	"[%lf]\t"

mensagemMatrizA:		.asciz	"\nMatriz A: \n"
mensagemMatrizB:		.asciz	"\nMatriz B: \n"
mensagemMatrizR:		.asciz	"\nMatriz Resultante: \n"

m:									.int	2
n:									.int	2
p:									.int 	2

tamanhoMatrizA:			.int 	0
tamanhoMatrizB:			.int 	0
tamanhoMatrizR:			.int 	0

varx:								.double 1.5

var:								.int  0
lixoDaFpu:					.double 0.0
jumpA:							.int 	0
jumpB:							.int 	0

vetor1:							.space 900
vetor2:							.space 900
vetorR:							.space 900
vetorR2:						.space 900

.section .text

.globl	_start

_start:

pushl $abertura

call	printf


addl $4, %esp




movl $vetor1, %edi

fldl 	varx
fstpl (%edi)
addl	$8, %edi

fldl 	varx
fstpl (%edi)
addl	$8, %edi

fldl 	varx
fstpl (%edi)
addl	$8, %edi

fldl 	varx
fstpl (%edi)
addl	$8, %edi

movl $vetor2, %edi

fldl 	varx
fstpl (%edi)
addl	$8, %edi

fldl 	varx
fstpl (%edi)
addl	$8, %edi

fldl 	varx
fstpl (%edi)
addl	$8, %edi

fldl 	varx
fstpl (%edi)
addl	$8, %edi

subl $8, %edi



_pimba:

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

calculaJumpB:
movl	p,	%eax
movl	$8, %ecx
mull  %ecx

movl	$jumpB, %ebx
movl	%eax,	(%ebx)

calculaJumpA:
movl	n, %eax
movl	$8,	%ecx
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

multiLinhasA:

pushl %ecx

movl	$0,	%ebx
pushl	%ebx
movl 	p,	%ecx

	multiColunaB:

	pushl	%ecx

	movl	n,	%ecx

		multiColunaA:

		pushl	%ecx

		fldl 	var

		fldl 	(%ebp)
		fldl 	(%edi)

		fmul 	%st(1), %st(0) 
		fadd	%st(0), %st(2)

		fstpl	lixoDaFpu
		fstpl	lixoDaFpu

		addl	$8,	%ebp
		addl	jumpB,	%edi

		# Retorna o %ecx para que o loop possa ser feito.
		popl	%ecx

		loop	multiColunaA

		adicionaC:

		# Move o que foi calculado para o registro da matriz Resultado.
		fstpl (%esi)

		# Vai para o próximo registro da matriz Resultado.
		addl	$8,	%esi

		# Limpa o acumulador para fazer a próxima multiplicação


		continuaColunaB:

	# Remove o %ecx para poder continuar este loop.
	popl	%ecx

	subl jumpA, %ebp

	# Move o endereço do primeiro elemento da matriz B para o registrador
	movl $vetor2, %edi

	popl	%ebx

	# Move o ponteiro da matriz B para a segunda coluna
	addl	$8,	%ebx
	addl	%ebx,	%edi

	# Guarda novamente o ebx
	pushl	%ebx

	loop multiColunaB

	continuaLinhaA:

	movl	$vetor2,	%edi

	popl	%ebx
	popl	%ecx

# Move para a próxima linha da Matriz A.
addl	jumpA,	%ebp

loop multiLinhasA	

printMatrizA:

pushl $mensagemMatrizA
call 	printf
popl	%ebx

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
cmp		p, %edx
je 		quebraR

movl 	(%edi), %eax
addl 	$4, 		%edi

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

