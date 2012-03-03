; ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
    include \masm32\include\masm32rt.inc
    include \masm32\include\advapi32.inc 

    includelib \masm32\lib\advapi32.lib 
	
	;include	W3_MH.asm
; ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд

    ; -------------------------------------------
    ; Build this DLL with the provided MAKEIT.BAT
    ; -------------------------------------------
    
      .data
        hInstance       dd  0
        hProc           dd  0
        hGame           dd  0
        hGameEND        dd  086C000h
        pGameGS         dd  0
        pGameGSA        dd  0ACE638h
        pGameNN         dd  0ACCE80h
		hSECRETICQ		dd	0FFFFFFFFh
        pW3_game_dump   dd  0
        OffsetPrintText dd  0
        OffsetChatUI    dd  0
        PrintTextClr    dd  0FFFFFFFFh
        _hXORKey        db  80h
        RMM_Orig        dd  0
        RMM_Orig_ADD    dd  0
        
        sGame           db  9,199,225,237,229,174,228,236,236,128
        sNtdll          db  6,238,244,228,236,236,128
        sDLL            db  21,201,227,227,245,240,223,203,233,236,236,229,242,223,179,174,176,174,237,179,228,128
        sRMM            db  14,210,244,236,205,239,246,229,205,229,237,239,242,249,128

        AL_STR_1        db  "[IK3.0r5] |cffffcc00ICCup Killer 3.0 (Private)|r",0
        AL_STR_2        db  "[IK3.0r5] |cffffcc00ICQ Buyer:|r |cff00ff00??????????|r",0
        AL_STR_3        db  "[IK3.0r5] |cffff0000Only Private Use!|r",0
        AL_STR_4        db  "[IK3.0r5] |cffffcc00Made by|r by |cff00ff00Desu_Is_A_Lie|r & |cff00ff004efer.Young|r",0
        AL_STR_5        db  9 dup(10),0

        _SE_DEBUG_NAME  db  "SeDebugPrivilege",0
        _STR_ERROR      db  "Error #%d! Aborting.",0
        _STR_DLL        db  "BASE: %x",0
        _STR_XOR_TEST   db  5,228,229,243,245,128

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл 
                         
      .data?
        oldprot         dd  ?
      .code

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

        TE MACRO var1
            push var1
            call ThrowError
            xor  eax, eax
            ret
        ENDM

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

        GetDebugPriv    PROTO   
        ThrowError      PROTO   err:SDWORD
        Coolfunc        PROTO
        AntiLeech       PROTO
        PrintText       PROTO   pText:DWORD, pColor:DWORD, dur:DWORD
        H_RtlMoveMemory PROTO
        HideDLL         PROTO   hMod:HMODULE
                
        XORStuff        PROTO   pstr:DWORD, pstr_new:DWORD
        MyStrLen        PROTO   pstr:DWORD
        MyStrCpy        PROTO   pstr:DWORD, pstr_new:DWORD
        MyStrLow        PROTO   pstr:DWORD
        XORCMP          PROTO   pstr:DWORD, pstr2:DWORD
		
		MH_Install		PROTO	gameptr:DWORD
		DLL_INSTANCE	PROTO	hIN:DWORD
		
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

LibMain proc instance:DWORD,reason:DWORD,unused:DWORD 

    LOCAL   tmpstr[256]:SBYTE
	
    .if reason == DLL_PROCESS_ATTACH
      mrm   hInstance, instance
	  push	hInstance
	  call	DLL_INSTANCE
	  add	esp, 4h
	  
      call  GetDebugPriv

      call  GetCurrentProcessId
      push  eax
      push  0
      push  PROCESS_ALL_ACCESS
      call  OpenProcess
      mov   dword ptr ds:[hProc], eax
    .if eax == 0
      TE    1
    .endif

      sub   esp, 100h
      push  esp
      lea   eax, sGame
      push  eax
      call  XORStuff
      add   esp, 8h

      mov   eax, esp 

      push  eax
      call  GetModuleHandleA
      add   esp, 100h
      mov   dword ptr ds:[hGame], eax
    .if eax == 0
      TE    2
    .endif

      mov   ecx, dword ptr ds:[hGameEND]
      add   ecx, eax
      mov   dword ptr ds:[hGameEND], ecx

      mov   ecx, dword ptr ds:[pGameGSA]
      add   ecx, eax
      mov   dword ptr ds:[pGameGSA], ecx

      mov   ecx, dword ptr ds:[pGameNN]
      add   ecx, eax
      mov   dword ptr ds:[pGameNN], ecx

      push  0BB5000h
      push  0BB5000h
      push  0
      call  HeapCreate
    .if eax == 0
      TE    3
    .endif
      ;push  0BB5000h
      ;push  HEAP_ZERO_MEMORY
      ;push  eax
      ;call  HeapAlloc
      mov   dword ptr ds:[pW3_game_dump], eax

      push  0BB5000h
      push  hGame
      lea   eax, pW3_game_dump
      mov   eax, dword ptr ds:[eax]
      push  eax
      call  crt_memcpy
      add   esp, 0Ch

      push  0
      push  0
      push  0
      push  Coolfunc
      push  0
      push  0
      call  CreateThread
    .if eax == 0
      TE    3
    .endif

      xor   eax, eax
      inc   eax                              ; return TRUE so DLL will start
      ret

    .elseif reason == DLL_PROCESS_DETACH

    .elseif reason == DLL_THREAD_ATTACH

    .elseif reason == DLL_THREAD_DETACH

    .endif

    xor eax, eax

    ret

