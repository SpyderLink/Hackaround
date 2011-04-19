#include "stdafx.h";
#include <winternl.h>

#define NtCurrentProcess() ( (HANDLE) -1 )
// structures...
typedef struct {
       ULONG            Unknown[21];
       UNICODE_STRING   CommandLine;
       UNICODE_STRING   ImageFile;
} ENVIRONMENT_INFORMATION, *PENVIRONMENT_INFORMATION;

typedef struct {
       ULONG                     Unknown[3];
       PENVIRONMENT_INFORMATION  Environment;
} STARTUP_ARGUMENT, *PSTARTUP_ARGUMENT;

// function definitions..
NTSTATUS NTAPI NtDisplayString(PUNICODE_STRING String );	// similar to win32 
							// sleep function
NTSTATUS NTAPI NtDelayExecution(IN BOOLEAN Alertable, 
			IN PLARGE_INTEGER DelayInterval ); // like sleep
NTSTATUS NTAPI NtTerminateProcess(HANDLE ProcessHandle, 
				LONG ExitStatus ); // terminate own process
VOID NTAPI RtlInitUnicodeString(PUNICODE_STRING DestinationString,
			PCWSTR SourceString); // initialization of unicode string