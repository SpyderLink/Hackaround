
#include <tchar.h>
#include <windows.h>
#include <stdio.h>
#include <Tlhelp32.h>

//using namespace std;

int main(int argc, char *argv[])
{
 char temp[255], proc[255], dll[255];

 HANDLE hToken;
 LUID sedebugnameValue;
 TOKEN_PRIVILEGES tkp;
  if (!OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, &hToken)) puts("Failed to Enable Debug Options!");
  if (!LookupPrivilegeValue(NULL, SE_DEBUG_NAME, &sedebugnameValue))
  {
   CloseHandle(hToken);
   puts("Failed to Enable Debug Options!");
   gets(temp);
   return 0;
  }
 tkp.PrivilegeCount = 1;
 tkp.Privileges[0].Luid = sedebugnameValue;
 tkp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;
 if (!AdjustTokenPrivileges(hToken, FALSE, &tkp, sizeof tkp, NULL, NULL)) CloseHandle(hToken);

 puts("---------------------------------");
 puts("-------- Simple injector --------");
 puts("---------- 1stH cookie ----------");
 puts("---------------------------------");

 puts("\nProcess name: ");
 gets(proc);
 
 puts("\nLooking for process...");

 DWORD pid = 0, appbase = 0;
 BOOL working = 0;
 PROCESSENTRY32 lppe = {0};
 lppe.dwFlags = sizeof(PROCESSENTRY32);

 HANDLE hSnapshot;

  hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS ,0);
  if (hSnapshot)
  {
   lppe.dwSize = sizeof(lppe);
   working = Process32First(hSnapshot,&lppe);
   while (working)
   {
    if(strcmp(lppe.szExeFile,proc) == 0)
    {
     pid = lppe.th32ProcessID;
     break;
    }
    working = Process32Next(hSnapshot,&lppe);
   }
  CloseHandle(hSnapshot);
  }
  else
  {
   puts("ERR: Couldn't create snapshot!");
   gets(temp);
   return 0;
  }

 if (pid == NULL) {puts("ERR: Process not found!"); gets(temp); return 0;}
 HANDLE hProc = OpenProcess(PROCESS_ALL_ACCESS, false, pid);

 if (hProc == NULL) {puts("ERR: Couldn't create handle!"); gets(temp); return 0;}

 puts("\nDLL name: ");
 gets(dll);
 
 FILE* in = fopen(dll, "r");
 if (!in) {puts("ERR: DLL not found!"); gets(temp); return 0;}
  else {fclose(in);}

 puts("\nInjecting DLL...");

 char* DirPath = new char[MAX_PATH];
 char* FullPath = new char[MAX_PATH];
 GetCurrentDirectory(MAX_PATH, DirPath);
 sprintf(FullPath, "%s\\%s", DirPath, dll);
 LPVOID LoadLibraryAddr = (LPVOID)GetProcAddress(GetModuleHandle("kernel32.dll"), "LoadLibraryA");
 LPVOID LLParam = (LPVOID)VirtualAllocEx(hProc, NULL, strlen(FullPath), MEM_RESERVE | MEM_COMMIT, PAGE_READWRITE);
 WriteProcessMemory(hProc, LLParam, FullPath, strlen(FullPath), NULL);
 CreateRemoteThread(hProc, NULL, NULL, (LPTHREAD_START_ROUTINE)LoadLibraryAddr, LLParam, NULL, NULL);
 CloseHandle(hProc);
 delete [] DirPath;
 delete [] FullPath;

 puts("\nDone! :3");
 gets(temp);
 return 0;
}
