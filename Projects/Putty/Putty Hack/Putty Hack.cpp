#include "stdafx.h"

int lasterr;

void GetDebugPriv()
{
    HANDLE hToken;
    LUID sedebugnameValue;
    TOKEN_PRIVILEGES tkp;

    if (!OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, &hToken)) 
        {return;}

    if (!LookupPrivilegeValue(NULL, SE_DEBUG_NAME, &sedebugnameValue))
    {
        CloseHandle(hToken);
        return;
    }

    tkp.PrivilegeCount = 1;
    tkp.Privileges[0].Luid = sedebugnameValue;
    tkp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;

    if (!AdjustTokenPrivileges(hToken, FALSE, &tkp, sizeof tkp, NULL, NULL)) 
        {CloseHandle(hToken);}
}
//---------------------------------------------------------------------------
char *ToLowerSTR(char * str)
{
	int l = strlen(str);
	for (int i = 0; i <= l; i++)
	{
		if (str[i] >= 0x41 && str[i] <= 0x5A)
			str[i] = str[i] + 0x20;
	}
	return str;
}
//---------------------------------------------------------------------------
DWORD GetPID(char* name)
{
	char temp[256];
	DWORD pid = 0;
	BOOL working;
	PROCESSENTRY32 lppe = {0};

	lppe.dwFlags = sizeof(PROCESSENTRY32);

	strcpy_s(temp, name);

	HANDLE hSnapshot;

	hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS ,0);
	if (hSnapshot)
	{
		lppe.dwSize = sizeof(lppe);
		working = Process32First(hSnapshot,&lppe);
		while (working)
		{
			if(strcmp(ToLowerSTR( lppe.szExeFile ), ToLowerSTR(temp)) == 0)
			{
				pid = lppe.th32ProcessID;
				break;
			}
			working = Process32Next(hSnapshot,&lppe);
			if (working == false)
			{
				lasterr = 1;
				return 0;
			}
		}
		CloseHandle(hSnapshot);
	}

	return pid;
}
//---------------------------------------------------------------------------

DWORD GetMOD(DWORD pid, char* name)
{
	char temp[256];
	DWORD retval = 0;
	BOOL working;
	MODULEENTRY32 me32 = {0};
	me32.dwSize = sizeof(MODULEENTRY32);

	strcpy_s(temp, name);

	HANDLE hSnapshot;

	hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, pid);
	if (hSnapshot)
	{
		working = Module32First(hSnapshot, &me32);
		while (working)
		{
			if (strcmp(ToLowerSTR(me32.szModule), ToLowerSTR(temp)) == 0)
			{
				retval = (DWORD)me32.modBaseAddr;
				break;
			}
			working = Module32Next(hSnapshot,&me32);
			if (working == false)
			{
				lasterr = 2;
				return 0;
			}
		}
		CloseHandle(hSnapshot);
	}

	return retval;
}
//---------------------------------------------------------------------------
void Patch(bool turnon, bool dolocalecho)
{
	if (lasterr != 0) {return;}

	DWORD pid, execbase;
	if (!(pid = GetPID("putty.exe"))) {return;}
	if (!(execbase = GetMOD(pid, "putty.exe"))) {return;}

    DWORD  dwtemp, reladdr;
    //DWORD  execbase = (DWORD)GetModuleHandle("putty.exe") + 0x1000;
    char   funcon[]   = "\x33\xC0\x90\x90\x90\x90";
    char   funcoff[]  = "\x33\xC0\x40\x40\x90\x90";
 
    dolocalecho ? (reladdr = 0x6A05) : (reladdr = 0x6A82);
 
    // ERROR ERROR ERROR 111111 ERROR

    HANDLE hProc    = OpenProcess(PROCESS_ALL_ACCESS, false, pid); // GetCurrentProcessId()
    VirtualProtectEx(hProc, (void*)(execbase + reladdr), 6, PAGE_EXECUTE_READWRITE, &dwtemp);
 
    memcpy((void*)(execbase + reladdr), (turnon ? funcon : funcoff), 6);
}
//--------------------------------------------------------------------------- 

#define q 0x51
#define e 0x45

int _tmain(int argc, _TCHAR* argv[])
{
    RegisterHotKey(NULL, 0, MOD_ALT | MOD_NOREPEAT , q); 
    RegisterHotKey(NULL, 0, MOD_ALT | MOD_NOREPEAT , e); 

    BOOL checked = true;

    GetDebugPriv();

    MSG   msg ={0};
    while (GetMessage(&msg, NULL, 0, 0) != 0) 
    {
        if (msg.message==WM_HOTKEY) 
        {
            if (HIWORD(msg.lParam) == q)
            {
                break;
            } else
            if (HIWORD(msg.lParam) == e)
            {
                if(checked)
                {
                    Patch(false,false);
                    Patch(true,false);
                }
                else
                {
                    Patch(false,true);
                    Patch(true,true);
                }
            }
        }
    }
    return 0;
}