LibMain endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

ThrowError      proc    err:SDWORD

    LOCAL tmpstr[256]:SBYTE

      push  err
      lea   eax, _STR_ERROR
      push  eax
      lea   eax, tmpstr
      push  eax
      call  crt_sprintf
      add   esp, 0Ch

      push  MB_OK
      push  0
      lea   eax, tmpstr
      push  eax
      push  0
      call  MessageBoxA

      ret  

ThrowError      endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

GetDebugPriv    proc

    LOCAL hToken:DWORD
    LOCAL sedebugnameVal:LUID
    LOCAL tkp:TOKEN_PRIVILEGES

      lea   eax, hToken
      push  eax
      push  TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY
      call  GetCurrentProcess
      
      push  eax
      call  OpenProcessToken
    .if eax == 0
      ret
    .endif
    
      lea   eax, sedebugnameVal
      push  eax
      lea   eax, _SE_DEBUG_NAME
      push  eax
      push  0
      call  LookupPrivilegeValue
    .if eax == 0
      push  hToken
      call  CloseHandle
      ret
    .endif
    
      mov   [tkp].PrivilegeCount, 1
      mov   eax, [sedebugnameVal].LowPart
      mov   ecx, [sedebugnameVal].HighPart
      mov   tkp.Privileges[0*sizeof LUID_AND_ATTRIBUTES].Luid.LowPart, eax
      mov   tkp.Privileges[0*sizeof LUID_AND_ATTRIBUTES].Luid.HighPart, ecx
      mov   tkp.Privileges[0*sizeof LUID_AND_ATTRIBUTES].Attributes, SE_PRIVILEGE_ENABLED
      
      push  0
      push  0
      push  SIZEOF tkp
      lea   eax, tkp
      push  tkp
      push  0
      push  hToken
      call  AdjustTokenPrivileges
    .if eax == 0
      push  hToken
      call  CloseHandle
    .endif
      ret

GetDebugPriv    endp 

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

Coolfunc        proc

    LOCAL   bytes[6]:BYTE

      sub   esp, 100h
      push  esp
      lea   eax, sNtdll
      push  eax
      call  XORStuff
      add   esp, 8h

      mov   eax, esp
      
      push  eax
      call  GetModuleHandleA
      add   esp, 100h
      push  eax

      sub   esp, 100h
      push  esp
      lea   eax, sRMM
      push  eax
      call  XORStuff
      add   esp, 8h

      mov   ecx, esp 

      push  ecx
      push  dword ptr ss:[esp+100h+4h]
      call  GetProcAddress
      add   esp, 104h
      mov   dword ptr ds:[RMM_Orig], eax
    .if eax == 0
      TE    -4
    .endif

      add   eax, 6
      mov   dword ptr ds:[RMM_Orig_ADD], eax

      lea   eax, oldprot
      push  eax
      push  PAGE_EXECUTE_READWRITE
      push  6
      push  RMM_Orig
      call  VirtualProtect
    .if eax == 0
      TE    -5
    .endif

      lea   eax, H_RtlMoveMemory
      sub   eax, RMM_Orig
      sub   eax, 5
      mov   oldprot, eax

      push  4
      lea   eax, oldprot
      push  eax
      lea   eax, bytes[1]
      push  eax
      call  crt_memcpy
      add   esp, 0Ch

      mov   bytes[0], 0E9h
      mov   bytes[5],  90h

      push  6
      lea   eax, bytes
      push  eax
      push  RMM_Orig
      call  crt_memcpy
      add   esp, 0Ch

      sub   esp, 100h
      push  esp
      lea   eax, sDLL
      push  eax
      call  XORStuff
      add   esp, 8h

      mov   eax, esp
       
      push  eax
      call  GetModuleHandleA
      add   esp, 100h

      push  eax
      call  HideDLL

      push  0
      push  0
      push  0
      push  AntiLeech
      push  0
      push  0
      call  CreateThread

      lea   eax, oldprot
      push  eax
      push  PAGE_EXECUTE_READWRITE
      mov   eax, hGameEND
      sub   eax, hGame
      push  eax
      push  hGame
      call  VirtualProtect

      ;push  1
      push  hGame
      call  MH_Install
      add   esp, 4h

      ;push  hGame
      ;call  MB_Install
      ;add   esp, 4h
      
    @loop_1:
      lea   eax, oldprot
      push  eax
      push  PAGE_EXECUTE_READWRITE
      push  6
      push  RMM_Orig
      call  VirtualProtect

      push  6
      lea   eax, bytes
      push  eax
      push  RMM_Orig
      call  crt_memcpy
      add   esp, 0Ch

    @loop_1_3:
      mov   eax, dword ptr ds:[RMM_Orig]
      cmp   byte ptr ds:[eax], 0E9h
      jne   @loop_1_1
      push  100
      call  Sleep
      jmp   @loop_1_3
    @loop_1_1:
      jmp   @loop_1                    

