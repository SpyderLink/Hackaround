// This is the main DLL file.

#include "stdafx.h"

#include "RNCLI.h"

#include < stdio.h >
#include < stdlib.h >
#include < vcclr.h >

using namespace System::Runtime::InteropServices;

namespace RNCLI 
{
	wchar_t* Patcher::wconv(System::String ^ str)
	{
		pin_ptr<const wchar_t> wchstr = PtrToStringChars(str);
		return const_cast<wchar_t*>(wchstr);
	}
	char* Patcher::cconv(System::String ^ str)
	{
		return (char*)(void*)Marshal::StringToHGlobalAnsi(str);
	}
	int Patcher::Inject(System::String ^ processName, System::String ^ moduleName, System::String ^ offsetstring, System::String ^ bytes)
	{
		unsigned char arr[2]; arr[0] = 0; arr[1] = 0;
		unsigned long int offset = atol( cconv(offsetstring) );
		unsigned int size = sizeof(arr);
		return RNInvoke::Native::PatchSomething( wconv(processName), wconv(moduleName), offset, arr, size);
	}
}