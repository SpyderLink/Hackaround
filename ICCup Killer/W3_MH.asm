; ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
    
	include \masm32\include\masm32rt.inc
    include \masm32\include\advapi32.inc 

    includelib \masm32\lib\advapi32.lib

; ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд

	PrintText       PROTO   pText:DWORD, pColor:DWORD, dur:DWORD

	DLL_INSTANCE	PROTO	hIN:DWORD
	
	MH_CreateMenu	PROTO
	MH_MainWNDPROC	PROTO	hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
	MH_CreateCB		PROTO	pCTRL:DWORD, pSTR:DWORD, num:DWORD
	
	MH_UpdateCHVal	PROTO	inifile:DWORD
	MH_ParseSET		PROTO
	MH_SaveSET		PROTO
	
    MH_HotkeyInst   PROTO
	MH_Install		PROTO	gameptr:DWORD
    MH_DoTheJob     PROTO   gameptr:DWORD, domh:DWORD
	MH_Hook			PROTO	lpBase:DWORD
	
	MB_Hook			PROTO	lpBase:DWORD
	MB_Install		PROTO	lpGame:DWORD
	
	IsInGame		PROTO
	
	GreyHPFunc		PROTO
	ColoredInviFunc	PROTO
	RoshanNotifierFunc	PROTO
	RuneNotifierFunc	PROTO
	MineWardNotifierFunc	PROTO
	MHDetectFunc	PROTO
	
	InitGameMod     PROTO
    jGetDamageEvent PROTO
	
	f00152750		PROTO
	f001527C0		PROTO
	f152950			PROTO
	f152980			PROTO
	f00152710		PROTO
	f001527F0		PROTO
	f00152930		PROTO
	
	HPMP_MS			PROTO
	HPMP_AS			PROTO
	HPMP_HP			PROTO
	HPMP_MP			PROTO
	HPMP_DRAW		PROTO
	
	LPH_IPA			PROTO
	LPH_IPE			PROTO
	LPH_HOOK		PROTO
	
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

    Button_GetCheck MACRO hWnd
		push	0
		push	0
		push	BM_GETCHECK
		push	hWnd
        call	SendMessage
    ENDM
	
    Button_SetCheck MACRO hWnd, num
		push	0
		push	num
		push	BM_SETCHECK
		push	hWnd
        call	SendMessage
    ENDM
	
	OPTION proc:public
	
	.data

	hInstance	dd	0
	
; ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
;					MANABARS & MAPHACK & DAMAGE & HPMP
; ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
	
	g16FF24	dd	0
	g16FF68	dd	0
	a16FF64	dd	0
	a16FF5C	dd	0
	a16FF58	dd	0
	a16FF20	dd	0
	a16F088	dd	0
	a2C7F10	dd	0
	a16F08C	dd	0
	a16F004	dd	0
	a1698A0	dd	0
	a16F090	dd	0
	a16F06C	dd	0
	a16F070	dd	0
	a3000AC	dd	0
	a3000B0	dd	0

	a16F008 db	80h dup(0)

	a164684 db	"scaleFactor",0

	a164A18	dq	72.0
	a164A10 dq	0.0005000000237487257
	a164A08 dq	0.006000000052154064
	a1649D4 dq	0.03000000
	a1649D0 dq	0.004000000
	a1649CC dq	0.3000000
	
	a6F37A563	dd	0
	a6F37A968	dd	0
	
	hGameP		dd	0
	hStorm503	dd	0
	hStorm578	dd	0
	hGameAB7788	dd	0
	hGame815DA6	dd	0
	hGameAAE140	dd	0
	
	LPH_DoHook	dd	0
	LPH_FNCUR	dd	0
	LPH_FNOLD	dd	0
	
	PrintClr	dd  0FFFFFFFFh
	ptGameState	dd	0h
		
	pClassOffset			dd	0
	ColorUnit				dd	0
	ColoredInviOriCall		dd	0
	ColoredInviRet			dd	0
	RuneNotifierBack		dd	0
	RoshanNotifierOriCall	dd	0
	RoshanNotifierBack		dd	0
	MineWardNotifierBack	dd	0
	MHDetectFuncBack		dd	0
	
	PingMinimap				dd	0
	PingMinimapEx			dd	0
	
	sStorm	db	"storm.dll",0
	sRoshan	db	"|cffffcc00[IK3.0r5]|r: Roshan respawned!",0
	sIT		db	"|cffffcc00[IK3.0r5]|r: |cFFFFFC01Illusion|r rune spawned at the |cFFCC99FFtop|r spot.",0
	sIB		db	"|cffffcc00[IK3.0r5]|r: |cFFFFFC01Illusion|r rune spawned at the |cFFFFFFCCbot|r spot.",0
	sHT		db	"|cffffcc00[IK3.0r5]|r: |cFFFF0303Haste|r rune spawned at the |cFFCC99FFtop|r spot.",0
	sHB		db	"|cffffcc00[IK3.0r5]|r: |cFFFF0303Haste|r rune spawned at the |cFFFFFFCCbot|r spot.",0
	sDT		db	"|cffffcc00[IK3.0r5]|r: |cFF0042FFDouble Damage|r rune spawned at the |cFFCC99FFtop|r spot.",0
	sDB		db	"|cffffcc00[IK3.0r5]|r: |cFF0042FFDouble Damage|r rune spawned at the |cFFFFFFCCbot|r spot.",0
	sRT		db	"|cffffcc00[IK3.0r5]|r: |cFF00FF00Regeneration|r rune spawned at the |cFFCC99FFtop|r spot.",0
	sRB		db	"|cffffcc00[IK3.0r5]|r: |cFF00FF00Regeneration|r rune spawned at the |cFFFFFFCCbot|r spot.",0
	sINT	db	"|cffffcc00[IK3.0r5]|r: |cFF99CCFFInvisibility|r rune spawned at the |cFFCC99FFtop|r spot.",0
	sINB	db	"|cffffcc00[IK3.0r5]|r: |cFF99CCFFInvisibility|r rune spawned at the |cFFFFFFCCbot|r spot.",0
	sMINE	db	"|cffffcc00[IK3.0r5]|r: |cFFFF0303Land Mine|r planted!",0
	sSTASIS	db	"|cffffcc00[IK3.0r5]|r: |cFFFF0303Statis Trap|r planted!",0
	sREMOTE	db	"|cffffcc00[IK3.0r5]|r: |cFFFF0303Remote Mine|r planted!",0
	sOWARD	db	"|cffffcc00[IK3.0r5]|r: |cFFFFFC01Observer Ward|r planted!",0
	sSWARD	db	"|cffffcc00[IK3.0r5]|r: |cFF0042FFSentry Ward|r planted!",0
	sBOWARD	db	"|cffffcc00[IK3.0r5]|r: |cFFFFFC01Observer Wards|r has been bought!",0
	sBSWARD	db	"|cffffcc00[IK3.0r5]|r: |cFF0042FFSentry Wards|r has been bought!",0
	sBDUST	db	"|cffffcc00[IK3.0r5]|r: |cFFFFFC01Dust of Appearance|r has been bought!",0
	sBGEM	db	"|cffffcc00[IK3.0r5]|r: |cFF00FF00Gem of True Sight|r has been bought!",0
	
	roshanX			dd	2450.0
	roshanY			dd	-730.0
	roshanDuration	dd	5.0
	
	runeXTop		dd	-2400.0
	runeYTop		dd	1600.0
	runeXBot		dd	2970.0
	runeYBot		dd	-2850.0
	runeDuration	dd	5.0
	
	minewardDuration	dd	5.0
	
	fCamera			dd	2100.0
	fCameraADD		dd	100.0
	
	_STR_spFLOAT    db  "%.2f",0
    _STR_w3WTF1     db  "?AUString2HandleReg@@",0
	_STR_CTT		db	"CreateTextTag",0
	_STR_speed		db	"%0.02f",0
	_STR_HPMPFMT	db	"%s",0Ah,"   |cffffcc00HP/MP Regen:|r",0Ah,"      |cff00ff00%0.02f|r/|cff1122ff%0.02f|r",0
	_STR_IPA		db	"IsPlayerAlly",0
	_STR_IPE		db	"IsPlayerEnemy",0
	_STR_GLP		db	"GetLocalPlayer",0
	
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

    _WT_tt          db  ")Htexttag;",0
    _WT_r           db  ")R",0
    _WT_u           db  ")Hunit;",0
    _WT_v           db  ")V",0
    _WT_s           db  ")S",0

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

    pGame_jGetEventDamage       dd  03C3C40h
    pGame_jGetEventTargetUnit   dd  03C3D00h
    pGame_jGetTriggerUnit       dd  03BB240h
    pGame_jCreateTextTag        dd  03BC580h
    pGame_jSetTextTagText       dd  03BC5D0h
    pGame_jSetTextTagPosUnit    dd  03CB890h
    pGame_jSetTextTagColor      dd  03BC6A0h
    pGame_jSetTextTagPermanent  dd  03BC7C0h
    pGame_jSetTextTagVelocity   dd  03BC700h
    pGame_jSetTextTagLifespan   dd  03BC820h
    pGame_jSetTextTagFadepoint  dd  03BC850h
    pGame_jSetTextTagVisibility dd  03BC760h
    pGame_jSetTextTagPos        dd  03BC610h
    pGame_jSetTextTagSuspended  dd  03BC790h
    pGame_jR2S                  dd  03BAAF0h
	pGame_p459150				dd	0459150h
	pGame_jIsUnitVisible		dd  03C7AF0h
	pGame_jPlayer				dd	03BBB30h

	isNDMGVARSET				dd	0h
	
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

    float_003       dd  0.03
    float_0         dd  0.0
    float_05		dd  0.05
    float_1         dd  1.0
    float_2         dd  2.0
	
	hUnitHP			dd	0.0
	hUnitMP			dd	0.0
	
; ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд

	isWindowReady	dd	0

	hW3Main			dd	0
	hMHMain			dd	0
	hMHMainBG		dd	0
	hMHSVBTN		dd	0
	hMHCLSBTN		dd	0

	_M_STR_W3		db	"Warcraft III",0
	_M_STR_MH		db	"ICCup Killer 3.0",0
	_M_STR_MAINBG	db	"MAINBG",0
	_M_STR_CMH		db	"MHMain",0
	_M_STR_CBTN		db	"BUTTON",0
	_M_STR_CEDIT	db	"EDIT",0
	_M_STR_CSTATIC	db	"STATIC",0
	_M_STR_SVBTN	db	"Save",0
	_M_STR_CLSBTN	db	"Close",0
	
	hMHUMAIN		dd	0
	hMHFMAIN		dd	0
	hMHUMINI		dd	0
	hMHFMINI		dd	0
	hMHTRADE		dd	0
	hMHCLICK		dd	0
	hMHILLUS		dd	0
	hMHRUNES		dd	0
	hMHSKLSCD		dd	0
	hMHBYPASSAH		dd	0
	hMHPINGS		dd	0
	hMHLCLPL		dd	0
	hMHCAMHACK		dd	0
	hMHCAMHACKE		dd	0
	hMHGREYHP		dd	0
	hMHNROSHAN		dd	0
	hMHNRUNES		dd	0
	hMHNCLRINV		dd	0
	hMHNDMG			dd	0
	hMHNMINE		dd	0
	hMHHPMP			dd	0
	hMHMANABAR		dd	0
	
	
	_M_STR_UMAIN	db	"Units mainmap",0
	_M_STR_FMAIN	db	"NoFog mainmap",0
	_M_STR_UMINI	db	"Units minimap",0
	_M_STR_FMINI	db	"NoFog minimap",0
	_M_STR_TRADE	db	"Enable trade",0
	_M_STR_CLICK	db	"Enable click in fog",0
	_M_STR_ILLUS	db	"Show illusions and invisible",0
	_M_STR_RUNES	db	"Show runes",0
	_M_STR_SKLSCD	db	"Show skills and cooldowns",0
	_M_STR_BYPASSAH	db	"Bypass DotA -ah",0
	_M_STR_PINGS	db	"Show enemy pings",0
	_M_STR_LCLPL	db	"LocalPlayer hack",0
	_M_STR_CAMHACK	db	"CameraHack:",0
	_M_STR_GREYHP	db	"GreyHP in fog",0
	_M_STR_NROSHAN	db	"Roshan notifier",0
	_M_STR_NRUNES	db	"Runes notifier",0
	_M_STR_NCLRINV	db	"Colored invisible",0
	_M_STR_NDMG		db	"Damage notifier",0
	_M_STR_NMINE	db	"Mine-Item notifier",0
	_M_STR_HPMP		db	"HP/MP regeneration",0
	_M_STR_MANABAR	db	"Manabars",0

	_M_STR_READ		db	"r",0
	_M_STR_WRITE	db	"w",0
	_M_STR_FILENAME	db	"ik3settings.ini",0
	_M_STR_SETTINGS	db	"%d %d %d %d %d %d %d %d %d %d %d %d %d %f %d %d %d %d %d %d %d %d",0
	_M_STR_FLOATF	db	"%f",0
	
; ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд

	.data?
	oldprot			dd	?
	tempstr			db	256	dup(?)

	.code

DLL_INSTANCE	proc	hIN:DWORD

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

	mov		eax, dword ptr ss:[esp+4]
	mov		hInstance, eax
	ret

DLL_INSTANCE	endp
	
; ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд	
	
MH_CreateMenu	proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

LOCAL wc	:WNDCLASSEX
LOCAL msg	:MSG
	
	;@lA:
	;jmp	@lA
	
	push	ebp
	mov		ebp, esp
	
	sub		esp, sizeof WNDCLASSEX
	sub		esp, sizeof	MSG

	mov		wc.cbSize, sizeof WNDCLASSEX
	mov		wc.style, CS_HREDRAW or CS_VREDRAW
	lea		eax, MH_MainWNDPROC
	mov		wc.lpfnWndProc, eax
	mov		wc.cbClsExtra, 0
	mov		wc.cbWndExtra, 0
	mov		eax, hInstance
	mov		wc.hInstance, eax
	mov		wc.hbrBackground, COLOR_BTNFACE+1
	mov		wc.lpszMenuName, 0
	lea		eax, _M_STR_CMH
	mov		wc.lpszClassName, eax
	mov		wc.hIcon, 0
	mov		wc.hCursor, 0
	mov		wc.hIconSm, 0

	lea		eax, wc
	push	eax
	call	RegisterClassEx 
	
	lea		eax, _M_STR_W3
	push	eax
	push	0
	call	FindWindow
	mov		hW3Main, eax
	
	push	0
	push	hInstance
	push	0
	push	hW3Main
	push	600							;height
	push	250							;width
	push	200							;screen coords y
	push	200							;screen	coords x
	push	WS_BORDER
	lea		eax, _M_STR_MH
	push	eax
	lea		eax, _M_STR_CMH
	push	eax							;classname
	push	0
	call	CreateWindowEx
	mov		hMHMain, eax

	push	0
	push	hInstance
	push	0
	push	hMHMain
	push	600							;height
	push	250							;width
	push	0							;screen coords y
	push	0							;screen	coords x
	push	WS_CHILD or WS_VISIBLE or SS_BITMAP
	lea		eax, _M_STR_MAINBG
	push	eax
	lea		eax, _M_STR_CSTATIC
	push	eax							;classname
	push	0
	call	CreateWindowEx
	mov		hMHMainBG, eax
		
	push	0
	push	hInstance
	push	0
	push	hMHMain
	push	25
	push	75
	push	600-50-10
	push	10
	push	WS_CHILD or WS_VISIBLE
	lea		eax, _M_STR_SVBTN
	push	eax
	lea		eax, _M_STR_CBTN
	push	eax
	push	0
	call	CreateWindowEx
	mov		hMHSVBTN, eax

	push	0
	push	hInstance
	push	0
	push	hMHMain
	push	25
	push	75
	push	600-50-10
	push	250-90
	push	WS_CHILD or WS_VISIBLE
	lea		eax, _M_STR_CLSBTN
	push	eax
	lea		eax, _M_STR_CBTN
	push	eax
	push	0
	call	CreateWindowEx
	mov		hMHCLSBTN, eax
	
	push	0
	lea		eax, _M_STR_UMAIN
	push	eax
	lea		eax, hMHUMAIN
	push	eax
	call	MH_CreateCB
	
	push	1
	lea		eax, _M_STR_FMAIN
	push	eax
	lea		eax, hMHFMAIN
	push	eax
	call	MH_CreateCB
	
	push	2
	lea		eax, _M_STR_UMINI
	push	eax
	lea		eax, hMHUMINI
	push	eax
	call	MH_CreateCB
	
	push	3
	lea		eax, _M_STR_FMINI
	push	eax
	lea		eax, hMHFMINI
	push	eax
	call	MH_CreateCB
	
	push	4
	lea		eax, _M_STR_TRADE
	push	eax
	lea		eax, hMHTRADE
	push	eax
	call	MH_CreateCB

	push	5
	lea		eax, _M_STR_CLICK
	push	eax
	lea		eax, hMHCLICK
	push	eax
	call	MH_CreateCB
	
	push	6
	lea		eax, _M_STR_ILLUS
	push	eax
	lea		eax, hMHILLUS
	push	eax
	call	MH_CreateCB

	push	7
	lea		eax, _M_STR_RUNES
	push	eax
	lea		eax, hMHRUNES
	push	eax
	call	MH_CreateCB
	
	push	8
	lea		eax, _M_STR_SKLSCD
	push	eax
	lea		eax, hMHSKLSCD
	push	eax
	call	MH_CreateCB

	push	9
	lea		eax, _M_STR_BYPASSAH
	push	eax
	lea		eax, hMHBYPASSAH
	push	eax
	call	MH_CreateCB
	
	push	10
	lea		eax, _M_STR_PINGS
	push	eax
	lea		eax, hMHPINGS
	push	eax
	call	MH_CreateCB

	push	11
	lea		eax, _M_STR_LCLPL
	push	eax
	lea		eax, hMHLCLPL
	push	eax
	call	MH_CreateCB
	
	push	12
	lea		eax, _M_STR_CAMHACK
	push	eax
	lea		eax, hMHCAMHACK
	push	eax
	call	MH_CreateCB

	push	13
	lea		eax, _M_STR_GREYHP
	push	eax
	lea		eax, hMHGREYHP
	push	eax
	call	MH_CreateCB

	push	14
	lea		eax, _M_STR_NROSHAN
	push	eax
	lea		eax, hMHNROSHAN
	push	eax
	call	MH_CreateCB
	
	push	15
	lea		eax, _M_STR_NRUNES
	push	eax
	lea		eax, hMHNRUNES
	push	eax
	call	MH_CreateCB

	push	16
	lea		eax, _M_STR_NCLRINV
	push	eax
	lea		eax, hMHNCLRINV
	push	eax
	call	MH_CreateCB
	
	push	17
	lea		eax, _M_STR_NDMG
	push	eax
	lea		eax, hMHNDMG
	push	eax
	call	MH_CreateCB

	push	18
	lea		eax, _M_STR_NMINE
	push	eax
	lea		eax, hMHNMINE
	push	eax
	call	MH_CreateCB
	
	push	19
	lea		eax, _M_STR_HPMP
	push	eax
	lea		eax, hMHHPMP
	push	eax
	call	MH_CreateCB
	
	push	20
	lea		eax, _M_STR_MANABAR
	push	eax
	lea		eax, hMHMANABAR
	push	eax
	call	MH_CreateCB	
	
	push	0
	push	hInstance
	push	0
	push	hMHCAMHACK
	push	15
	push	100
	push	5
	push	225-100
	push	WS_CHILD or WS_VISIBLE or ES_NUMBER or ES_CENTER
	push	0
	lea		eax, _M_STR_CEDIT
	push	eax
	push	0
	call	CreateWindowEx
	mov		hMHCAMHACKE, eax
	
	push	hMHMain
	call	UpdateWindow
	
	mov		isWindowReady, 1
	
@StartLoop:
	push	0
	push	0
	push	0
	lea		eax, msg
	push	eax
	call	GetMessage

	test	eax, eax
	je		@ExitLoop

	lea		eax, msg
	push	eax
	call	TranslateMessage
	
	lea		eax, msg
	push	eax
	call	DispatchMessage	
	
	jmp 	@StartLoop
	
@ExitLoop:
	mov		eax, msg.wParam
	
	add		esp, sizeof WNDCLASSEX
	add		esp, sizeof	MSG
	
	pop		ebp
	ret

MH_CreateMenu	endp

; ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд

MH_MainWNDPROC	proc	hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

	push	ebp
	mov		ebp, esp

	.if uMsg == WM_COMMAND
		mov   eax, wParam
		shr   eax, 16
		.if	eax	== BN_CLICKED
			mov	eax, lParam
			.if	eax == hMHSVBTN
				;save set
				
				push	1
				push	hGameP
				call	MH_DoTheJob
				add		esp, 8h

				push	0
				call	MH_UpdateCHVal
				add		esp, 4h
				
				call	MH_SaveSET
				
				push	SW_HIDE
				push	hMHMain
				call	ShowWindow

				push	SW_RESTORE
				push	hW3Main
				call	ShowWindow

				push	hW3Main
				call	SetForegroundWindow				
			.elseif	eax == hMHCLSBTN
				push	SW_HIDE
				push	hMHMain
				call	ShowWindow

				push	SW_RESTORE
				push	hW3Main
				call	ShowWindow

				push	hW3Main
				call	SetForegroundWindow
			.endif
		.endif
	.elseif uMsg == WM_CREATE

	.elseif uMsg == WM_CLOSE

	.elseif uMsg == WM_DESTROY
		push	0
		call	PostQuitMessage
		xor		eax, eax
		pop		ebp
		ret
	.elseif	uMsg == WM_CTLCOLORSTATIC
		push	lParam
		push	wParam
		push	uMsg
		push	hWin
		call	DefWindowProc
		
		push	eax
		call	DeleteObject

		push	TRANSPARENT
		push	wParam
		call	SetBkMode

		push	00FFFFFFh
		push	wParam
		call	SetTextColor
		
		push	NULL_BRUSH
		call	GetStockObject
		
		pop		ebp
		ret
	.endif

	push	lParam
	push	wParam
	push	uMsg
	push	hWin
	call	DefWindowProc

	pop		ebp
	ret

MH_MainWNDPROC	endp

; ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд

MH_CreateCB		proc	pCTRL:DWORD, pSTR:DWORD, num:DWORD

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE
	
	push	ebp
	mov		ebp, esp
	
	push	0
	push	hInstance
	push	0
	push	hMHMain
	push	25
	push	225
	mov		eax, 25
	mul		num
	add		eax, 10
	push	eax
	push	10
	push	WS_CHILD or WS_VISIBLE or BS_AUTOCHECKBOX
	mov		eax, pSTR
	push	eax
	lea		eax, _M_STR_CBTN
	push	eax
	push	WS_EX_TRANSPARENT
	call	CreateWindowEx
	mov		ecx, pCTRL
	mov		dword ptr ds:[ecx], eax	
	
	pop		ebp
	
	pop		eax
	add		esp, 0Ch
	push	eax
	
	ret