Coolfunc        endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

AntiLeech       proc

      mov   eax, dword ptr ds:[hGame]
      push  eax
      add   eax,  6049B0h
      mov   dword ptr ds:[OffsetPrintText], eax
      pop   eax
      push  eax
      add   eax, 0ACE66Ch
      mov   dword ptr ds:[OffsetChatUI], eax
      pop   eax
      add   eax, 0AB5738h
      mov   dword ptr ds:[pGameGS], eax

    @loop_1:
      push  500
      call  Sleep
      mov   eax, dword ptr ds:[pGameGS]
      mov   eax, [eax]
      cmp   eax, 4
      jne   @loop_1

      push  5000
      call  Sleep

      push  FP4(10.0)
      lea   eax, PrintTextClr
      push  eax
      lea   eax, AL_STR_5
      push  eax
      call  PrintText
      add   esp, 0Ch

      push  FP4(10.0)
      lea   eax, PrintTextClr
      push  eax
      lea   eax, AL_STR_1
      push  eax
      call  PrintText
      add   esp, 0Ch

      push  FP4(10.0)
      lea   eax, PrintTextClr
      push  eax
      lea   eax, AL_STR_2
      push  eax
      call  PrintText
      add   esp, 0Ch

      push  FP4(10.0)
      lea   eax, PrintTextClr
      push  eax
      lea   eax, AL_STR_3
      push  eax
      call  PrintText
      add   esp, 0Ch

      push  FP4(10.0)
      lea   eax, PrintTextClr
      push  eax
      lea   eax, AL_STR_4
      push  eax
      call  PrintText
      add   esp, 0Ch

      push  FP4(10.0)
      lea   eax, PrintTextClr
      push  eax
      lea   eax, AL_STR_5
      push  eax
      call  PrintText
      add   esp, 0Ch

     @loop_2:
      push  5000
      call  Sleep
      mov   eax, dword ptr ds:[pGameGS]
      mov   eax, [eax]
      cmp   eax, 4
      je    @loop_2

      jmp   @loop_1

AntiLeech       endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

PrintText       proc   pText:DWORD, pColor:DWORD, dur:DWORD

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

      mov   eax, dword ptr ds:[esp+4]
      mov   ecx, dword ptr ds:[esp+8]
      mov   edx, dword ptr ds:[esp+12]
      push  0
      push  edx
      push  ecx
      push  eax
      mov   edx, dword ptr ds:[OffsetPrintText]
      mov   edi, dword ptr ds:[OffsetChatUI]
      mov   edi, dword ptr ds:[edi]
      mov   ecx, dword ptr ds:[edi+3ECh]
      call  edx
      ret

PrintText       endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

H_RtlMoveMemory proc

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

      push  eax
      mov   eax, dword ptr ss:[esp+0Ch]
      cmp   eax, dword ptr ds:[hGame]
      JB    @normal
      cmp   eax, dword ptr ds:[hGameEND]
      JA    @normal
      mov   eax, pW3_game_dump
      add   eax, dword ptr ss:[esp+0Ch]
      sub   eax, dword ptr ds:[hGame]
      mov   dword ptr ss:[esp+0Ch], eax
      add   esp, 4
      jmp   @modified

    @normal:
      pop   eax
    @modified:
      push  esi
      push  edi
      mov   esi, dword ptr ss:[esp+10h]
      jmp   RMM_Orig_ADD

