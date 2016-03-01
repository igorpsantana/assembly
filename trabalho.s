.section .data

abertura:						.asciz	"Começando...\n"
pedeLinhaA: 				.asciz	"Digite o número de linhas da matriz A\n"
pedeColunaAeLinhaB: .asciz	"Digite o número de colunas da matriz A e o número de linhas da matriz B\n"
pedeColunaB:				.asciz	"Digite o número de colunas da matriz B\n"
formatoNumero:			.asciz	"%d"

# tamanhoAPrint:			.asciz	"Tamanho A: %d \n"
# tamanhoBPrint:			.asciz	"Tamanho B: %d \n"
barraN:							.asciz	"\n"
barraT:							.asciz	"\t"

matrizAelemento:		.asciz	"A[%d][%d]: "
matrizBelemento:		.asciz	"B[%d][%d]: "

elemento:						.asciz	"[%lf]\t"

mensagemMatrizA:		.asciz	"\nMatriz A: \n"
mensagemMatrizB:		.asciz	"\nMatriz B: \n"
mensagemMatrizR:		.asciz	"\nMatriz Resultante: \n"

m:									.int	0
n:									.int	0
p:									.int 	0

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

SYS_EXIT:						.int 1
SYS_FORK:						.int 2
SYS_READ:           .int 3
SYS_WRITE:					.int 4
SYS_OPEN:						.int 5
SYS_CLOSE:					.int 6
SYS_CREATE:					.int 8

O_RDONLY:						.int 0x0000
O_WRONLY:						.int 0x0001
O_RDWR:							.int 0x0002
O_CREATE:						.int 0x0040
O_EXCL:							.int 0x0080
O_APPEND:						.int 0x0400
O_TRUNC:						.int 0x0200

S_IRWXU:						.int 0x01C0
S_IRUSR:						.int 0x0100
S_IWUSR:						.int 0x0080
S_IXUSR:						.int 0x0040
S_IRWXG:						.int 0x0038
S_IRGRP:						.int 0x0020
S_IWGRP:						.int 0x0010
S_IXGRP:						.int 0x0008
S_IRWXO:						.int 0x0007
S_IROTH:						.int 0x0004
S_IWOTH:						.int 0x0002
S_IXOTH:						.int 0x0001
S_NADA:							.int 0x0000

nomearqleitura:			.asciz	"arq.txt"
contLinha:					.space 20
valorAsc:           .space 10
tamarqin:						.int 80
mostrastr:					.asciz " %s"
mostrabyte:					.asciz " %c"

nomearqescrita:     .asciz "arq2.txt"

.section .text

.globl	_start

_start:

pushl $abertura

call	printf
addl $4, %esp


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

learquivo:

	movl SYS_OPEN, %eax
	movl $nomearqleitura, %ebx
	movl O_RDONLY, %ecx
	int  $0x80

  movl tamanhoMatrizA,%ecx
 	movl	$vetor1, %edi

  LeElemento:
  push %ecx                 #1
  movl $valorAsc,%esi
	LEITURA:
  push %eax                 #2
  push %esi                 #3
	movl %eax, %ebx
	movl $3, %eax
	movl $contLinha, %ecx
	movl $1, %edx

	int  $0x80
	pop %esi								  #3

  movb contLinha, %al
  movb %al,(%esi)
  incl %esi
  pop %eax
  cmpb $0x0A, contLinha
  je CONTINUA1

CONTINUA:
  cmpb $0x20, contLinha
	jne LEITURA

  CONTINUA1:
	push %eax                 #4
	movb $0x00,(%esi)
  push $valorAsc            #5
  call atof
  addl $4,%esp

  fstpl (%edi)
  addl	$8, %edi

  pop %eax
  pop %ecx

  loop LeElemento

  pushl %eax
  movl 	%eax, %ebx
  movl	$3, %eax
  movl	$contLinha, %ecx
  movl	$1, %edx

  int $0x80

  pop %eax

  movl tamanhoMatrizB, %ecx
  movl	$vetor2, %edi

  LeElementoB:
  push %ecx                 #1
  movl $valorAsc,%esi
	LEITURAB:
  push %eax                 #2
  push %esi                 #3
	movl %eax, %ebx
	movl $3, %eax
	movl $contLinha, %ecx
	movl $1, %edx

	int  $0x80
	pop %esi								  #3

  movb contLinha, %al
  movb %al,(%esi)
  incl %esi
  pop %eax
  cmpb $0x0A, contLinha
  je CONTINUA1B