MH_CreateCB		endp

; ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд

MH_UpdateCHVal	proc	inifile:DWORD

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

	push	ebp
	mov		ebp, esp
    
	cmp		inifile, 0
	je		@fromgui
		sub		esp, 8h	
		fld		dword ptr ss:[fCamera]
		fstp	qword ptr ss:[esp]
		lea		eax, _M_STR_FLOATF
		push	eax
		lea		eax, tempstr
		push	eax
		call	crt_sprintf
		add		esp, 10h

		lea		eax, tempstr
		push	eax
		push	hMHCAMHACKE
		call	SetWindowText
		
		jmp		@procend
		
@fromgui:
		push	256
		lea		eax, tempstr
		push	eax
		push	hMHCAMHACKE
		call	GetWindowText
		
		lea		eax, fCamera
		push	eax
		lea		eax, _M_STR_FLOATF
		push	eax
		lea		eax, tempstr
		push	eax
		call	crt_sscanf
		add		esp, 0Ch

@procend:	
	pop		ebp
	ret

MH_UpdateCHVal	endp

; ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд

MH_ParseSET		proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

	push	ebp
	mov		ebp, esp
	
	sub		esp, 4h
	
	lea		eax, _M_STR_READ
	push	eax
	lea		eax, _M_STR_FILENAME
	push	eax
	call	crt_fopen
	mov		dword ptr ss:[ebp-4], eax
	add		esp, 8h
	test	eax, eax
	je		@ffail
		
	sub		esp, 54h
	mov		ecx, esp
	
	push	ecx
	add		ecx, 4h
	push	ecx
	add		ecx, 4h
	push	ecx
	add		ecx, 4h
	push	ecx
	add		ecx, 4h
	push	ecx
	add		ecx, 4h
	push	ecx
	add		ecx, 4h
	push	ecx
	add		ecx, 4h
	push	ecx
	add		ecx, 4h
	lea		eax, fCamera
	push	eax
	push	ecx
	add		ecx, 4h
	push	ecx
	add		ecx, 4h
	push	ecx
	add		ecx, 4h
	push	ecx
	add		ecx, 4h
	push	ecx
	add		ecx, 4h
	push	ecx
	add		ecx, 4h
	push	ecx
	add		ecx, 4h
	push	ecx
	add		ecx, 4h
	push	ecx
	add		ecx, 4h
	push	ecx
	add		ecx, 4h
	push	ecx
	add		ecx, 4h
	push	ecx
	add		ecx, 4h
	push	ecx	
	lea		eax, _M_STR_SETTINGS
	push	eax
	push	dword ptr ss:[ebp-4]
	call	crt_fscanf
	add		esp, 8h+54h+4h

	mov		ecx, esp
	push	ecx
	Button_SetCheck	hMHMANABAR, dword ptr ss:[ecx]
	pop		ecx
	add		ecx, 4h
	push	ecx
	Button_SetCheck	hMHHPMP, dword ptr ss:[ecx]
	pop		ecx
	add		ecx, 4h
	push	ecx
	Button_SetCheck	hMHNMINE, dword ptr ss:[ecx]
	pop		ecx
	add		ecx, 4h
	push	ecx
	Button_SetCheck	hMHNDMG, dword ptr ss:[ecx]
	pop		ecx
	add		ecx, 4h
	push	ecx
	Button_SetCheck	hMHNCLRINV, dword ptr ss:[ecx]
	pop		ecx
	add		ecx, 4h
	push	ecx
	Button_SetCheck	hMHNRUNES, dword ptr ss:[ecx]
	pop		ecx
	add		ecx, 4h
	push	ecx
	Button_SetCheck	hMHNROSHAN, dword ptr ss:[ecx]
	pop		ecx
	add		ecx, 4h
	push	ecx
	Button_SetCheck	hMHGREYHP, dword ptr ss:[ecx]
	pop		ecx
	add		ecx, 4h
	push	ecx
	Button_SetCheck	hMHCAMHACK, dword ptr ss:[ecx]
	pop		ecx
	add		ecx, 4h
	push	ecx
	Button_SetCheck	hMHLCLPL, dword ptr ss:[ecx]
	pop		ecx
	add		ecx, 4h
	push	ecx
	Button_SetCheck	hMHPINGS, dword ptr ss:[ecx]
	pop		ecx
	add		ecx, 4h
	push	ecx
	Button_SetCheck	hMHBYPASSAH, dword ptr ss:[ecx]
	pop		ecx
	add		ecx, 4h
	push	ecx
	Button_SetCheck	hMHSKLSCD, dword ptr ss:[ecx]
	pop		ecx
	add		ecx, 4h
	push	ecx
	Button_SetCheck	hMHRUNES, dword ptr ss:[ecx]
	pop		ecx
	add		ecx, 4h
	push	ecx
	Button_SetCheck	hMHILLUS, dword ptr ss:[ecx]
	pop		ecx
	add		ecx, 4h
	push	ecx
	Button_SetCheck	hMHCLICK, dword ptr ss:[ecx]
	pop		ecx
	add		ecx, 4h
	push	ecx
	Button_SetCheck	hMHTRADE, dword ptr ss:[ecx]
	pop		ecx
	add		ecx, 4h
	push	ecx
	Button_SetCheck	hMHFMINI, dword ptr ss:[ecx]
	pop		ecx
	add		ecx, 4h
	push	ecx
	Button_SetCheck	hMHUMINI, dword ptr ss:[ecx]
	pop		ecx
	add		ecx, 4h
	push	ecx
	Button_SetCheck	hMHFMAIN, dword ptr ss:[ecx]
	pop		ecx
	add		ecx, 4h
	Button_SetCheck	hMHUMAIN, dword ptr ss:[ecx]
	
	add		esp, 54h
	
	push	dword ptr ss:[ebp-4]
	call	crt_fclose
	add		esp, 4h
	
	push	1
	call	MH_UpdateCHVal
	add		esp, 4h
	
@ffail:
	add		esp, 4h	
	
	pop		ebp
	ret

MH_ParseSET		endp

; ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд

MH_SaveSET		proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

	push	ebp
	mov		ebp, esp
	
	sub		esp, 4h
	
	lea		eax, _M_STR_WRITE
	push	eax
	lea		eax, _M_STR_FILENAME
	push	eax
	call	crt_fopen
	mov		dword ptr ss:[ebp-4], eax
	add		esp, 8h
	
	Button_GetCheck	hMHMANABAR
	push	eax
	Button_GetCheck	hMHHPMP
	push	eax
	Button_GetCheck	hMHNMINE
	push	eax
	Button_GetCheck	hMHNDMG
	push	eax
	Button_GetCheck	hMHNCLRINV
	push	eax
	Button_GetCheck	hMHNRUNES
	push	eax
	Button_GetCheck	hMHNROSHAN
	push	eax
	Button_GetCheck	hMHGREYHP
	push	eax
	sub		esp, 8h
	fld		dword ptr ds:[fCamera]
	fstp	qword ptr ss:[esp]
	Button_GetCheck	hMHCAMHACK
	push	eax
	Button_GetCheck	hMHLCLPL
	push	eax
	Button_GetCheck	hMHPINGS
	push	eax
	Button_GetCheck	hMHBYPASSAH
	push	eax
	Button_GetCheck	hMHSKLSCD
	push	eax
	Button_GetCheck	hMHRUNES
	push	eax
	Button_GetCheck	hMHILLUS
	push	eax
	Button_GetCheck	hMHCLICK
	push	eax
	Button_GetCheck	hMHTRADE
	push	eax
	Button_GetCheck	hMHFMINI
	push	eax
	Button_GetCheck	hMHUMINI
	push	eax
	Button_GetCheck	hMHFMAIN
	push	eax
	Button_GetCheck	hMHUMAIN
	push	eax
	lea		eax, _M_STR_SETTINGS
	push	eax
	push	dword ptr ss:[ebp-4]
	call	crt_fprintf
	add		esp, 8h+54h+8h
	
	push	dword ptr ss:[ebp-4]
	call	crt_fclose
	add		esp, 4h
	
	add		esp, 4h
	
	pop		ebp
	ret

MH_SaveSET		endp

; ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
	
MH_HotkeyInst   proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

LOCAL   msg:MSG

	push	ebp
	mov		ebp, esp
	  
	sub		esp, sizeof MSG
		
    push	VK_F1
    push	MOD_CONTROL
    push	1339
    push	0
    call	RegisterHotKey
 
    push	VK_ADD
    push	MOD_CONTROL
    push	1337
    push	0
    call	RegisterHotKey

    push	VK_SUBTRACT
    push	MOD_CONTROL
    push	1338
    push	0
    call	RegisterHotKey
	  
@loop_1:
    push	0
    push	0
    push	0
    lea		eax, msg
    push	eax
    call	GetMessage
      
    test	eax, eax
    je		@loop_1_e
      
    cmp		[msg].message, WM_HOTKEY
    jne		@loop_1

    mov		eax, [msg].lParam
    shr		eax, 16

    cmp		eax, VK_ADD
    jne		@loop_1_s1
	 fld	dword ptr ds:[fCameraADD]
	 fld	dword ptr ds:[fCamera]
	 fsub	st(0), st(1)
	 fstp	dword ptr ds:[fCamera]
	 ffree	st(0)
	 fwait

	 push	1
	 call	MH_UpdateCHVal
	 add	esp, 4h
	jmp		@loop_1
@loop_1_s1:
    cmp		eax, VK_SUBTRACT
    jne		@loop_1_s2
	 fld	dword ptr ds:[fCameraADD]
	 fld	dword ptr ds:[fCamera]
	 fadd	st(0), st(1)
	 fstp	dword ptr ds:[fCamera]
	 ffree	st(0)
	 fwait

	 push	1
	 call	MH_UpdateCHVal
	 add	esp, 4h
    jmp		@loop_1
@loop_1_s2:
	cmp		eax, VK_F1
	jne		@loop_1
	 push	SW_MINIMIZE
	 push	hW3Main
	 call	ShowWindow
	
	 push	SW_SHOW
	 push	hMHMain
	 call	ShowWindow
	   
	 push	hMHMain
	 call	SetForegroundWindow
	jmp		@loop_1
	  

@loop_1_e:
    push	1337
    push	0
    call	UnregisterHotKey

    push	1338
    push	0
    call	UnregisterHotKey
	  
	push	0
	call	ExitThread

MH_HotkeyInst   endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