H_RtlMoveMemory endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

HideDLL         proc   hMod:HMODULE

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

ASSUME fs:NOTHING

      push  ebp
      mov   ebp, esp
      add   esp, -10h
      push  ebx
      mov   eax, dword ptr fs:[18h]
      mov   eax, dword ptr ds:[eax+30h]
      mov   eax, dword ptr ds:[eax+0Ch]
      mov   dword ptr ss:[ebp-4], eax
      mov   edx, dword ptr ds:[eax+0Ch]
      mov   dword ptr ss:[ebp-8], edx
      jmp   @loop_s
    @loop_2:
      mov   ecx, dword ptr ss:[ebp-8]
      mov   eax, dword ptr ds:[ecx]
      mov   dword ptr ss:[ebp-8], eax
      mov   edx, eax
    @loop_s:
      cmp   dword ptr ds:[edx+18h], 0
      je    @loop_1
      mov   ecx, dword ptr ss:[ebp-8]
      mov   eax, dword ptr ds:[ecx+18h]
      cmp   eax, hMod
      jnz   @loop_2
    @loop_1:
      mov   edx, dword ptr ss:[ebp-8]   
      cmp   dword ptr ds:[edx+18h], 0
      jnz   @j_1
      xor   eax, eax
      jmp   @j_2
    @j_1:
      mov   edx, dword ptr ss:[ebp-8]
      mov   ecx, dword ptr ds:[edx+4]
      mov   ebx, dword ptr ss:[ebp-8]
      mov   eax, dword ptr ds:[ebx]
      mov   dword ptr ds:[ecx], eax
      mov   edx, dword ptr ss:[ebp-8]
      mov   ecx, dword ptr ds:[edx]
      mov   ebx, dword ptr ss:[ebp-8]   
      mov   eax, dword ptr ds:[ebx+4]
      mov   dword ptr ds:[ecx+4], eax
      mov   edx, dword ptr ss:[ebp-8]
      mov   ecx, dword ptr ds:[edx+0Ch]
      mov   ebx, dword ptr ss:[ebp-8]
      mov   eax, dword ptr ds:[ebx+8]
      mov   dword ptr ds:[ecx], eax
      mov   edx, dword ptr ss:[ebp-8]
      mov   ecx, dword ptr ds:[edx+8]
      mov   ebx, dword ptr ss:[ebp-8]
      mov   eax, dword ptr ds:[ebx+0Ch]
      mov   dword ptr ds:[ecx+4], eax
      mov   edx, dword ptr ss:[ebp-8]
      mov   ecx, dword ptr ds:[edx+14h]
      mov   ebx, dword ptr ss:[ebp-8]
      mov   eax, dword ptr ds:[ebx+10h]
      mov   dword ptr ds:[ecx], eax
      mov   edx, dword ptr ss:[ebp-8]
      mov   ecx, dword ptr ds:[edx+10h]
      mov   ebx, dword ptr ss:[ebp-8]
      mov   eax, dword ptr ds:[ebx+14h]
      mov   dword ptr ds:[ecx+4], eax
      mov   edx, dword ptr ss:[ebp-8]
      mov   ecx, dword ptr ds:[edx+40h]
      mov   ebx, dword ptr ss:[ebp-8]
      mov   eax, dword ptr ds:[ebx+3Ch]
      mov   dword ptr ds:[ecx], eax
      mov   edx, dword ptr ss:[ebp-8]
      mov   ecx, dword ptr ds:[edx+3Ch]
      mov   ebx, dword ptr ss:[ebp-8]
      mov   eax, dword ptr ds:[ebx+40h]
      mov   dword ptr ds:[ecx+4], eax
      xor   edx, edx
      mov   dword ptr ss:[ebp-0Ch], edx
      jmp   @j_3
    @j_4:
      mov   ecx, dword ptr ss:[ebp-8]
      mov   eax, dword ptr ds:[ecx+28h]
      mov   edx, dword ptr ss:[ebp-0Ch]
      mov   byte ptr ds:[eax+edx], 0
      inc   dword ptr ss:[ebp-0Ch]
    @j_3:
      mov   ecx, dword ptr ss:[ebp-8]
      movzx eax, word ptr ds:[ecx+24h]
      cmp   eax, dword ptr ss:[ebp-0Ch]
      jg    @j_4
      xor   edx, edx
      mov   dword ptr ss:[ebp-10h], edx
      jmp   @j_5
    @j_6:
      mov   ecx, dword ptr ss:[ebp-10h]
      mov   ebx, dword ptr ss:[ebp-8]
      mov   byte ptr ds:[ebx+ecx], 0
      inc   dword ptr ss:[ebp-10h]
    @j_5:
      cmp   dword ptr ss:[ebp-10h], 48h
      jb    @j_6
      mov   al, 1
    @j_2:
      pop   ebx
      mov   esp, ebp
      pop   ebp
      ret

