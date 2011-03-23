#define PATCH(i,w,l) WriteProcessMemory(hProc,reinterpret_cast<LPVOID>( gameBase+i),w,l,&dSize)
#define NPATCH(i,w,l) WriteProcessMemory(hProc,reinterpret_cast<LPVOID>( i),w,l,&dSize)

// this old things came from sd3322111 nad still being alive ...