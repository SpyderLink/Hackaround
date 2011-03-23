DWORD GetDLLBase(char* DllName, DWORD tPid)
{
HANDLE snapMod;
MODULEENTRY32 me32;

if (tPid == 0) return 0;
snapMod = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, tPid);
me32.dwSize = sizeof(MODULEENTRY32);
if (Module32First(snapMod, &me32)){
do{
if (strcmp(DllName,me32.szModule) == 0){
CloseHandle(snapMod);
return (DWORD) me32.modBaseAddr;
}