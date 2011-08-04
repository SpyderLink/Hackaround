//---------------------------------------------------------------------------
#include <stdlib.h>
#include <windows.h>

//---------------------------------------------------------------------------

void GetDebugPriv();
void Patch(bool);
void WorkerThread();

//---------------------------------------------------------------------------

#pragma argsused
BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fwdreason, LPVOID lpvReserved)
{
 if (fwdreason != DLL_PROCESS_ATTACH)
  return true;

 GetDebugPriv();
 CreateThread(NULL, NULL, (LPTHREAD_START_ROUTINE)WorkerThread, NULL, NULL, NULL);

 return true;
}
//---------------------------------------------------------------------------

void GetDebugPriv()
{
 HANDLE hToken;
 LUID sedebugnameValue;
 TOKEN_PRIVILEGES tkp;
 if (!OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, &hToken)) {return;}
 if (!LookupPrivilegeValue(NULL, SE_DEBUG_NAME, &sedebugnameValue))
 {
  CloseHandle(hToken);
  return;
 }
 tkp.PrivilegeCount = 1;
 tkp.Privileges[0].Luid = sedebugnameValue;
 tkp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;
 if (!AdjustTokenPrivileges(hToken, FALSE, &tkp, sizeof tkp, NULL, NULL)) {CloseHandle(hToken);}
}
//---------------------------------------------------------------------------

void Patch(bool dolocalecho)
{
 DWORD  dwtemp, reladdr;
 DWORD  execbase = (DWORD)GetModuleHandle("putty.exe") + 0x1000;
 char   funcon[]   = "\x33\xC0\x90\x90\x90\x90";
 char   funcoff[]  = "\x33\xC0\x40\x40\x90\x90";

 dolocalecho ? (reladdr = 0x6A05) : (reladdr = 0x6A82);

 HANDLE hProc    = OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessId());
 VirtualProtectEx(hProc, (void*)(execbase + reladdr), 6, PAGE_EXECUTE_READWRITE, &dwtemp);

 bool retval = memcmp((void*)(execbase + reladdr), (void*)funcoff, 6);

 memcpy((void*)(execbase + reladdr), ((!retval) ? funcon : funcoff), 6);
}
//---------------------------------------------------------------------------

void WorkerThread()
{
 RegisterHotKey(NULL, 1337, MOD_ALT | MOD_NOREPEAT, 0x51);   //Q
 RegisterHotKey(NULL, 1338, MOD_ALT | MOD_NOREPEAT, 0x45);   //E

 MessageBoxA(NULL, "Hotkeys installed!", NULL, MB_OK);

 MSG  message;
 WORD vkk;
 DWORD lParam;

 while (GetMessage(&message, NULL, 0, 0))
 {
  if (message.message == WM_HOTKEY)
  {
   lParam = message.lParam;

   __asm
   {
	PUSH EAX
	XOR  EAX, EAX
	ADD  ESP, 4
	MOV  AX, WORD PTR DS:[&lParam + 2]
	MOV  vkk, AX
	SUB  ESP, 4
	POP  EAX
   }

   switch (vkk)
   {
	case 0x51: {Patch(true);} break;
	case 0x45: {Patch(false);} break;
	default: {} break;
   }
  }
 }

 UnregisterHotKey(NULL, 1337);
 UnregisterHotKey(NULL, 1338);

 MessageBoxA(NULL, "Hotkeys uninstalled!", NULL, MB_OK);

 ExitThread(EXIT_SUCCESS);
}
//---------------------------------------------------------------------------