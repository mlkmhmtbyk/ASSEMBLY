segment .text
global cross_correlation_asm_full

cross_correlation_asm_full:			;while(i<out_size){
	push ebp				;	i++
	mov ebp, esp				;	while(j<size_1){
						;		j++
	mov dword [ebp-8], 0			;		if(size_2-1-i+j>=0 && i>=j){
	mov dword [ebp-4], 0			;			out[i] += ar1[j] * ar2[size_2 -1-i+j]
						;	}	}
outer_loop:					;	if(out[i] != 0){
	mov ecx, [ebp-8]			;	nonzero = nonzero + 1
	mov eax, 4				;}	}
	mul ecx
	mov ecx, [ebp+24]
	add ecx, eax
	mov dword [ecx], 0
	mov dword [ebp-12], 0
	
inner_loop:
	mov eax, [ebp-8]
	mov ecx, [ebp-12]
	add ecx, [ebp+20]
	cmp eax, ecx
	jae condition_fail
	mov ecx, [ebp-12]
	cmp eax, ecx
	jb condition_fail
	sub ecx, eax
	dec ecx
	add ecx, [ebp+20]
	mov eax, 4
	mul ecx
	mov ecx, eax
	mov eax, [ebp+16]
	add eax, ecx
	mov ecx, [eax]
	mov eax, 4
	mov edx, [ebp-12]
	mul edx
	mov edx, eax
	add edx, [ebp+8]
	mov eax, [edx]
	mul ecx
	mov ecx, eax
	mov eax, 4
	mov edx, [ebp-8]
	mul edx
	add eax, [ebp+24]
	mov edx, [eax]
	add edx, ecx
	mov [eax], edx
	
condition_fail:
	mov eax, [ebp+12]
	mov edx, [ebp-12]
	inc edx
	cmp edx, eax
	jae inner_loop_end
	mov [ebp-12], edx
	jmp inner_loop
	
inner_loop_end:
	mov eax, 4
	mov edx, [ebp-8]
	mul edx
	mov edx, [ebp+24]
	add edx, eax
	mov eax, [edx]
	mov edx, 0
	cmp eax, edx
	je zero_result
	mov eax, [ebp-4]
	inc eax
	mov [ebp-4], eax
	
zero_result:	
	mov eax, [ebp+28]
	mov edx, [ebp-8]
	inc edx
	cmp edx, eax
	jae outer_loop_end
	mov [ebp-8], edx
	jmp outer_loop
	
outer_loop_end:
	mov eax, [ebp-4]

	pop ebp
	ret