MH_Install		proc   gameptr:DWORD

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE
		
	mov		eax, dword ptr ss:[esp+4]
	mov		dword ptr ds:[hGameP], eax
	  
	push	eax
	add		eax, 0AB65F4h
	mov		dword ptr ds:[pClassOffset], eax
	pop		eax
	  
	push	eax
	add		eax, 4D3220h
	mov		dword ptr ds:[ColorUnit], eax
	pop		eax
  
	push	eax
	add		eax, 2AB710h
	mov		dword ptr ds:[ColoredInviOriCall], eax
	pop		eax

	push	eax
	add		eax, 39999Ah
	mov		dword ptr ds:[ColoredInviRet], eax
	pop		eax

	push	eax
	add		eax, 3BB9ACh
	mov		dword ptr ds:[RuneNotifierBack], eax
	pop		eax

	push	eax
	add		eax, 3B28F0h
	mov		dword ptr ds:[RoshanNotifierOriCall], eax
	pop		eax	  
	 
	push	eax
	add		eax, 3C5237h
	mov		dword ptr ds:[RoshanNotifierBack], eax
	pop		eax	  
	  
	push	eax
	add		eax, 3B4650h
	mov		dword ptr ds:[PingMinimap], eax
	pop		eax
	  
	push	eax
	add		eax, 3B8660h
	mov		dword ptr ds:[PingMinimapEx], eax
	pop		eax
	  
	push	eax
	add		eax, 0AB5738h
    mov		dword ptr ds:[ptGameState], eax 
	pop		eax

	push	eax
	add		eax, 03C7AF0h
    mov		dword ptr ds:[pGame_jIsUnitVisible], eax 
	pop		eax
	
	push	eax
	add		eax, 03BBB30h
    mov		dword ptr ds:[pGame_jPlayer], eax 
	pop		eax	

	push	eax
	add		eax, 06EB5BEh
    mov		dword ptr ds:[hStorm503], eax 
	pop		eax
	
	push	eax
	add		eax, 06EB5A6h
    mov		dword ptr ds:[hStorm578], eax 
	pop		eax
	
	push	eax
	add		eax, 0AB7788h
    mov		dword ptr ds:[hGameAB7788], eax 
	pop		eax	
	
	push	eax
	add		eax, 0815DA6h
    mov		dword ptr ds:[hGame815DA6], eax 
	pop		eax		

	push	eax
	add		eax, 0AAE140h
    mov		dword ptr ds:[hGameAAE140], eax 
	pop		eax
	
	push	eax
	add		eax, 029F997h
    mov		dword ptr ds:[MineWardNotifierBack], eax 
	pop		eax
	
	push	eax

    push	0
    push	0
    push	0
    push	MH_CreateMenu
    push	0
    push	0
    call	CreateThread
	
@stay_calm:
	cmp		isWindowReady, 0
	je		@stay_calm
	
	call	MH_ParseSET
	
	pop		eax
	
	push	1
	push	eax
	call	MH_DoTheJob
	add		esp, 8h
	
    push	0
    push	0
    push	0
    push	MH_HotkeyInst
    push	0
    push	0
    call	CreateThread
	  
	ret

MH_Install		endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

MH_DoTheJob     proc   gameptr:DWORD, domh:DWORD

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

    mov		eax, dword ptr ss:[esp+4]
	
;UNITS MAINMAP
	
	push	eax
	
	Button_GetCheck hMHUMAIN
	.if	eax == BST_CHECKED
	  pop	eax
      mov   byte ptr ds:[eax+3A14F0h], 87h
      mov   byte ptr ds:[eax+3A14F1h], 0DBh           
      mov   byte ptr ds:[eax+3A159Bh], 87h
      mov   byte ptr ds:[eax+3A159Ch], 0DBh   
	.else
	  pop	eax
      mov   byte ptr ds:[eax+3A14F0h], 0EBh
      mov   byte ptr ds:[eax+3A14F1h], 09h           
      mov   byte ptr ds:[eax+3A159Bh], 23h
      mov   byte ptr ds:[eax+3A159Ch], 0CAh 	  
	.endif
	
;FOG MAINMAP
	
	push	eax
	
	Button_GetCheck	hMHFMAIN
	.if	eax == BST_CHECKED
	  pop	eax
      mov   byte ptr ds:[eax+74CA1Ah], 15h	;full map
      mov   byte ptr ds:[eax+74CA1Bh], 50h 

	  ;mov	byte ptr ds:[eax+74C9F1h], 68h	;player view
	  ;mov	byte ptr ds:[eax+74C9F2h], 0FFh
	  ;mov	byte ptr ds:[eax+74C9F3h], 0F0h
	  ;mov	byte ptr ds:[eax+74C9F4h], 00h
	  ;mov	byte ptr ds:[eax+74C9F5h], 00h
	.else
	  pop	eax
      mov   byte ptr ds:[eax+74CA1Ah], 90h
      mov   byte ptr ds:[eax+74CA1Bh], 4Ch 	  
	.endif
	
;UNITS MINIMAP
	
	push	eax
	
	Button_GetCheck	hMHUMINI
	.if	eax	== BST_CHECKED
	  pop	eax
      mov   byte ptr ds:[eax+36143Bh], 33h
      mov   byte ptr ds:[eax+36143Ch], 0C0h  
      mov   byte ptr ds:[eax+36143Dh], 90h
      mov   byte ptr ds:[eax+36143Eh], 90h  
      mov   byte ptr ds:[eax+36143Fh], 90h
	.else
	  pop	eax
      mov   byte ptr ds:[eax+36143Bh], 0B8h
      mov   byte ptr ds:[eax+36143Ch], 01h  
      mov   byte ptr ds:[eax+36143Dh], 00h
      mov   byte ptr ds:[eax+36143Eh], 00h  
      mov   byte ptr ds:[eax+36143Fh], 00h	  
	.endif
	
;FOG MINIMAP

	push	eax

	Button_GetCheck	hMHFMINI
	.if	eax == BST_CHECKED
	  pop	eax
      mov   byte ptr ds:[eax+356525h], 87h  
      mov   byte ptr ds:[eax+356526h], 0DBh
	.else
	  pop	eax
      mov   byte ptr ds:[eax+356525h], 88h  
      mov   byte ptr ds:[eax+356526h], 01h	  
	.endif
	
;TRADE

	push	eax

	Button_GetCheck	hMHTRADE
	.if	eax	== BST_CHECKED
	  pop	eax
      mov   byte ptr ds:[eax+34DDA2h], 0B8h
      mov   byte ptr ds:[eax+34DDA3h], 0C8h  
      mov   byte ptr ds:[eax+34DDA4h], 00h
      mov   byte ptr ds:[eax+34DDA5h], 00h
      mov   byte ptr ds:[eax+34DDA7h], 90h  
      mov   byte ptr ds:[eax+34DDAAh], 0B8h
      mov   byte ptr ds:[eax+34DDABh], 64h
      mov   byte ptr ds:[eax+34DDACh], 00h  
      mov   byte ptr ds:[eax+34DDADh], 00h
      mov   byte ptr ds:[eax+34DDAFh], 90h
	.else
	  pop	eax
      mov   byte ptr ds:[eax+34DDA2h], 8Bh
      mov   byte ptr ds:[eax+34DDA3h], 87h  
      mov   byte ptr ds:[eax+34DDA4h], 6Ch
      mov   byte ptr ds:[eax+34DDA5h], 01h
      mov   byte ptr ds:[eax+34DDA7h], 00h  
      mov   byte ptr ds:[eax+34DDAAh], 8Bh
      mov   byte ptr ds:[eax+34DDABh], 87h
      mov   byte ptr ds:[eax+34DDACh], 68h  
      mov   byte ptr ds:[eax+34DDADh], 01h
      mov   byte ptr ds:[eax+34DDAFh], 00h	  
	.endif
	
;CLICKABLE
    
	push	eax
	
	Button_GetCheck	hMHCLICK
	.if	eax	== BST_CHECKED
	  pop	eax
      mov   byte ptr ds:[eax+2851B0h], 0EBh
      mov   byte ptr ds:[eax+2851B1h], 2Bh
      mov   byte ptr ds:[eax+28519Ch], 87h
      mov   byte ptr ds:[eax+28519Dh], 0DBh
	.else
	  pop	eax
      mov   byte ptr ds:[eax+2851B0h], 85h
      mov   byte ptr ds:[eax+2851B1h], 0C0h
      mov   byte ptr ds:[eax+28519Ch], 74h
      mov   byte ptr ds:[eax+28519Dh], 2Ah	  
	.endif
	
;ILLUSIONS

	push	eax

	Button_GetCheck	hMHILLUS
	.if	eax == BST_CHECKED
	  pop	eax
      mov   byte ptr ds:[eax+282A5Ch], 90h  
      mov   byte ptr ds:[eax+282A5Dh], 40h
      mov   byte ptr ds:[eax+282A5Eh], 0C3h
	.else
	  pop	eax
      mov   byte ptr ds:[eax+282A5Ch], 0C3h  
      mov   byte ptr ds:[eax+282A5Dh], 0CCh
      mov   byte ptr ds:[eax+282A5Eh], 0CCh
	.endif
	
;INVISIBLE

	push	eax

	Button_GetCheck	hMHILLUS
	.if	eax == BST_CHECKED
	  pop	eax
      mov   byte ptr ds:[eax+399A98h], 71h
	.else
	  pop	eax
      mov   byte ptr ds:[eax+399A98h], 74h	  
	.endif
	
;RUNES

	push	eax

	Button_GetCheck	hMHRUNES
	.if	eax == BST_CHECKED
	  pop	eax
      mov   byte ptr ds:[eax+3A14DBh], 71h
    .else
	  pop	eax
      mov   byte ptr ds:[eax+3A14DBh], 75h	  
	.endif
	
;SKILLS AND CD

	push	eax

	Button_GetCheck	hMHSKLSCD
	.if	eax == BST_CHECKED
	  pop	eax
      mov   byte ptr ds:[eax+2026DCh], 87h
      mov   byte ptr ds:[eax+2026DDh], 0DBh
      mov   byte ptr ds:[eax+2026DEh], 87h  
      mov   byte ptr ds:[eax+2026DFh], 0DBh
      mov   byte ptr ds:[eax+2026E0h], 87h
      mov   byte ptr ds:[eax+2026E1h], 0DBh
      mov   byte ptr ds:[eax+28E1DEh], 71h
      mov   byte ptr ds:[eax+34F2A8h], 87h  
      mov   byte ptr ds:[eax+34F2A9h], 0DBh
      mov   byte ptr ds:[eax+34F2E9h], 00h
	.else
	  pop	eax
      mov   byte ptr ds:[eax+2026DCh], 0Fh
      mov   byte ptr ds:[eax+2026DDh], 84h
      mov   byte ptr ds:[eax+2026DEh], 5Fh  
      mov   byte ptr ds:[eax+2026DFh], 01h
      mov   byte ptr ds:[eax+2026E0h], 00h
      mov   byte ptr ds:[eax+2026E1h], 00h
      mov   byte ptr ds:[eax+28E1DEh], 75h
      mov   byte ptr ds:[eax+34F2A8h], 74h  
      mov   byte ptr ds:[eax+34F2A9h], 08h
      mov   byte ptr ds:[eax+34F2E9h], 08h	  
	.endif
	
;BYPASS -AH

	push	eax

	Button_GetCheck	hMHBYPASSAH
	.if	eax == BST_CHECKED
	  pop	eax
      mov   byte ptr ds:[eax+3C639Ch], 0B8h  
      mov   byte ptr ds:[eax+3C63A1h], 0EBh
      mov   byte ptr ds:[eax+3CB872h], 0EBh
	.else
	  pop	eax
      mov   byte ptr ds:[eax+3C639Ch], 3Dh  
      mov   byte ptr ds:[eax+3C63A1h], 76h
      mov   byte ptr ds:[eax+3CB872h], 74h	  
	.endif
	
;PINGS

	push	eax

	Button_GetCheck	hMHPINGS
	.if	eax == BST_CHECKED
	  pop	eax
      mov   byte ptr ds:[eax+43EE96h], 3Bh
      mov   byte ptr ds:[eax+43EE99h], 85h  
      mov   byte ptr ds:[eax+43EEA9h], 3Bh
      mov   byte ptr ds:[eax+43EEACh], 85h  
	.else
	  pop	eax
      mov   byte ptr ds:[eax+43EE96h], 85h
      mov   byte ptr ds:[eax+43EE99h], 84h  
      mov   byte ptr ds:[eax+43EEA9h], 85h
      mov   byte ptr ds:[eax+43EEACh], 84h  	  
	.endif
	
