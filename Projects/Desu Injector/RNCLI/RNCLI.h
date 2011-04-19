// RNCLI.h

#pragma once

using namespace System;

namespace RNCLI {

	public ref class Patcher
	{
	private :
		wchar_t* wconv(System::String ^ str);
		char* cconv(System::String ^ str);
	public : 
		int Inject(System::String ^ processName, System::String ^ moduleName, System::String ^ offsetstring, System::String ^ bytes);
	};
}