HideDLL         endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

XORStuff        proc    pstr:DWORD, pstr_new:DWORD

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

      push  ebp
      mov   ebp, esp

      mov    bl, byte ptr ds:[_hXORKey]
      mov   ecx, dword ptr ss:[pstr]
      mov   edi, ecx
      movzx ecx, byte ptr ds:[ecx]
      mov   edx, dword ptr ss:[pstr_new]
      dec   edx
    @loop_2:
      mov    al, byte ptr ds:[edi+ecx]
      xor    al, bl
      mov   byte ptr ds:[edx+ecx], al
      loop  @loop_2

      pop   ebp
      ret

XORStuff        endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

MyStrLen        proc    pstr:DWORD

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

      push  ebp
      mov   ebp, esp

      mov   ecx, dword ptr ss:[pstr]
      xor   eax, eax
      dec   eax
    @loop_1:
      inc   eax
      cmp   byte ptr ds:[ecx+eax], 0
      jne   @loop_1

      pop   ebp
      ret

MyStrLen        endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

MyStrCpy        proc    pstr:DWORD, pstr_new:DWORD

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

      push  ebp
      mov   ebp, esp

      mov   ecx, dword ptr ss:[pstr]
      mov   edx, dword ptr ss:[pstr_new]        ;yea yea this thingy MIGHT be optimized with LOOP or REP, whatever
      xor   edi, edi
      dec   edi
    @loop_1:
      inc   edi
      mov    al, byte ptr ds:[ecx+edi]
      mov   byte ptr ds:[edx+edi], al
      test   al, al
      jne   @loop_1

      pop   ebp
      ret

MyStrCpy        endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

MyStrLow        proc    pstr:DWORD

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

      push  ebp
      mov   ebp, esp

      mov   ecx, dword ptr ss:[pstr]
      push  ecx
      call  MyStrLen
      add   esp, 4h
      
      mov   ecx, eax
      inc   ecx

      mov   edx, dword ptr ss:[pstr]
      dec   edx
      
      inc   ecx
    @loop_1:
      dec   ecx
      mov   al, byte ptr ds:[edx+ecx]
      cmp   al, 41h
      jb    @loop_1_1
      cmp   al, 5Ah
      jg    @loop_1_1
      add   al, 20h
      mov   byte ptr ds:[edx+ecx], al
    @loop_1_1:
      inc   ecx
      loop  @loop_1

      pop   ebp
      ret

MyStrLow        endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

XORCMP          proc   pstr:DWORD, pstr2:DWORD

OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

      push  ebp
      mov   ebp, esp

      sub   esp, 100h
      lea   eax, dword ptr ss:[esp+1]
      push  eax
      push  dword ptr ss:[pstr2]
      call  MyStrCpy
      add   esp, 8h

      push  esp
 ;       push  esp
 ;       call  MyStrLen
 ;       add   esp, 4h
      
      mov   ecx, edi                    ;get str2 len
      inc   ecx                         ;len +1
      mov   byte ptr ss:[esp+4], cl
      push  ecx

      mov   eax, dword ptr ss:[esp+4]
      inc   eax
      push  eax
      dec   eax
      push  eax
      call  XORStuff
      add   esp, 8
      
      pop   ecx
      mov   eax, dword ptr ss:[pstr]    ;get str1 ptr
      mov   edi, eax                    ;store str1 ptr
      movzx eax, byte ptr ds:[eax]      ;get str1 len
      cmp   eax, ecx
      je    @loop_2_1
      mov   eax, dword ptr ss:[esp+100] ;get random num (not actaully random, but who cares)
      or    eax, 1h                     ;we need to make sure there's SOMETHING atleast
      jmp   @loop_2_end
    @loop_2_1:
      mov   edx, dword ptr ss:[esp]
      xor   esi, esi
    @loop_2:
      xor   eax, eax
      mov    al, byte ptr ds:[edi+ecx]
      mov    bl, byte ptr ss:[edx+ecx]
      xor    al, bl
      add   esi, eax
      loop  @loop_2
      mov   eax, esi
      
    @loop_2_end:
      add   esp, 104h
      pop   ebp
      ret      

XORCMP          endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

end	LibMain