;CAMERA

	push	eax

	Button_GetCheck	hMHCAMHACK
	.if	eax == BST_CHECKED
	  pop	eax
	  lea	ecx, dword ptr ds:[fCamera]
	  mov	dword ptr ds:[eax+3DA5D1h], ecx
	  mov	dword ptr ds:[eax+3019A8h], ecx
	  mov	dword ptr ds:[eax+308666h], ecx
	.else
	  pop	eax
	  mov	ecx, eax
	  add	ecx, 93645Ch
	  mov	dword ptr ds:[eax+3DA5D1h], ecx
	  mov	dword ptr ds:[eax+3019A8h], ecx
	  mov	dword ptr ds:[eax+308666h], ecx	  
	.endif
	  
;COOLFUNCS & INIT
	
	push	eax
	
	push	eax
	call	MH_Hook
	add		esp, 4h       

	call	MB_Install
	add		esp, 4h
	  
	call	InitGameMod
	
    ret

MH_DoTheJob     endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

MH_Hook			proc	lpBase:DWORD

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

	mov		ecx, dword ptr ss:[esp+4]
	push	ecx

	Button_GetCheck	hMHGREYHP
	.if	eax == BST_CHECKED	
		pop		ecx
		push	ecx
		add		ecx, 364BF2h
		mov		byte ptr ds:[ecx], 0E8h			;CALL
		lea		eax, GreyHPFunc
		not		ecx
		lea		eax, dword ptr ds:[eax+ecx-4h]
		not		ecx
		inc		ecx
		mov		dword ptr ds:[ecx], eax	
	.else
		pop		ecx
		push	ecx
		add		ecx, 364BF2h
		mov		byte ptr ds:[ecx], 0E8h
		mov		byte ptr ds:[ecx+1], 49h
		mov		byte ptr ds:[ecx+2], 9Bh
		mov		byte ptr ds:[ecx+3], 2Ah
		mov		byte ptr ds:[ecx+4], 00h
	.endif
	
	Button_GetCheck	hMHNROSHAN
	.if	eax == BST_CHECKED
		pop		ecx
		push	ecx
		add		ecx, 3C5232h
		mov		byte ptr ds:[ecx], 0E9h			;JMP
		lea		eax, RoshanNotifierFunc
		not		ecx
		lea		eax, dword ptr ds:[eax+ecx-4h]
		not		ecx
		inc		ecx
		mov		dword ptr ds:[ecx], eax	
	.else
		pop		ecx
		push	ecx
		add		ecx, 3C5232h
		mov		byte ptr ds:[ecx], 0E8h
		mov		byte ptr ds:[ecx+1], 0B9h
		mov		byte ptr ds:[ecx+2], 0D6h
		mov		byte ptr ds:[ecx+3], 0FEh
		mov		byte ptr ds:[ecx+4], 0FFh
	.endif
	
	Button_GetCheck	hMHNRUNES
	.if	eax == BST_CHECKED
		pop		ecx
		push	ecx
		add		ecx, 3BB9A0h
		mov		byte ptr ds:[ecx], 0E9h			;JMP
		lea		eax, RuneNotifierFunc
		not		ecx
		lea		eax, dword ptr ds:[eax+ecx-4h]
		not		ecx
		inc		ecx
		mov		dword ptr ds:[ecx], eax	
	.else
		pop		ecx
		push	ecx
		add		ecx, 3BB9A0h
		mov		byte ptr ds:[ecx], 8Bh
		mov		byte ptr ds:[ecx+1], 44h
		mov		byte ptr ds:[ecx+2], 24h
		mov		byte ptr ds:[ecx+3], 0Ch
		mov		byte ptr ds:[ecx+4], 8Bh
	.endif
	
	Button_GetCheck	hMHNCLRINV
	.if	eax == BST_CHECKED	
		pop		ecx
		push	ecx
		add		ecx, 399995h
		mov		byte ptr ds:[ecx], 0E9h			;JMP
		lea		eax, ColoredInviFunc
		not		ecx
		lea		eax, dword ptr ds:[eax+ecx-4h]
		not		ecx
		inc		ecx
		mov		dword ptr ds:[ecx], eax	
	.else
		pop		ecx
		push	ecx
		add		ecx, 399995h
		mov		byte ptr ds:[ecx], 0E8h
		mov		byte ptr ds:[ecx+1], 76h
		mov		byte ptr ds:[ecx+2], 1Dh
		mov		byte ptr ds:[ecx+3], 0F1h
		mov		byte ptr ds:[ecx+4], 0FFh	
	.endif
	
	Button_GetCheck	hMHHPMP
	.if	eax == BST_CHECKED
		pop		ecx
		push	ecx
		add		ecx, 354B0Ch
		mov		byte ptr ds:[ecx], 0E8h			;CALL
		lea		eax, HPMP_DRAW
		not		ecx
		lea		eax, dword ptr ds:[eax+ecx-4h]
		not		ecx
		inc		ecx
		mov		dword ptr ds:[ecx], eax
		mov		byte ptr ds:[ecx+4], 90h
	
		pop		ecx
		push	ecx
		add		ecx, 358137h
		mov		byte ptr ds:[ecx], 0E8h			;CALL
		lea		eax, HPMP_HP
		not		ecx
		lea		eax, dword ptr ds:[eax+ecx-4h]
		not		ecx
		inc		ecx
		mov		dword ptr ds:[ecx], eax	
		mov		byte ptr ds:[ecx+4], 90h
		mov		byte ptr ds:[ecx+5], 90h
	
		pop		ecx
		push	ecx
		add		ecx, 35818Ch
		mov		byte ptr ds:[ecx], 0EBh
	
		pop		ecx
		push	ecx
		add		ecx, 358322h
		mov		byte ptr ds:[ecx], 0E8h			;CALL
		lea		eax, HPMP_MP
		not		ecx
		lea		eax, dword ptr ds:[eax+ecx-4h]
		not		ecx
		inc		ecx
		mov		dword ptr ds:[ecx], eax
		mov		byte ptr ds:[ecx+4], 90h
		
		pop		ecx
		push	ecx
		add		ecx, 3583BAh
		mov		byte ptr ds:[ecx], 0EBh
		
		pop		ecx
		push	ecx
		add		ecx, 33911Bh
		mov		byte ptr ds:[ecx], 0E8h			;CALL
		lea		eax, HPMP_MS
		not		ecx
		lea		eax, dword ptr ds:[eax+ecx-4h]
		not		ecx
		inc		ecx
		mov		dword ptr ds:[ecx], eax

		pop		ecx
		push	ecx
		add		ecx, 3392BBh
		mov		byte ptr ds:[ecx], 0E8h			;CALL
		lea		eax, HPMP_AS
		not		ecx
		lea		eax, dword ptr ds:[eax+ecx-4h]
		not		ecx
		inc		ecx
		mov		dword ptr ds:[ecx], eax		
	.else
		pop		ecx
		push	ecx
		add		ecx, 354B0Ch
		mov		byte ptr ds:[ecx+0], 8Bh
		mov		byte ptr ds:[ecx+1], 0BDh
		mov		byte ptr ds:[ecx+2], 34h
		mov		byte ptr ds:[ecx+3], 01h
		mov		byte ptr ds:[ecx+4], 00h
		mov		byte ptr ds:[ecx+5], 00h
		
		pop		ecx
		push	ecx	
		add		ecx, 358137h
		mov		byte ptr ds:[ecx+0], 8Dh
		mov		byte ptr ds:[ecx+1], 84h
		mov		byte ptr ds:[ecx+2], 24h
		mov		byte ptr ds:[ecx+3], 0D8h
		mov		byte ptr ds:[ecx+4], 00h
		mov		byte ptr ds:[ecx+5], 00h
		mov		byte ptr ds:[ecx+6], 00h		
		
		pop		ecx
		push	ecx
		add		ecx, 35818Ch
		mov		byte ptr ds:[ecx+0], 75h
		
		pop		ecx
		push	ecx
		add		ecx, 358322h
		mov		byte ptr ds:[ecx+0], 81h
		mov		byte ptr ds:[ecx+1], 0C1h
		mov		byte ptr ds:[ecx+2], 0B8h
		mov		byte ptr ds:[ecx+3], 00h
		mov		byte ptr ds:[ecx+4], 00h
		mov		byte ptr ds:[ecx+5], 00h
				
		pop		ecx
		push	ecx
		add		ecx, 3583BAh
		mov		byte ptr ds:[ecx+0], 75h
		
		pop		ecx
		push	ecx
		add		ecx, 33911Bh
		mov		byte ptr ds:[ecx+0], 0E8h
		mov		byte ptr ds:[ecx+1], 9Eh
		mov		byte ptr ds:[ecx+2], 24h
		mov		byte ptr ds:[ecx+3], 3Bh
		mov		byte ptr ds:[ecx+4], 00h
				
		pop		ecx
		push	ecx
		add		ecx, 3392BBh
		mov		byte ptr ds:[ecx+0], 0E8h
		mov		byte ptr ds:[ecx+1], 0FEh
		mov		byte ptr ds:[ecx+2], 22h
		mov		byte ptr ds:[ecx+3], 3Bh
		mov		byte ptr ds:[ecx+4], 00h
		
		pop		ecx
		push	ecx
		add		ecx, 354B0Ch
		mov		byte ptr ds:[ecx+0], 8Bh
		mov		byte ptr ds:[ecx+1], 0BDh
		mov		byte ptr ds:[ecx+2], 34h
		mov		byte ptr ds:[ecx+3], 01h
		mov		byte ptr ds:[ecx+4], 00h
	.endif
	
	Button_GetCheck	hMHLCLPL
	.if	eax == 0F0F0h;BST_CHECKED
		pop		ecx
		push	ecx
		add		ecx, 45D079h
		mov		byte ptr ds:[ecx], 0E8h			;CALL
		lea		eax, LPH_HOOK
		not		ecx
		lea		eax, dword ptr ds:[eax+ecx-4h]
		not		ecx
		inc		ecx
		mov		dword ptr ds:[ecx], eax
		
		pop		ecx
		push	ecx
		add		ecx, 3C9578h
		mov		byte ptr ds:[ecx], 0E8h			;CALL
		lea		eax, LPH_IPA
		not		ecx
		lea		eax, dword ptr ds:[eax+ecx-4h]
		not		ecx
		inc		ecx
		mov		dword ptr ds:[ecx], eax
		mov		byte ptr ds:[ecx+4], 0C3h

		pop		ecx
		push	ecx
		add		ecx, 3C95C9h
		mov		byte ptr ds:[ecx], 0E8h			;CALL
		lea		eax, LPH_IPE
		not		ecx
		lea		eax, dword ptr ds:[eax+ecx-4h]
		not		ecx
		inc		ecx
		mov		dword ptr ds:[ecx], eax
		mov		byte ptr ds:[ecx+4], 0C3h		
	.else
		pop		ecx
		push	ecx
		add		ecx, 45D079h
		mov		byte ptr ds:[ecx], 0A1h
		mov		eax, hGameAAE140
		mov		dword ptr ds:[ecx+1], eax
		
		pop		ecx
		push	ecx
		add		ecx, 3C9578h
		mov		byte ptr ds:[ecx], 0C3h
		mov		dword ptr ds:[ecx+1], 0CCCCCCCCh
		mov		byte ptr ds:[ecx+5], 0CCh
		
		pop		ecx
		push	ecx
		add		ecx, 3C95C9h
		mov		byte ptr ds:[ecx], 0C3h
		mov		dword ptr ds:[ecx+1], 0CCCCCCCCh
		mov		byte ptr ds:[ecx+5], 0CCh		
	.endif
	
	Button_GetCheck	hMHNMINE
	.if	eax == BST_CHECKED
		pop		ecx
		push	ecx
		add		ecx, 29F990h
		mov		byte ptr ds:[ecx], 0E9h			;JMP
		lea		eax, MineWardNotifierFunc
		not		ecx
		lea		eax, dword ptr ds:[eax+ecx-4h]
		not		ecx
		inc		ecx
		mov		dword ptr ds:[ecx], eax
		mov		word ptr ds:[ecx+4], 9090h
	.else
		pop		ecx
		push	ecx
		add		ecx, 29F990h
		mov		byte ptr ds:[ecx+0], 6Ah
		mov		byte ptr ds:[ecx+1], 0FFh
		mov		byte ptr ds:[ecx+2], 68h
		mov		eax, hGame815DA6
		mov		dword ptr ds:[ecx+3], eax
	.endif
	
	
	
	pop		ecx
	ret

