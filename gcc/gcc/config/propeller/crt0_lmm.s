	.section .lmmkernel, "ax"
	.global r0
	.global r1
	.global r2
	.global r3
	.global r4
	.global r5
	.global r6
	.global r7
	.global r8
	.global r9
	.global r10
	.global r11
	.global r12
	.global r13
	.global r14
	.global lr
	.global sp
	.global pc

	.global __LMM_entry
__LMM_entry
r0	mov	sp, PAR
r1	mov	r0, sp
r2	cmp	sp,r14	wz	' see if stack is at top of memory
r3 IF_NE jmp    #r7		' if not, skip some stuff
	'' initialization for first time run
r4      locknew	__TMP0 wc	' allocate a lock
r5 IF_NC wrlong __TMP0, __C_LOCK_PTR	' save it to ram if successful
r6      jmp    #__LMM_loop
	'' initialization for non-primary cogs
r7      rdlong pc,sp		' if user stack, pop the pc
r8      add	sp,#4
r9      rdlong r0,sp		' pop the argument for the function
r10     add	sp,#4
r11     rdlong __TLS,sp	' and the _TLS variable
r12     add	sp,#4
r13	jmp	#__LMM_loop
r14	long	0x00008000
r15	'' alias for link register lr
lr	long	__exit
sp	long	0
pc	long	entry		' default pc


	''
	'' main LMM loop -- read instructions from hub memory
	'' and executes them
	''
__LMM_loop
	rdlong	L_ins0,pc
	add	pc,#4
L_ins0	nop
	rdlong	L_ins1,pc
	add	pc,#4
L_ins1	nop
	rdlong	L_ins2,pc
	add	pc,#4
L_ins2	nop
	rdlong	L_ins3,pc
	add	pc,#4
L_ins3	nop
	rdlong	L_ins4,pc
	add	pc,#4
L_ins4	nop
	rdlong	L_ins5,pc
	add	pc,#4
L_ins5	nop
	rdlong	L_ins6,pc
	add	pc,#4
L_ins6	nop
	rdlong	L_ins7,pc
	add	pc,#4
L_ins7	nop
	jmp	#__LMM_loop

	''
	'' LMM support functions
	''

	'' move immediate
	.macro LMM_movi reg
	.global __LMM_MVI_\reg
__LMM_MVI_\reg
	rdlong	\reg,pc
	add	pc,#4
	jmp	#__LMM_loop
	.endm

	LMM_movi r0
	LMM_movi r1
	LMM_movi r2
	LMM_movi r3
	LMM_movi r4
	LMM_movi r5
	LMM_movi r6
	LMM_movi r7
	LMM_movi r8
	LMM_movi r9
	LMM_movi r10
	LMM_movi r11
	LMM_movi r12
	LMM_movi r13
	LMM_movi r14
	LMM_movi lr

	''
	'' call functions
	''
	.global	__LMM_CALL
	.global __LMM_CALL_INDIRECT
__LMM_CALL
	rdlong	__TMP0,pc
	add	pc,#4
__LMM_CALL_INDIRECT
	mov	lr,pc
	mov	pc,__TMP0
	jmp	#__LMM_loop

	''
	'' direct jmp
	''
	.global __LMM_JMP
__LMM_JMP
	rdlong	pc,pc
	jmp	#__LMM_loop

	''
	'' push and pop multiple
	'' these take in __TMP0 a mask
	'' of (first_register|(count<<4))
	''
	'' note that we push from low register first (so registers
	'' increment as the stack decrements) and pop the other way
	''
	.global __LMM_PUSHM
	.global __LMM_PUSHM_ret
__LMM_PUSHM
	mov	__TMP1,__TMP0
	and	__TMP1,#0x0f
	movd	L_pushins,__TMP1
	shr	__TMP0,#4
L_pushloop
	sub	sp,#4
L_pushins
	wrlong	0-0,sp
	add	L_pushins,inc_dest1
	djnz	__TMP0,#L_pushloop
