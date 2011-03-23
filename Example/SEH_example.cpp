#define WIN32_LEAN_AND_MEAN
#include <windows.h>		
#include "detours.h"	// download from http://research.microsoft.com/sn/detours/


LONG	WINAPI UnhandlerExceptionFilter(struct _EXCEPTION_POINTERS* ExceptionInfo);	// Our exception filter
DWORD	WINAPI GetTickCount_Detour(void);											// Our detoured GetTickCount()
BOOL	WINAPI GetThreadContext_Detour (HANDLE hThread,LPCONTEXT lpContext);		// Our detoured GetThreadContext()

DETOUR_TRAMPOLINE(BOOL WINAPI GetThreadContext_Trampoline(HANDLE ,LPCONTEXT) ,GetThreadContext);	// detour macro for (empty)trampoline

// Function defines
void	Set_SEH_and_BreakPoints(void);			// Set the SEH and breakpoints
LPTOP_LEVEL_EXCEPTION_FILTER oldHandler=NULL;	// Pointer to existing exception handler

// Global variables
DWORD	dwBreakPoint=0x100334f;					// The hardware-breakpoint (4 available)
int		nBreakPointJump=0x18;					// How many bytes we make EIP to skip from this breakpoint
BYTE	opcodes[5];								// Original opcodes in GetTickCount() entry-point to be stored for restoring


// DLL entrypoint which OS-loader calls for us after injecting
BOOL APIENTRY DllMain( HANDLE hModule, DWORD  ul_reason_for_call, LPVOID lpReserved)
{
	switch(ul_reason_for_call)
	{
		case DLL_PROCESS_ATTACH:
			DisableThreadLibraryCalls(GetModuleHandle(NULL));

			MessageBox(NULL,"We are in and hooked !","SEH_example",0);

			// Store original opcodes under GetTickCount()
			ReadProcessMemory(GetCurrentProcess(),(LPVOID)GetProcAddress(GetModuleHandle("Kernel32"),"GetTickCount"),&opcodes,5,0);
			
			// Hijack GetTickCount to jmp to our GetTickCount_Detour 
			DetourFunction((PBYTE)GetTickCount,(PBYTE)GetTickCount_Detour);

			// Hijack also GetThreadContext() to hide debug-registers altering
			DetourFunctionWithTrampoline((PBYTE)GetThreadContext_Trampoline,(PBYTE)GetThreadContext_Detour);	

		break;

		case DLL_PROCESS_DETACH:
			// Try to remove all hooks and handlers.
			DetourRemove((PBYTE) GetThreadContext_Trampoline,(PBYTE) GetThreadContext_Detour);
			WriteProcessMemory(GetCurrentProcess(),(LPVOID)GetProcAddress(GetModuleHandle("Kernel32"),"GetTickCount"),&opcodes,5,0);
			if (oldHandler) SetUnhandledExceptionFilter(oldHandler);
		break;
	}

	return true;
}

// Hijacked GetTickCount. This is called when target-app (Notepad) is calling GetTickCount()
DWORD WINAPI GetTickCount_Detour()
{
	// From here we add our Structured Exception Handler
	// We can't add it in the DLLmain since that function is called in 
	// different thread-context and the SEH and Breakpoints are per thread basis
	Set_SEH_and_BreakPoints();

	// Return original bytes to GetTickCount() i.e. unhook it. We only need this "callback" once.
	WriteProcessMemory(GetCurrentProcess(),(LPVOID)GetProcAddress(GetModuleHandle("Kernel32"),"GetTickCount"),&opcodes,5,0);

	MessageBox(NULL,"HW-breakpoints are set !","SEH_example",0);

	// Return actual function result
	return GetTickCount();
}

// Add the SEH-handler and set HW-breakpoint(s)
void Set_SEH_and_BreakPoints()
{
	// Store existing handler to global variable to reset later
	oldHandler=SetUnhandledExceptionFilter(UnhandlerExceptionFilter);
	
	// Set debug-registers for HW-breakpoint and activate it
	CONTEXT ctx = {CONTEXT_DEBUG_REGISTERS};
	ctx.Dr6 = 0x00000000;

	ctx.Dr0 = dwBreakPoint;		// Set Address of Breakpoint 1
	ctx.Dr7 = 0x00000001;		// Activate Breakpoint 1

	/*
	use these for setting more breakpoints	

	ctx.Dr1=address;			// Set Address of Breakpoint 2
	ctx.Dr7 |= 0x00000004;		// Activate Breakpoint 2
    
	ctx.Dr2=address;			// Set Address of Breakpoint 3
	ctx.Dr7 |= 0x00000010;		// Activate Breakpoint 3
	
	ctx.Dr3=address;			// Set Address of Breakpoint 4
	ctx.Dr7 |= 0x00000040;		// Activate Breakpoint 4
	*/


	// Write the values to registers. From now on the breakpoint is active 
	SetThreadContext(GetCurrentThread(), &ctx); 
}

// Our ExceptionHandler
// study the ExceptionInfo-struct for stuff you need
LONG WINAPI UnhandlerExceptionFilter(struct _EXCEPTION_POINTERS* ExceptionInfo)
{
	// HW-breakpoints DON'T generate EXCEPTION_BREAKPOINT but EXCEPTION_SINGLE_STEP so we check for that
	if(ExceptionInfo->ExceptionRecord->ExceptionCode==EXCEPTION_SINGLE_STEP )
	{	
		// Verify that the breakpoint was the one we set
		if ((DWORD)ExceptionInfo->ExceptionRecord->ExceptionAddress==dwBreakPoint) 
		{
			// move instruction pointer forward to skip unwanted instructions and let 
			// the process continue as nothing has happened
			ExceptionInfo->ContextRecord->Eip+=nBreakPointJump;
			return EXCEPTION_CONTINUE_EXECUTION;
		}
	}

	// Some other exception occured. Pass it to next handler
	return EXCEPTION_CONTINUE_SEARCH;
}

// Hijacked GetThreadContext(). We don't actually need this in our notepad-example
// I included it just for help since for a real hack you need to fake 
// DEBUG-registers so that the game doesn't see they that are altered
//
BOOL WINAPI GetThreadContext_Detour (HANDLE hThread,LPCONTEXT lpContext)
{
	// Get the Real values from original API-function (see the _trampoline)
	BOOL ret=GetThreadContext_Trampoline( hThread, lpContext);

	// If target is interested in Debug-registers return fake values 
	if (lpContext->ContextFlags && CONTEXT_DEBUG_REGISTERS) {
		lpContext->Dr0=0;
		lpContext->Dr1=0;
		lpContext->Dr2=0;
		lpContext->Dr3=0;
		lpContext->Dr6=0;
		lpContext->Dr7=0;
	}

	return ret;
}
