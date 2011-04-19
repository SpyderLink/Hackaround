//#include <ddk\ntddk.h>; http://www.microsoft.com/downloads/en/details.aspx?displaylang=en&FamilyID=36a2630f-5d56-43b5-b996-7633f2ec14ff
#include "nt.h";

// just to make life easier, we create our own sleep like function 
// with argument in seconds
BOOL NtDelayExecutionEx(DWORD dwSeconds){
     LARGE_INTEGER Interval;
     Interval.QuadPart = -(unsigned __int64)dwSeconds * 10000 * 1000;
     NtDelayExecution (FALSE, &Interval);
}

void NtProcessStartup( PSTARTUP_ARGUMENT Argument ){ // entry point
UNICODE_STRING dbgMessage;	// unicode string
RtlInitUnicodeString(&dbgMessage, L"Hello from Native :)\n"); // lets initialize it
NtDisplayString( &dbgMessage );	// print message
NtDelayExecutionEx(5);	// sleep 5 secs
NtTerminateProcess( NtCurrentProcess(), 0 ); // terminate our own process and 
				// return control to session manager subsystem
}