MH_Hook			endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

MB_Hook			proc	lpBase:DWORD

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

	Button_GetCheck	hMHMANABAR
	.if	eax == BST_CHECKED
		mov		ecx, a6F37A563
		mov		byte ptr ds:[ecx], 0E8h
		lea		eax, f001527C0
		not		ecx
		lea		eax, dword ptr ds:[eax+ecx-4h]
		not		ecx
		inc		ecx
		mov		dword ptr ds:[ecx], eax
	
		mov		ecx, a6F37A968
		mov		byte ptr ds:[ecx], 0E8h
		lea		eax, f00152930
		not		ecx
		lea		eax, dword ptr ds:[eax+ecx-4h]
		not		ecx
		inc		ecx
		mov		dword ptr ds:[ecx], eax
	.else
		mov		ecx, a6F37A563
		mov		byte ptr ds:[ecx], 0E8h
		mov		byte ptr ds:[ecx+1], 0CAh
		mov		byte ptr ds:[ecx+2], 1Ah
		mov		byte ptr ds:[ecx+3], 37h
		mov		byte ptr ds:[ecx+4], 00h 
	
		mov		ecx, a6F37A968
		mov		byte ptr ds:[ecx], 0E8h
		mov		byte ptr ds:[ecx+1], 0C3h
		mov		byte ptr ds:[ecx+2], 0D5h
		mov		byte ptr ds:[ecx+3], 0F4h
		mov		byte ptr ds:[ecx+4], 0FFh
	.endif	
	
	ret
	
MB_Hook			endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

MB_Install		proc	lpGame:DWORD

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

    mov		a3000AC, 1
	
	lea		eax, sStorm
	push	eax
	call	GetModuleHandleA
	
	push	191h
	push	eax
	call	GetProcAddress
	
	mov		a16F088, eax
	mov		eax, dword ptr ss:[esp+4h]
	mov		a1698A0, eax
	
	push	eax
	add		eax, 27AE90h
	mov		g16FF24, eax
	pop		eax

	push	eax
	add		eax, 334180h
	mov		g16FF68, eax
	pop		eax

	push	eax
	add		eax, 6061B0h
	mov		a16FF64, eax
	pop		eax

	push	eax
	add		eax, 605CC0h
	mov		a16FF5C, eax
	pop		eax

	push	eax
	add		eax, 359CC0h
	mov		a16FF58, eax
	pop		eax
	
	push	eax
	add		eax, 32C880h
	mov		a16FF20, eax
	pop		eax

	push	eax
	add		eax, 2C74B0h
	mov		a2C7F10, eax
	pop		eax

	push	eax
	add		eax, 379AE3h
	mov		a6F37A563, eax
	pop		eax
	
	push	eax
	add		eax, 379EE8h
	mov		a6F37A968, eax
	pop		eax

	push	eax
	call	MB_Hook
	add		esp, 4h
	
	ret

MB_Install		endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

IsInGame		proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

    mov		ebx, dword ptr ds:[ptGameState]
    mov		ebx, [ebx]
	xor		eax, eax
    cmp		ebx, 4
	sete	 al		
	ret

IsInGame		endp

GreyHPFunc		proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

	pushad

	mov		edx, pClassOffset
	mov		edx,dword ptr ds:[edx]
	xor		eax, eax
	mov		al, byte ptr ds:[edx+28h]
	mov		edx, dword ptr ds:[esi]

	push	4h
	push	0h
	push	eax
	mov		eax, dword ptr ds:[edx+0FCh]
	mov		ecx, esi
	call	eax
	cmp		eax, 1h
	je		visible

	popad

	mov		eax, dword ptr ss:[esp+4h]
	or		dword ptr ds:[eax], 0DD00FFh
	mov		dl, byte ptr ds:[eax+3h]
	mov		byte ptr ds:[ecx+68h], dl
	mov		dl, byte ptr ds:[eax]
	mov		byte ptr ds:[ecx+69h], dl
	mov		dl, byte ptr ds:[eax+1h]
	mov		byte ptr ds:[ecx+6Ah], dl
	mov		dl, byte ptr ds:[eax+2h]
	mov		byte ptr ds:[ecx+6Bh], dl

	mov 	edx, dword ptr ds:[ecx]
	mov		eax, dword ptr ds:[edx+24h]
	call	eax
	ret		4h
	
visible:
	popad

	mov		eax, dword ptr ss:[esp+4h]
	mov 	dl, byte ptr ds:[eax+3h]
	mov 	byte ptr ds:[ecx+68h], dl
	mov 	dl, byte ptr ds:[eax]
	mov 	byte ptr ds:[ecx+69h], dl
	mov 	dl, byte ptr ds:[eax+1h]
	mov 	byte ptr ds:[ecx+6Ah], dl
	mov 	dl, byte ptr ds:[eax+2h]
	mov 	byte ptr ds:[ecx+6Bh], dl

	mov 	edx, dword ptr ds:[ecx]
	mov 	eax, dword ptr ds:[edx+24h]
	call 	eax
	ret 	4h

GreyHPFunc		endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

ColoredInviFunc		proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

	pushad

	mov 	edx, pClassOffset
	mov 	edx, dword ptr ds:[edx]
	xor 	eax, eax
	mov 	al, byte ptr ds:[edx+28h]
	mov 	edx, dword ptr ds:[esi]

	push	4h
	push	0h
	push	eax
	mov 	eax, dword ptr ds:[edx+0FCh]
	mov 	ecx, esi
	call	eax
	cmp 	eax, 1h
	je		back

	xor 	eax, eax
	mov 	al, byte ptr ds:[esi+5Fh]
	cmp 	al, 1h
	jnz 	back

	mov 	ecx, esi
	push	ecx
	mov 	eax, esp
	mov 	dword ptr ds:[eax], 0FFCC33CCh
	mov 	ecx, dword ptr ds:[ecx+28h]
	xor 	edx, edx
	call	ColorUnit

back:
	popad
	call	ColoredInviOriCall
	jmp		ColoredInviRet

ColoredInviFunc		endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

RoshanNotifierFunc		proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

	call	RoshanNotifierOriCall
		
	pushad

	mov		eax, dword ptr ds:[esp+50h]
	cmp		eax, 6E30304Ch
	jne		back

	call	IsInGame
	test	eax, eax
	je		back

    push	roshanDuration
    lea		eax, PrintClr
    push	eax
    lea		eax, sRoshan
    push	eax
    call	PrintText
    add		esp, 0Ch
	
	push	0
	push	0FFh
	push	0FFh
	push	0FFh
	lea		eax, roshanDuration
	push	eax
	lea		eax, roshanY
	push	eax
	lea		eax, roshanX
	push	eax
	call	PingMinimapEx
	add		esp, 1Ch
	
back:
	popad
	
	jmp		RoshanNotifierBack

RoshanNotifierFunc		endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

RuneNotifierFunc		proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

	mov		eax, dword ptr ss:[esp+0Ch]
	mov		edx, dword ptr ss:[esp+8h]
	mov		ecx, dword ptr ss:[esp+4h]

	pushad

	cmp 	dword ptr ds:[eax], 44CE0000h
	je 		top
	cmp 	dword ptr ds:[eax], 0C5310000h
	je 		bot

	jmp 	fin

top:
	cmp 	ecx, 49303037h
	je 		illuTop
    cmp 	ecx, 49303036h
	je		hasteTop
	cmp		ecx, 4930304Bh
	je		ddamageTop
	cmp		ecx, 49303038h
	je		regenTop
	cmp		ecx, 4930304Ah
	je		inviTop
	jmp		fin

bot:
	cmp		ecx, 49303037h
	je		illuBot
    cmp		ecx, 49303036h
	je		hasteBot
    cmp		ecx, 4930304Bh
	je		ddamageBot
    cmp		ecx, 49303038h
	je		regenBot
    cmp		ecx, 4930304Ah
	je		inviBot
    jmp		fin
	

illuTop:
    push	runeDuration
    lea		eax, PrintClr
    push	eax
    lea		eax, sIT
    push	eax
    call	PrintText
    add		esp, 0Ch
	
	push	0
	push	01h
	push	0FCh
	push	0FFh
	lea		eax, runeDuration
	push	eax
	lea		eax, runeYTop
	push	eax
	lea		eax, runeXTop
	push	eax
	call	PingMinimapEx
	add		esp, 1Ch

	jmp		fin
	
illuBot:
    push	runeDuration
    lea		eax, PrintClr
    push	eax
    lea		eax, sIB
    push	eax
    call	PrintText
    add		esp, 0Ch
	
	push	0
	push	01h
	push	0FCh
	push	0FFh
	lea		eax, runeDuration
	push	eax
	lea		eax, runeYBot
	push	eax
	lea		eax, runeXBot
	push	eax
	call	PingMinimapEx
	add		esp, 1Ch

	jmp		fin

hasteTop:
    push	runeDuration
    lea		eax, PrintClr
    push	eax
    lea		eax, sHT
    push	eax
    call	PrintText
    add		esp, 0Ch
	
	push	0
	push	03h
	push	03h
	push	0FFh
	lea		eax, runeDuration
	push	eax
	lea		eax, runeYTop
	push	eax
	lea		eax, runeXTop
	push	eax
	call	PingMinimapEx
	add		esp, 1Ch

	jmp		fin
	
hasteBot:
    push	runeDuration
    lea		eax, PrintClr
    push	eax
    lea		eax, sHB
    push	eax
    call	PrintText
    add		esp, 0Ch
	
	push	0
	push	03h
	push	03h
	push	0FFh
	lea		eax, runeDuration
	push	eax
	lea		eax, runeYBot
	push	eax
	lea		eax, runeXBot
	push	eax
	call	PingMinimapEx
	add		esp, 1Ch

	jmp		fin

ddamageTop:
    push	runeDuration
    lea		eax, PrintClr
    push	eax
    lea		eax, sDT
    push	eax
    call	PrintText
    add		esp, 0Ch
	
	push	0
	push	0FFh
	push	42h
	push	00h
	lea		eax, runeDuration
	push	eax
	lea		eax, runeYTop
	push	eax
	lea		eax, runeXTop
	push	eax
	call	PingMinimapEx
	add		esp, 1Ch

	jmp		fin
	
ddamageBot:
    push	runeDuration
    lea		eax, PrintClr
    push	eax
    lea		eax, sDB
    push	eax
    call	PrintText
    add		esp, 0Ch
	
	push	0
	push	0FFh
	push	42h
	push	00h
	lea		eax, runeDuration
	push	eax
	lea		eax, runeYBot
	push	eax
	lea		eax, runeXBot
	push	eax
	call	PingMinimapEx
	add		esp, 1Ch

	jmp		fin

