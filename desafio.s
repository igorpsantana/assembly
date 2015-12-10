.section .data
titulo:						.asciz	"\nComeço do software\n"
pedeN:						.asciz 	"\nDigite o número de funcionários: "
pedeCargo: 				.asciz	"Digite o cargo do Funcionário:\n"
pedeSalario:			.asciz	"Digite o salário do Funcionário:"

respostaCargo:		.asciz	"%s"
respostaSalario:	.asciz	"%f"
formatoNumero:		.asciz	"%d"
barraN:						.asciz	"%d \n"

cargoAtual:				.asciz "Cargos:\n (1): Operário \n (2): Chefe \n (3): Diretor \n (4): Presidente \n"

numeroCargo:			.int 0

numeroElementos:	.int 0

salarioAtual:			.int 0

salarioAjustavel:	.int 0


.section .text

.globl _start

_start:

	pushl $titulo
	call	printf

	addl $4, %esp

_leN:

	pushl $pedeN
	call 	printf
		
	pushl $numeroElementos
	pushl $formatoNumero
	call	scanf
	
	addl 	$12, %esp

	movl 	numeroElementos, %ecx
	cmpl 	$0, %ecx
	jle 	_fim

_leN1:

	subl 	$1, %ecx

	pushl	$pedeCargo
	call	printf
	pushl	$cargoAtual
	call	printf

	pushl $numeroCargo
	pushl $formatoNumero
	call 	scanf
	
	addl $16, %esp
	
_fim:
	
	pushl $0
	call exit