__LMM_PUSHM_ret
	ret

inc_dest1
	long	(1<<9)

	.global __LMM_POPM
	.global __LMM_POPM_ret
__LMM_POPM
	mov	__TMP1,__TMP0
	and	__TMP1,#0x0f
	movd	L_poploop,__TMP1
	shr	__TMP0,#4
L_poploop
	rdlong	0-0,sp
	add	sp,#4
	sub	L_poploop,inc_dest1
	djnz	__TMP0,#L_poploop
__LMM_POPM_ret
	ret

	
	''
	'' masks
	''
	
	.global __MASK_0000FFFF
	.global __MASK_FFFFFFFF

__MASK_0000FFFF	long	0x0000FFFF
__MASK_FFFFFFFF	long	0xFFFFFFFF

	''
	'' math support functions
	''
	.global __TMP0
	.global __DIVSI
	.global __DIVSI_ret
	.global __UDIVSI
	.global __UDIVSI_ret
	.global __CLZSI
	.global __CLZSI_ret
	.global __CTZSI
__TMP0	long	0
__MASK_00FF00FF	long	0x00FF00FF
__MASK_0F0F0F0F	long	0x0F0F0F0F
__MASK_33333333	long	0x33333333
__MASK_55555555	long	0x55555555
__CLZSI	rev	r0, #0
__CTZSI	neg	__TMP0, r0
	and	__TMP0, r0	wz
	mov	r0, #0
 IF_Z	mov	r0, #1
	test	__TMP0, __MASK_0000FFFF	wz
 IF_Z	add	r0, #16
	test	__TMP0, __MASK_00FF00FF	wz
 IF_Z	add	r0, #8
	test	__TMP0, __MASK_0F0F0F0F	wz
 IF_Z	add	r0, #4
	test	__TMP0, __MASK_33333333	wz
 IF_Z	add	r0, #2
	test	__TMP0, __MASK_55555555	wz
 IF_Z	add	r0, #1
__CLZSI_ret	ret
__DIVR	long	0
__TMP1
__DIVCNT
	long	0
	''
	'' calculate r0 = orig_r0/orig_r1, r1 = orig_r0 % orig_r1
	''
__UDIVSI
	mov	__DIVR, r0
	call	#__CLZSI
	neg	__DIVCNT, r0
	mov	r0, r1 wz
 IF_Z   jmp	#__UDIV_BY_ZERO
	call	#__CLZSI
	add	__DIVCNT, r0
	mov	r0, #0
	cmps	__DIVCNT, #0	wz, wc
 IF_C	jmp	#__UDIVSI_done
	shl	r1, __DIVCNT
	add	__DIVCNT, #1
__UDIVSI_loop
	cmpsub	__DIVR, r1	wz, wc
	addx	r0, r0
	shr	r1, #1
	djnz	__DIVCNT, #__UDIVSI_loop
__UDIVSI_done
	mov	r1, __DIVR
__UDIVSI_ret	ret
__DIVSGN	long	0
__DIVSI	mov	__DIVSGN, r0
	xor	__DIVSGN, r1
	abs	r0, r0 wc
	muxc	__DIVSGN, #1	' save original sign of r0
	abs	r1, r1
	call	#__UDIVSI
	cmps	__DIVSGN, #0	wz, wc
 IF_B	neg	r0, r0
	test	__DIVSGN, #1 wz	' check original sign of r0
 IF_NZ	neg	r1, r1		' make the modulus result match
__DIVSI_ret	ret

	'' come here on divide by zero
	'' we probably should raise a signal
__UDIV_BY_ZERO
	neg	r0,#1
	mov	r1,#0
	jmp	#__UDIVSI_ret
	
	.global __MULSI
	.global __MULSI_ret
__MULSI
__MULSI
	mov	__TMP0, r0
	min	__TMP0, r1
	max	r1, r0
	mov	r0, #0
