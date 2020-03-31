section .text
global _WinMain@16

extern _printf

_WinMain@16:
	push ebp
	mov ebp, esp

	jmp .L3
	.L0: db `%s\n%s`, 0
	.L1: db `Hello there!`, 0
	.L2: db `I've been expecting you, Mr Bond.`, 0
	.L3:

	push dword .L2
	push dword .L1
	push dword .L0
	call _printf
	add esp, 12

	leave
	mov eax, 0
	ret