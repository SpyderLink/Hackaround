#include <stdio.h>
#include <string.h>
#include <windows.h>
#include <Tlhelp32.h>

#ifdef _MANAGED
#pragma managed(push, off)
#endif

#define DLLExport   __declspec(dllexport)
//#pragma argsused

void GetDebugPriv();
char* ToLowerSTR(char*);
DWORD GetPID(char*);
DWORD GetMOD(DWORD, char*);

extern "C"
{
	DLLExport int PatchSomething(char*, char*, DWORD, unsigned char*, unsigned short int);
}