__MULSI_loop
	shr	r1, #1	wz, wc
 IF_C	add	r0, __TMP0
	add	__TMP0, __TMP0
 IF_NZ	jmp	#__MULSI_loop
__MULSI_ret	ret

	''
	'' code for atomic compare and swap
	''
__C_LOCK_PTR
	long	__C_LOCK

	''
	'' compare and swap a variable
	'' r0 == new value to set if (*r2) == r1
	'' r1 == value to compare with
	'' r2 == pointer to memory
	'' output: r0 == original value of (*r2)
	''         Z flag is set if (*r2) == r1, clear otherwise
	''
	.global __CMPSWAPSI
	.global __CMPSWAPSI_ret
__CMPSWAPSI
	'' get the C_LOCK
	rdlong	__TMP1,__C_LOCK_PTR
	mov	__TMP0,r0	'' save value to set
.swaplp
	lockset	__TMP1 wc
   IF_C jmp	#.swaplp

	rdlong	r0,r2		'' fetch original value
	cmp	r0,r1 wz	'' compare with desired original value
   IF_Z wrlong  __TMP0,r2	'' if match, save new value
	
	'' now release the C lock
	lockclr __TMP1
__CMPSWAPSI_ret
	ret
	
	''
	'' FCACHE region
	'' The FCACHE is an area where we can
	'' execute small functions or loops entirely
	'' in Cog memory, providing a significant
	'' speedup.
	''

__LMM_FCACHE_ADDR
	long 0
inc_dest4
	long (4<<9)
	
	.global	__LMM_RET
	.global	__LMM_FCACHE_LOAD
__LMM_RET
	long 0
__LMM_FCACHE_LOAD
	rdlong	__TMP0,pc	'' read count of bytes for load
	add	pc,#4
	mov	__TMP1,pc
	cmp	__LMM_FCACHE_ADDR,pc wz	'' is this the same fcache block we loaded last?
	add	pc,__TMP0	'' skip over data
  IF_Z	jmp	#Lmm_fcache_doit

	mov	__LMM_FCACHE_ADDR, __TMP1
	
	'' assembler awkwardness here
	'' we would like to just write
	'' movd	Lmm_fcache_loop,#__LMM_FCACHE_START
	'' but binutils doesn't work right with this now
	movd Lmm_fcache_loop,#(__LMM_FCACHE_START-__LMM_entry)/4
	movd Lmm_fcache_loop2,#1+(__LMM_FCACHE_START-__LMM_entry)/4
	movd Lmm_fcache_loop3,#2+(__LMM_FCACHE_START-__LMM_entry)/4
	movd Lmm_fcache_loop4,#3+(__LMM_FCACHE_START-__LMM_entry)/4
	add  __TMP0,#15		'' round up to next multiple of 16
	shr  __TMP0,#4		'' we process 16 bytes per loop iteration
Lmm_fcache_loop
	rdlong	0-0,__TMP1
	add	__TMP1,#4
	add	Lmm_fcache_loop,inc_dest4
Lmm_fcache_loop2
	rdlong	0-0,__TMP1
	add	__TMP1,#4
	add	Lmm_fcache_loop2,inc_dest4
Lmm_fcache_loop3
	rdlong	0-0,__TMP1
	add	__TMP1,#4
	add	Lmm_fcache_loop3,inc_dest4
Lmm_fcache_loop4
	rdlong	0-0,__TMP1
	add	__TMP1,#4
	add	Lmm_fcache_loop4,inc_dest4

	djnz	__TMP0,#Lmm_fcache_loop

Lmm_fcache_doit
	jmpret	__LMM_RET,#__LMM_FCACHE_START
	jmp	#__LMM_loop


	''
	'' the fcache area should come last in the file
	''
	.global __LMM_FCACHE_START
__LMM_FCACHE_START
	res	256	'' reserve 256 longs = 1K

	''
	'' global variables
	''
	.comm __C_LOCK,4,4