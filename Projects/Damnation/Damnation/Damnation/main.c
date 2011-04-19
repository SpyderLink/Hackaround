#include "stdafx.h"
#include "header.h"

BOOL GimmeNative(){
    HMODULE hObsolete  = GetModuleHandle("ntdll.dll");
    *(FARPROC *)&NtAwesomeFunction = GetProcAddress(hObsolete, "NtAwesomeFunction");
    return 0;
}

int _tmain(int argc, _TCHAR* argv[])
{
    MY_AWESOME_STRUCTURE argument1;
    PCWSTR argument2;
    GimmeNative();
    NtAwesomeFunction(argument1, argument2);
    return 0;
}