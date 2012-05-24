typedef enum {
	UNDEF,
	MOV,
	iMOV,
	dMOV,
	sMOV,
	oMOV,
	ADD,
	iADD,
	dADD,
	sADD,
	oADD,
	iADDC,
	dADDC,
	SUB,
	iSUB,
	dSUB,
	oSUB,
	iSUBC,
	dSUBC,
	MUL,
	iMUL,
	dMUL,
	sMUL,
	oMUL,
	iMULC,
	dMULC,
	DIV,
	iDIV,
	dDIV,
	oDIV,
	iDIVC,
	dDIVC,
	JG,
	iJG,
	dJG,
	sJG,
	oJG,
	iJGC,
	dJGC,
	JL,
	iJL,
	dJL,
	sJL,
	oJL,
	iJLC,
	dJLC,
	JGE,
	iJGE,
	dJGE,
	sJGE,
	oJGE,
	iJGEC,
	dJGEC,
	JLE,
	iJLE,
	dJLE,
	sJLE,
	oJLE,
	iJLEC,
	dJLEC,
	JE,
	iJE,
	dJE,
	sJE,
	oJE,
	iJEC,
	dJEC,
	JNE,
	iJNE,
	dJNE,
	sJNE,
	oJNE,
	iJNEC,
	dJNEC,
	RET,
	iRET,
	dRET,
	sRET,
	oRET,
	THCODE,
	NOP,
	WRITE,
	iWRITE,
	dWRITE,
	sWRITE,
	oWRITE,
	FLUSH,
	JMP,
	LET,
	SETv,
	FUNCSET,
	CALL,
	iCALL,
	dCALL,
	sCALL,
	oCALL,
	SELFCALL,
	iSELFCALL,
	dSELFCALL,
	sSELFCALL,
	oSELFCALL,
	SHIFT,
	iSHIFT,
	dSHIFT,
	sSHIFT,
	oSHIFT,
	PUSH,
	iPUSH,
	dPUSH,
	sPUSH,
	oPUSH,
	NEW,
	A_MOV,
	B_MOV,
	C_MOV,
	D_MOV,
	A_iMOV,
	A_dMOV,
	A_sMOV,
	A_oMOV,
	B_iMOV,
	B_dMOV,
	B_sMOV,
	B_oMOV,
	C_iMOV,
	C_dMOV,
	C_sMOV,
	C_oMOV,
	D_iMOV,
	D_dMOV,
	D_sMOV,
	D_oMOV,
	AB_ADD,
	AC_ADD,
	AD_ADD,
	BC_ADD,
	BD_ADD,
	CD_ADD,
	AB_iADD,
	AB_dADD,
	AB_sADD,
	AB_oADD,
	AC_iADD,
	AC_dADD,
	AC_sADD,
	AC_oADD,
	AD_iADD,
	AD_dADD,
	AD_sADD,
	AD_oADD,
	BC_iADD,
	BC_dADD,
	BC_sADD,
	BC_oADD,
	BD_iADD,
	BD_dADD,
	BD_sADD,
	BD_oADD,
	CD_iADD,
	CD_dADD,
	CD_sADD,
	CD_oADD,
	A_iADDC,
	A_dADDC,
	A_sADDC,
	B_iADDC,
	B_dADDC,
	B_sADDC,
	C_iADDC,
	C_dADDC,
	C_sADDC,
	D_iADDC,
	D_dADDC,
	D_sADDC,
	AB_SUB,
	AC_SUB,
	AD_SUB,
	BC_SUB,
	BD_SUB,
	CD_SUB,
	AB_iSUB,
	AB_dSUB,
	AB_oSUB,
	AC_iSUB,
	AC_dSUB,
	AC_oSUB,
	AD_iSUB,
	AD_dSUB,
	AD_oSUB,
	BC_iSUB,
	BC_dSUB,
	BC_oSUB,
	BD_iSUB,
	BD_dSUB,
	BD_oSUB,
	CD_iSUB,
	CD_dSUB,
	CD_oSUB,
	A_iSUBC,
	A_dSUBC,
	B_iSUBC,
	B_dSUBC,
	C_iSUBC,
	C_dSUBC,
	D_iSUBC,
	D_dSUBC,
	AB_MUL,
	AC_MUL,
	AD_MUL,
	BC_MUL,
	BD_MUL,
	CD_MUL,
	AB_iMUL,
	AB_dMUL,
	AB_sMUL,
	AB_oMUL,
	AC_iMUL,
	AC_dMUL,
	AC_sMUL,
	AC_oMUL,
	AD_iMUL,
	AD_dMUL,
	AD_sMUL,
	AD_oMUL,
	BC_iMUL,
	BC_dMUL,
	BC_sMUL,
	BC_oMUL,
	BD_iMUL,
	BD_dMUL,
	BD_sMUL,
	BD_oMUL,
	CD_iMUL,
	CD_dMUL,
	CD_sMUL,
	CD_oMUL,
	A_iMULC,
	A_dMULC,
	A_sMULC,
	B_iMULC,
	B_dMULC,
	B_sMULC,
	C_iMULC,
	C_dMULC,
	C_sMULC,
	D_iMULC,
	D_dMULC,
	D_sMULC,
	AB_DIV,
	AC_DIV,
	AD_DIV,
	BC_DIV,
	BD_DIV,
	CD_DIV,
	AB_iDIV,
	AB_dDIV,
	AB_oDIV,
	AC_iDIV,
	AC_dDIV,
	AC_oDIV,
	AD_iDIV,
	AD_dDIV,
	AD_oDIV,
	BC_iDIV,
	BC_dDIV,
	BC_oDIV,
	BD_iDIV,
	BD_dDIV,
	BD_oDIV,
	CD_iDIV,
	CD_dDIV,
	CD_oDIV,
	A_iDIVC,
	A_dDIVC,
	B_iDIVC,
	B_dDIVC,
	C_iDIVC,
	C_dDIVC,
	D_iDIVC,
	D_dDIVC,
	A_JG,
	B_JG,
	C_JG,
	D_JG,
	A_iJG,
	A_dJG,
	A_sJG,
	A_oJG,
	B_iJG,
	B_dJG,
	B_sJG,
	B_oJG,
	C_iJG,
	C_dJG,
	C_sJG,
	C_oJG,
	D_iJG,
	D_dJG,
	D_sJG,
	D_oJG,
	A_iJGC,
	A_dJGC,
	A_sJGC,
	A_oJGC,
	B_iJGC,
	B_dJGC,
	B_sJGC,
	B_oJGC,
	C_iJGC,
	C_dJGC,
	C_sJGC,
	C_oJGC,
	D_iJGC,
	D_dJGC,
	D_sJGC,
	D_oJGC,
	A_JL,
	B_JL,
	C_JL,
	D_JL,
	A_iJL,
	A_dJL,
	A_sJL,
	A_oJL,
	B_iJL,
	B_dJL,
	B_sJL,
	B_oJL,
	C_iJL,
	C_dJL,
	C_sJL,
	C_oJL,
	D_iJL,
	D_dJL,
	D_sJL,
	D_oJL,
	A_iJLC,
	A_dJLC,
	A_sJLC,
	A_oJLC,
	B_iJLC,
	B_dJLC,
	B_sJLC,
	B_oJLC,
	C_iJLC,
	C_dJLC,
	C_sJLC,
	C_oJLC,
	D_iJLC,
	D_dJLC,
	D_sJLC,
	D_oJLC,
	A_JGE,
	B_JGE,
	C_JGE,
	D_JGE,
	A_iJGE,
	A_dJGE,
	A_sJGE,
	A_oJGE,
	B_iJGE,
	B_dJGE,
	B_sJGE,
	B_oJGE,
	C_iJGE,
	C_dJGE,
	C_sJGE,
	C_oJGE,
	D_iJGE,
	D_dJGE,
	D_sJGE,
	D_oJGE,
	A_iJGEC,
	A_dJGEC,
	A_sJGEC,
	A_oJGEC,
	B_iJGEC,
	B_dJGEC,
	B_sJGEC,
	B_oJGEC,
	C_iJGEC,
	C_dJGEC,
	C_sJGEC,
	C_oJGEC,
	D_iJGEC,
	D_dJGEC,
	D_sJGEC,
	D_oJGEC,
	A_JLE,
	B_JLE,
	C_JLE,
	D_JLE,
	A_iJLE,
	A_dJLE,
	A_sJLE,
	A_oJLE,
	B_iJLE,
	B_dJLE,
	B_sJLE,
	B_oJLE,
	C_iJLE,
	C_dJLE,
	C_sJLE,
	C_oJLE,
	D_iJLE,
	D_dJLE,
	D_sJLE,
	D_oJLE,
	A_iJLEC,
	A_dJLEC,
	A_sJLEC,
	A_oJLEC,
	B_iJLEC,
	B_dJLEC,
	B_sJLEC,
	B_oJLEC,
	C_iJLEC,
	C_dJLEC,
	C_sJLEC,
	C_oJLEC,
	D_iJLEC,
	D_dJLEC,
	D_sJLEC,
	D_oJLEC,
	A_JE,
	B_JE,
	C_JE,
	D_JE,
	A_iJE,
	A_dJE,
	A_sJE,
	A_oJE,
	B_iJE,
	B_dJE,
	B_sJE,
	B_oJE,
	C_iJE,
	C_dJE,
	C_sJE,
	C_oJE,
	D_iJE,
	D_dJE,
	D_sJE,
	D_oJE,
	A_iJEC,
	A_dJEC,
	A_sJEC,
	A_oJEC,
	B_iJEC,
	B_dJEC,
	B_sJEC,
	B_oJEC,
	C_iJEC,
	C_dJEC,
	C_sJEC,
	C_oJEC,
	D_iJEC,
	D_dJEC,
	D_sJEC,
	D_oJEC,
	A_JNE,
	B_JNE,
	C_JNE,
	D_JNE,
	A_iJNE,
	A_dJNE,
	A_sJNE,
	A_oJNE,
	B_iJNE,
	B_dJNE,
	B_sJNE,
	B_oJNE,
	C_iJNE,
	C_dJNE,
	C_sJNE,
	C_oJNE,
	D_iJNE,
	D_dJNE,
	D_sJNE,
	D_oJNE,
	A_iJNEC,
	A_dJNEC,
	A_sJNEC,
	A_oJNEC,
	B_iJNEC,
	B_dJNEC,
	B_sJNEC,
	B_oJNEC,
	C_iJNEC,
	C_dJNEC,
	C_sJNEC,
	C_oJNEC,
	D_iJNEC,
	D_dJNEC,
	D_sJNEC,
	D_oJNEC,
	A_RET,
	B_RET,
	C_RET,
	D_RET,
	A_iRET,
	A_dRET,
	A_sRET,
	A_oRET,
	B_iRET,
	B_dRET,
	B_sRET,
	B_oRET,
	C_iRET,
	C_dRET,
	C_sRET,
	C_oRET,
	D_iRET,
	D_dRET,
	D_sRET,
	D_oRET,
	A_WRITE,
	B_WRITE,
	C_WRITE,
	D_WRITE,
	A_iWRITE,
	A_dWRITE,
	A_sWRITE,
	A_oWRITE,
	B_iWRITE,
	B_dWRITE,
	B_sWRITE,
	B_oWRITE,
	C_iWRITE,
	C_dWRITE,
	C_sWRITE,
	C_oWRITE,
	D_iWRITE,
	D_dWRITE,
	D_sWRITE,
	D_oWRITE,
	A_CALL,
	B_CALL,
	C_CALL,
	D_CALL,
	A_iCALL,
	A_dCALL,
	A_sCALL,
	A_oCALL,
	B_iCALL,
	B_dCALL,
	B_sCALL,
	B_oCALL,
	C_iCALL,
	C_dCALL,
	C_sCALL,
	C_oCALL,
	D_iCALL,
	D_dCALL,
	D_sCALL,
	D_oCALL,
	A_SELFCALL,
	B_SELFCALL,
	C_SELFCALL,
	D_SELFCALL,
	A_iSELFCALL,
	A_dSELFCALL,
	A_sSELFCALL,
	A_oSELFCALL,
	B_iSELFCALL,
	B_dSELFCALL,
	B_sSELFCALL,
	B_oSELFCALL,
	C_iSELFCALL,
	C_dSELFCALL,
	C_sSELFCALL,
	C_oSELFCALL,
	D_iSELFCALL,
	D_dSELFCALL,
	D_sSELFCALL,
	D_oSELFCALL,
	A_SHIFT,
	B_SHIFT,
	C_SHIFT,
	D_SHIFT,
	A_iSHIFT,
	A_dSHIFT,
	A_sSHIFT,
	A_oSHIFT,
	B_iSHIFT,
	B_dSHIFT,
	B_sSHIFT,
	B_oSHIFT,
	C_iSHIFT,
	C_dSHIFT,
	C_sSHIFT,
	C_oSHIFT,
	D_iSHIFT,
	D_dSHIFT,
	D_sSHIFT,
	D_oSHIFT,
	A_PUSH,
	B_PUSH,
	C_PUSH,
	D_PUSH,
	A_iPUSH,
	A_dPUSH,
	A_sPUSH,
	A_oPUSH,
	B_iPUSH,
	B_dPUSH,
	B_sPUSH,
	B_oPUSH,
	C_iPUSH,
	C_dPUSH,
	C_sPUSH,
	C_oPUSH,
	D_iPUSH,
	D_dPUSH,
	D_sPUSH,
	D_oPUSH,
} GPerlOpCode;