regenTop:
    push	runeDuration
    lea		eax, PrintClr
    push	eax
    lea		eax, sRT
    push	eax
    call	PrintText
    add		esp, 0Ch
	
	push	0
	push	00h
	push	0FFh
	push	00h
	lea		eax, runeDuration
	push	eax
	lea		eax, runeYTop
	push	eax
	lea		eax, runeXTop
	push	eax
	call	PingMinimapEx
	add		esp, 1Ch

	jmp		fin
	
regenBot:
    push	runeDuration
    lea		eax, PrintClr
    push	eax
    lea		eax, sRB
    push	eax
    call	PrintText
    add		esp, 0Ch
	
	push	0
	push	00h
	push	0FFh
	push	00h
	lea		eax, runeDuration
	push	eax
	lea		eax, runeYBot
	push	eax
	lea		eax, runeXBot
	push	eax
	call	PingMinimapEx
	add		esp, 1Ch

	jmp		fin

inviTop:
    push	runeDuration
    lea		eax, PrintClr
    push	eax
    lea		eax, sINT
    push	eax
    call	PrintText
    add		esp, 0Ch
	
	push	0
	push	0FFh
	push	0CCh
	push	99h
	lea		eax, runeDuration
	push	eax
	lea		eax, runeYTop
	push	eax
	lea		eax, runeXTop
	push	eax
	call	PingMinimapEx
	add		esp, 1Ch

	jmp		fin

inviBot:
    push	runeDuration
    lea		eax, PrintClr
    push	eax
    lea		eax, sINB
    push	eax
    call	PrintText
    add		esp, 0Ch
	
	push	0
	push	0FFh
	push	0CCh
	push	99h
	lea		eax, runeDuration
	push	eax
	lea		eax, runeYBot
	push	eax
	lea		eax, runeXBot
	push	eax
	call	PingMinimapEx
	add		esp, 1Ch

	jmp		fin

fin:
	popad
		
	jmp RuneNotifierBack

RuneNotifierFunc		endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

MineWardNotifierFunc	proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

	pushad
	
	call	IsInGame
	test	eax, eax
	je		@endf
	
	xor		eax, eax
	
	.if		edx == 6F303034h
		lea	eax, sOWARD
	.elseif edx == 6F657965h
		lea	eax, sSWARD
	.elseif edx == 6E30304Fh
		lea	eax, sMINE
	.elseif edx == 6E303050h
		lea	eax, sMINE
	.elseif edx == 6E303051h
		lea	eax, sMINE
	.elseif edx == 6E30304Eh
		lea	eax, sMINE
	.elseif edx == 6F746F74h
		lea	eax, sSTASIS
	.elseif edx == 6F303138h
		lea	eax, sREMOTE
	.elseif edx == 6F303032h
		lea	eax, sREMOTE
	.elseif edx == 6F303042h
		lea	eax, sREMOTE
	.elseif edx == 6F303142h
		lea	eax, sREMOTE
	.elseif edx == 68303243h
		lea	eax, sBOWARD
	.elseif edx == 68303244h
		lea	eax, sBSWARD
	.elseif edx == 68303736h
		lea	eax, sBDUST
	.elseif edx == 68303147h
		lea	eax, sBGEM
	.endif
	
	test	eax, eax
	je		@endf
	
    push	minewardDuration
    lea		edx, PrintClr
    push	edx
    push	eax
    call	PrintText
    add		esp, 0Ch
	
	push	0
	push	0FFh
	push	0FFh
	push	0FFh
	lea		eax, minewardDuration
	push	eax
	push	dword ptr ss:[esp+3Ch]
	push	dword ptr ss:[esp+3Ch]
	call	PingMinimapEx
	add		esp, 1Ch	
	
@endf:
	popad
	
	push	-1
	push	hGame815DA6
	jmp		MineWardNotifierBack

MineWardNotifierFunc	endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

MHDetectFunc	proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

	pushad
	
	push	esi
	push	dword ptr ds:[esp+8h+20h]
	call	pGame_jPlayer
	add		esp, 4h
	pop		esi
	
	push	eax
	push	esi
	call	pGame_jIsUnitVisible
	add		esp, 8h
	test	eax, eax
	je		@endf

	push	roshanDuration
    lea		eax, PrintClr
    push	eax
    lea		eax, sRoshan
    push	eax
    call	PrintText
    add		esp, 0Ch
	
@endf:
	popad
	
	push	ecx
	push	ebx
	push	esi
	mov		esi, dword ptr ss:[esp+10]
	jmp		MHDetectFuncBack

MHDetectFunc	endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

InitGameMod     proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

	cmp	isNDMGVARSET, 1
	je	@NDMGVARSET
      mov   eax, dword ptr ds:[hGameP]
      push  eax
      mov   ebx, dword ptr ds:[pGame_jGetEventDamage]
      add   ebx, 15h
      add   eax, ebx
      mov   dword ptr ds:[pGame_jGetEventDamage], eax
      
      pop   eax
      push  eax
      mov   ebx, dword ptr ds:[pGame_jGetEventTargetUnit]
      add   eax, ebx
      mov   dword ptr ds:[pGame_jGetEventTargetUnit], eax

      pop   eax
      push  eax
      mov   ebx, dword ptr ds:[pGame_jGetTriggerUnit]
      add   eax, ebx
      mov   dword ptr ds:[pGame_jGetTriggerUnit], eax

      pop   eax
      push  eax
      mov   ebx, dword ptr ds:[pGame_jCreateTextTag]
      add   eax, ebx
      mov   dword ptr ds:[pGame_jCreateTextTag], eax

      pop   eax
      push  eax
      mov   ebx, dword ptr ds:[pGame_jSetTextTagText]
      add   eax, ebx
      mov   dword ptr ds:[pGame_jSetTextTagText], eax

      pop   eax
      push  eax
      mov   ebx, dword ptr ds:[pGame_jSetTextTagPosUnit]
      add   eax, ebx
      mov   dword ptr ds:[pGame_jSetTextTagPosUnit], eax

      pop   eax
      push  eax
      mov   ebx, dword ptr ds:[pGame_jSetTextTagColor]
      add   eax, ebx
      mov   dword ptr ds:[pGame_jSetTextTagColor], eax

      pop   eax
      push  eax
      mov   ebx, dword ptr ds:[pGame_jSetTextTagPermanent]
      add   eax, ebx
      mov   dword ptr ds:[pGame_jSetTextTagPermanent], eax

      pop   eax
      push  eax
      mov   ebx, dword ptr ds:[pGame_jSetTextTagVelocity]
      add   eax, ebx
      mov   dword ptr ds:[pGame_jSetTextTagVelocity], eax

      pop   eax
      push  eax
      mov   ebx, dword ptr ds:[pGame_jSetTextTagLifespan]
      add   eax, ebx
      mov   dword ptr ds:[pGame_jSetTextTagLifespan], eax

      pop   eax
      push  eax
      mov   ebx, dword ptr ds:[pGame_jSetTextTagFadepoint]
      add   eax, ebx
      mov   dword ptr ds:[pGame_jSetTextTagFadepoint], eax

      pop   eax
      push  eax
      mov   ebx, dword ptr ds:[pGame_jSetTextTagVisibility]
      add   eax, ebx
      mov   dword ptr ds:[pGame_jSetTextTagVisibility], eax

      pop   eax
      push  eax
      mov   ebx, dword ptr ds:[pGame_jSetTextTagPos]
      add   eax, ebx
      mov   dword ptr ds:[pGame_jSetTextTagPos], eax

      pop   eax
      push  eax
      mov   ebx, dword ptr ds:[pGame_jSetTextTagSuspended]
      add   eax, ebx
      mov   dword ptr ds:[pGame_jSetTextTagSuspended], eax

      pop   eax
      push  eax
      mov   ebx, dword ptr ds:[pGame_jR2S]
      add   eax, ebx
      mov   dword ptr ds:[pGame_jR2S], eax

      pop   eax
      push  eax
      mov   ebx, dword ptr ds:[pGame_p459150]
      add   eax, ebx
      mov   dword ptr ds:[pGame_p459150], eax	    
	  
      pop   eax                                             ;free the stack
	  
	  mov	isNDMGVARSET, 1
	@NDMGVARSET:

	Button_GetCheck	hMHNDMG
	.if	eax == BST_CHECKED	
		mov		ecx, pGame_jGetEventDamage
		mov		byte ptr ds:[ecx], 0E9h			;JMP
		lea		eax, jGetDamageEvent
		not		ecx
		lea		eax, dword ptr ds:[eax+ecx-4h]
		not		ecx
		inc		ecx
		mov		dword ptr ds:[ecx], eax	
	.else
		mov		ecx, pGame_jGetEventDamage
		mov		byte ptr ds:[ecx], 8Bh
		mov		byte ptr ds:[ecx+1], 40h
		mov		byte ptr ds:[ecx+2], 30h
		mov		byte ptr ds:[ecx+3], 0C3h
		mov		byte ptr ds:[ecx+4], 0CCh	
	.endif

      ret

InitGameMod     endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

jGetDamageEvent proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

      pushad
  
      lea   eax, dword ptr ds:[eax+30h]
	  cmp	dword ptr ds:[eax], 0
	  je	@proc_end
      push  eax                         ;dmg val
      lea   esi, _WT_tt
      call  pGame_jCreateTextTag
      push  eax                         ;texttag
	  
	  mov	ecx, dword ptr ds:[hGameP]
	  add	ecx, 0ADA848h
	  mov	ecx, dword ptr ds:[ecx]
	  mov	ecx, dword ptr ds:[ecx+14h]
	  mov	ecx, dword ptr ds:[ecx+0Ch]
	  mov	ecx, dword ptr ds:[ecx]

	  mov	esi, ecx
	  mov	ebx, eax
	  lea	edi, _STR_CTT
	  push	edi
	  call	pGame_p459150
	  
	  
      lea   esi, _WT_u
      call  pGame_jGetTriggerUnit       ;get the unit
      push  eax

      sub   esp, 100h
      mov   edi, esp
      push  edi                         ;strbuf

      push  0
	  push	0
	  mov	eax, dword ptr ss:[esp+100h+14h]
      fld   dword ptr ss:[eax]
	  fstp	qword ptr ss:[esp]
      lea   eax, _STR_spFLOAT
	  push  eax
	  push  edi
	  call  crt_sprintf
	  add   esp, 10h

	  pop   edi                         ;restore strbuf pointer

	  sub   esp, 20h                    ;fuck that
	  mov   dword ptr ss:[esp+1Ch], edi ;fuck that
	  lea   edi, dword ptr ss:[esp+1Ch] ;fuck that
	  mov   dword ptr ss:[esp+8], esp   ;fuck that
	  mov   edi, esp                    ;fuck that

	  lea   eax, float_003
	  push  eax                         ;size
	  push  edi                         ;strbuf
	  push  dword ptr ss:[esp+100h+0Ch+20h]  ;tagtext
	  lea   edi, _STR_w3WTF1
	  lea   esi, _WT_v
	  call  pGame_jSetTextTagText
	  add   esp, 0Ch

	  add   esp, 20h                    ;restore the stack

	  add   esp, 100h                   ;restore the st
	
      lea   eax, float_0
      push  eax                         ;zOffset
      push  dword ptr ss:[esp+4h]       ;hUnit
      push  dword ptr ss:[esp+0Ch]      ;tagtext
      lea   esi, _WT_v
      call  pGame_jSetTextTagPosUnit
      add   esp, 10h 

      push  0FFh
      push  0
      push  0
      push  0FFh
      push  dword ptr ss:[esp+10h]
      lea   esi, _WT_v 
      call  pGame_jSetTextTagColor
      add   esp, 14h

      lea   eax, float_05
      push  eax                         ;float1
      push  eax                         ;float2
      push  dword ptr ss:[esp+8h]       ;tagtext
      lea   esi, _WT_v
      call  pGame_jSetTextTagVelocity
      add   esp, 0Ch

      lea   eax, float_1
      push  eax                         ;float1
      push  dword ptr ss:[esp+4h]       ;tagtext
      lea   esi, _WT_v
      call  pGame_jSetTextTagFadepoint
      add   esp, 8h

      lea   eax, float_2
      push  eax                         ;float1
      push  dword ptr ss:[esp+4h]       ;tagtext
      lea   esi, _WT_v
      call  pGame_jSetTextTagLifespan
      add   esp, 8h

      push  0                           ;false 
      push  dword ptr ss:[esp+4h]       ;tagtext
      lea   esi, _WT_v
      call  pGame_jSetTextTagPermanent
      add   esp, 8h

      push  0                           ;false
      push  dword ptr ss:[esp+4h]       ;texttag
      lea   esi, _WT_v
      call  pGame_jSetTextTagVisibility
      add   esp, 8h

      push  1                           ;true
      push  dword ptr ss:[esp+4h]       ;texttag
      lea   esi, _WT_v
      call  pGame_jSetTextTagVisibility
      add   esp, 8h

      push  0                           ;false
      push  dword ptr ss:[esp+4h]       ;texttag
      lea   esi, _WT_v
      call  pGame_jSetTextTagSuspended
      add   esp, 8h
            
      add   esp, 8h
	  
