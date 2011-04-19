#include "main.h"

//---------------------------------------------------------------------------
int lasterr;
//---------------------------------------------------------------------------

BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fwdreason, LPVOID lpvReserved)
{
	switch(fwdreason)
	{
	case DLL_PROCESS_ATTACH:
		{lasterr = 0; GetDebugPriv();}
		break;
	case DLL_PROCESS_DETACH:
		break;
	case DLL_THREAD_ATTACH:
		break;
	case DLL_THREAD_DETACH:
		break;
	}
	return TRUE;
}
//---------------------------------------------------------------------------

void GetDebugPriv()
{
	HANDLE hToken;
	LUID sedebugnameValue;
	TOKEN_PRIVILEGES tkp;
	if (!OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, &hToken)) 
	{
		lasterr = -3; 
		return;
	}
	if (!LookupPrivilegeValue(NULL, SE_DEBUG_NAME, &sedebugnameValue))
	{
		CloseHandle(hToken);
		lasterr = -2;
		return;
	}
	tkp.PrivilegeCount = 1;
	tkp.Privileges[0].Luid = sedebugnameValue;
	tkp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;
	if (!AdjustTokenPrivileges(hToken, FALSE, &tkp, sizeof tkp, NULL, NULL)) 
	{CloseHandle(hToken); lasterr = -1;
	}
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

DLLExport int PatchSomething(char* name, char* module, DWORD offset, unsigned char* bytes, unsigned short int size)
{
	if (lasterr != 0) {return lasterr;}

	DWORD pid, offmod;
	if (!(pid = GetPID(name))) {return lasterr;}
	if (!(offmod = GetMOD(pid, module))) {return lasterr;}

	HANDLE hProc;
	if (!(hProc = OpenProcess(PROCESS_ALL_ACCESS, false, pid))) {return 3;}

	DWORD oldprot;
	if (!VirtualProtectEx(hProc, (void*)(offmod + offset), size, PAGE_EXECUTE_READWRITE, &oldprot)) {return 4;}
	if (!WriteProcessMemory(hProc, (void*)(offmod + offset), bytes, size, NULL)) {return 5;}
	if (!VirtualProtectEx(hProc, (void*)(offmod + offset), size, oldprot, &oldprot)) {return 6;}

	return 0;
}
//---------------------------------------------------------------------------