CONTINUAB:
  cmpb $0x20, contLinha
	jne LEITURAB

  CONTINUA1B:
	push %eax                 #4
	movb $0x00,(%esi)
  push $valorAsc            #5
  call atof
  addl $4,%esp

  fstpl (%edi)
  addl	$8, %edi

  pop %eax
  pop %ecx

  loop LeElementoB

FIM:
	movl SYS_CLOSE, %eax

	int  $0x80

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
fldz

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

		fldl 	(%ebp)
		fldl 	(%edi)

		fmul 	%st(1), %st(0)
		fstpl	lixoDaFpu
		fadd	%st(0), %st(1)
		fstpl	lixoDaFpu

		addl	$8,	%ebp
		addl	jumpB,	%edi

		popl	%ecx

		loop	multiColunaA

		adicionaC:
		fstpl (%esi)

		addl	$8,	%esi

		fldz

		continuaColunaB:

	subl jumpA, %ebp

	movl $vetor2, %edi
	popl	%ecx

	popl	%ebx

	addl	$8,	%ebx
	addl	%ebx,	%edi
	pushl	%ebx

	loop multiColunaB

	continuaLinhaA:

	movl	$vetor2,	%edi

	popl	%ebx
	popl	%ecx

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

fldl	(%edi)
addl 	$8, %edi

pushl %ecx
pushl %edx
subl 	$8, %esp
fstpl	(%esp)
pushl $elemento

call  printf

addl	$12, %esp

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

fldl	(%edi)
addl 	$8, %edi

pushl %ecx
pushl %edx
subl 	$8, %esp
fstpl	(%esp)
pushl $elemento

call  printf

addl	$12, %esp

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
cmp		n, %edx
je 		quebraB

fldl	(%edi)
addl 	$8, %edi

pushl %ecx
pushl %edx
subl 	$8, %esp
fstpl	(%esp)
pushl $elemento

call  printf

addl	$12, %esp

popl 	%edx
popl 	%ecx

incl	%edx
loop	printNumerosMatrizR


# printMatrizR:

# pushl $mensagemMatrizR
# call 	printf
# popl	%ebx

# movl	$vetorR,	%edi
# movl	tamanhoMatrizR,	%ecx

# movl	$0, %ebx
# movl	$0,	%edx
# jmp 	printNumerosMatrizR

# quebraR:

# movl SYS_OPEN, %eax
# movl $nomearqescrita, %ebx
# movl O_WRONLY, %ecx
# orl  O_CREATE, %ecx
# movl S_IRUSR, %edx
# orl  S_IWUSR, %edx
# int  $0x80

# pushl %eax

# movl %eax, %ebx
# movl SYS_WRITE, %eax
# movl $barraT, %ecx
# movl $8, %edx
# int  $0x80

# movl SYS_CLOSE, %eax
# popl %ebx
# int $0x80

# popl	%ebx
# popl	%ecx

# movl	$0, %edx

# printNumerosMatrizR:
# cmp		p, %edx
# je 		quebraR

# movl 	(%edi), %eax
# addl 	$4, 		%edi

# pushl %eax
# pushl %ebx
# pushl %ecx
# pushl %edx

# movl SYS_OPEN, %eax
# movl $nomearqescrita, %ebx
# movl O_WRONLY, %ecx
# orl  O_CREATE, %ecx
# movl S_IRUSR, %edx
# orl  S_IWUSR, %edx
# int  $0x80

# pushl %eax

# movl %eax, %ebx
# movl SYS_WRITE, %eax
# movl $elemento, %ecx
# movl $8, %edx
# int  $0x80

# movl SYS_CLOSE, %eax
# popl %ebx
# int $0x80

# popl %eax
# popl %edx
# popl %ecx
# popl %ebx
# popl %eax

# # pushl %ecx
# # pushl %edx
# # pushl	%eax
# # pushl $elemento

# # call  printf

# # popl 	%ebx
# # popl 	%eax
# # popl 	%edx
# # popl 	%ecx

# incl	%edx
# loop	printNumerosMatrizR

finaliza:
pushl $barraN
call 	printf
popl	%ebx

call exit