@proc_end:      
      popad                             ;restore registers

      mov   eax, dword ptr ds:[eax+30h]
      ret      

jGetDamageEvent endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

f00152750		proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

    push	ebx
    mov		ebx, a16FF64	; ds:[0016FF64]=6F606860 (Game.6F606860)
    push	edi
    mov		edi, a16FF5C	; ds:[0016FF5C]=6F606370 (Game.6F606370)
    push	0
    push	0
    push	0
    xor		edx, edx
    mov		ecx, esi
    call	a16FF58			; ds:[0016FF58]=6F35A740 (Game.6F35A740)
    fld		a1649D4			; ds:[001649D4]=0.03000000
    push	0
    fstp	dword ptr [esi+58h]
    xor		edx, edx
    mov		ecx, esi
    call	edi
    fld		a1649D0			; ds:[001649D0]=0.004000000
    push	0
    fstp	dword ptr [esi+5Ch]
    xor		edx, edx
    mov		ecx, esi
    call	edi
    fld		a1649CC			; ds:[001649CC]=0.3000000
    push	1
    sub		esp, 8h
    fst		dword ptr [esp+4h]
    xor		edx, edx
    fstp	dword ptr [esp]
    push	1
    mov		ecx, esi
    call	ebx
    mov		eax, dword ptr [esi]
    mov		eax, dword ptr [eax+64h]
    pop		edi
    xor		edx, edx
    mov		ecx, esi
    pop		ebx
    jmp		eax

f00152750		endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

f001527C0		proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

    pop		a16F08C
    pop		eax
    add		eax, eax
    push	eax
    call	a16F088
    pushad
    mov		a16F004, eax
    mov		esi, a16F004
    add		esi, 158h
    call	f00152750
    popad
    push	a16F08C
    ret

f001527C0		endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

f152950			proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

    mov		eax, a16F090
    mov		eax, dword ptr [eax+64h]
    push	esi
    push	edi
    mov		esi, edx
    mov		edi, ecx
    call	eax
    mov		eax, a16F090
    mov		eax, dword ptr [eax+64h]
    lea		ecx, dword ptr [edi+158h]
    pop		edi
    mov		edx, esi
    pop		esi
    jmp		eax

f152950			endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

f152980			proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

    mov		eax, a16F090
    mov		eax, dword ptr [eax+68h]
    jmp		eax

f152980			endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

f00152710		proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

    mov		a16F090, ecx
    xor		eax, eax
    jmp		L004
    lea		ebx, dword ptr [ebx]
L004:
    mov		dl, byte ptr [eax+ecx]
    mov		byte ptr [eax+a16F008], dl
    inc		eax
    cmp		eax, 80h
    jb		L004
    push	eax
    push	ebx
    lea		eax, a16F008
    add		eax, 64h
    lea		ebx, f152950
    mov		dword ptr [eax], ebx
    lea		eax, a16F008
    add		eax, 68h
    lea		ebx, f152980
    mov		dword ptr [eax], ebx
    pop		ebx
    pop		eax
    ret

f00152710		endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

f001527F0		proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

    sub		esp, 10h
    cmp		a3000AC, 0
    push	edi
    mov		edi, a16F004
    je		L093
    mov		eax, dword ptr [edi+50h]
    test	eax, eax
    je		L093
    cmp		a3000B0, 0
    push	ebx
    mov		ebx, dword ptr [eax+0Ch]
    push	esi
    lea		esi, dword ptr [ebx+158h]
    jnz		L017
    mov		ecx, dword ptr [ebx]
    call	f00152710
    mov		a3000B0, 1
L017:
    push	0
    lea		eax, dword ptr [esp+10h]
    push	eax
    xor		edx, edx
    mov		ecx, edi
    push	eax
    lea		eax,a16F008
    mov		dword ptr [ebx], eax
    pop		eax
    call	g16FF24
    fldz
    fcomp	dword ptr [esp+0Ch]
    fstsw	ax
    test	ah, 1
    je		L091
    push	3
    lea		ecx, dword ptr [esp+10h]
    push	ecx
    xor		edx, edx
    mov		ecx, edi
    call	g16FF24
    fldz
    fcomp	dword ptr [esp+0Ch]
    fstsw	ax
    test 	ah, 5
    jpe		L091
    mov		eax, dword ptr [esi]
    mov		eax, dword ptr [eax+74h]
    push	ebp
    push	edi
    xor		edx, edx
    mov		ecx, esi
    call	eax
    mov		ebx, a16FF64
    mov		ebp, a16FF5C
    lea		ecx, dword ptr [esp+1Ch]
    push	ecx
    lea		edx, dword ptr [esp+18h]
    mov		ecx, edi
    call	g16FF68
    mov		ecx, dword ptr [edi+30h]
    mov		eax, a16FF20
    lea		edx, a164684
    call	eax
    test	eax, eax
    jnz		L062
    fld1
    jmp		L063
L062:
    fld		dword ptr [eax+54h]
L063:
    fstp	dword ptr [esp+10h]
    push	0
    fld		dword ptr [esp+14h]
    xor		edx, edx
    fmul	qword ptr [a164A18]
    mov		ecx, esi
    fmul	qword ptr [a164A10]
    fstp	dword ptr [esi+58h]
    call	ebp
    fld		dword ptr [esp+18h]
    push	1
    fsub	qword ptr [a164A08]
    sub		esp, 8
    xor		edx, edx
    mov		ecx, esi
    fstp	dword ptr [esp+24h]
    fld		dword ptr [esp+24h]
    fstp	dword ptr [esp+4h]
    fld		dword ptr [esp+20h]
    fstp	dword ptr [esp]
    push	1
    call	ebx
    mov		eax, dword ptr [esi]
    mov		eax, dword ptr [eax+68h]
    xor		edx, edx
    mov		ecx, esi
    call	eax
    pop		ebp
L091:
    pop		esi
    pop		ebx
L093:
    pop		edi
    add		esp, 10h
    ret

f001527F0		endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

f00152930		proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

    pushad
    mov		a16F004, ecx
    call	f001527F0
    popad
    mov		eax, a2C7F10
    jmp		eax

f00152930		endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

HPMP_MS			proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

	mov		eax, dword ptr ds:[esp]
	mov		oldprot, eax
	
	fld		dword ptr ss:[esp+90h]
	sub		esp, 8h
	fstp	qword ptr ss:[esp]
	lea		eax, _STR_speed
	push	eax
	push	7h
	push	ecx
	call	hStorm578
	
	add		esp, 18h
	
	call	hStorm503
	push	oldprot
	
	ret

HPMP_MS			endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

HPMP_AS			proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

	mov		eax, dword ptr ds:[esp]
	mov		oldprot, eax
	
	fld		dword ptr ss:[esp+6Ch]
	sub		esp, 8h
	fstp	qword ptr ss:[esp]
	lea		eax, _STR_speed
	push	eax
	push	7h
	push	ecx
	call	hStorm578
	
	add		esp, 18h
	
	call	hStorm503
	push	oldprot
	
	ret

HPMP_AS			endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

HPMP_HP			proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

	lea		eax, dword ptr ss:[esp+0D8h]
	push	eax
	push	ecx
	push	esi
	add		ecx, 98h
	mov		ecx, dword ptr ds:[ecx+8h]
	mov		esi, dword ptr ds:[hGameAB7788]
	mov		esi, dword ptr ds:[esi]
	mov		eax, dword ptr ds:[esi+0Ch]
	mov		ecx, dword ptr ds:[eax+ecx*8h+4h]
	mov		ecx, dword ptr ds:[ecx+7Ch]
	mov		dword ptr ds:[hUnitHP], ecx
	pop		esi
	pop		ecx
	pop		eax
	ret

HPMP_HP			endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

HPMP_MP			proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

	add		ecx, 0B8h
	push	eax
	push	ecx
	push	esi
	mov		ecx, dword ptr ds:[ecx+8h]
	mov		esi, dword ptr ds:[hGameAB7788]
	mov		esi, dword ptr ds:[esi]
	mov		eax, dword ptr ds:[esi+0Ch]
	mov		ecx, dword ptr ds:[eax+ecx*8h+4h]
	mov		ecx, dword ptr ds:[ecx+7Ch]
	mov		dword ptr ds:[hUnitMP], ecx
	pop		esi
	pop		ecx
	pop		eax
	ret

HPMP_MP			endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

HPMP_DRAW		proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

	push	ecx
	lea		ecx, dword ptr ss:[esp+30h]
	fld		dword ptr ds:[hUnitMP]
	fld		dword ptr ds:[hUnitHP]
	sub		esp, 10h
	fstp	qword ptr ss:[esp]
	fstp	qword ptr ss:[esp+8h]
	push	ecx
	lea		eax, _STR_HPMPFMT
	push	eax
	push	80h
	push	ecx
	call	hStorm578
	add		esp, 20h
	pop		ecx
	mov		edi, dword ptr ds:[ebp+134h]
	ret

HPMP_DRAW		endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

LPH_IPA			proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

	.if LPH_DoHook == 1
		xor		eax, eax
		inc		eax
	.endif
	ret

LPH_IPA			endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

LPH_IPE			proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

	.if LPH_DoHook == 1
		xor		eax, eax
	.endif
	ret

LPH_IPE			endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

LPH_HOOK		proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

	pushad
	
	mov		LPH_FNCUR, eax
	mov		LPH_DoHook, 0
	
	push	eax
	lea		eax, _STR_IPA
	push	eax
	call	crt_strcmp
	add		esp, 8h
	
	test	eax, eax
	je		@chhook
	
	push	LPH_FNCUR
	lea		eax, _STR_IPE
	push	eax
	call	crt_strcmp
	add		esp, 8h
	
	test	eax, eax
	je		@chhook
	jmp		@nohook
	
@chhook:

	push	LPH_FNOLD
	lea		eax, _STR_GLP
	push	eax
	call	crt_strcmp
	add		esp, 8h
	
	test	eax, eax
	jne		@nohook

	mov		LPH_DoHook, 1
	
@nohook:
	mov		eax, LPH_FNCUR
	mov		LPH_FNOLD, eax
	
	popad
	mov		eax, hGameAAE140
	mov		eax, dword ptr ds:[eax]
	ret

LPH_HOOK		endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

end