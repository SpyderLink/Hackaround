DWORD GetProcessPID (char* process)
{
	BOOL working=0;
	PROCESSENTRY32 lppe= {0};
	DWORD targetPid=0;

	HANDLE hSnapshot=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS ,0);
	if (hSnapshot)
	{
		lppe.dwSize=sizeof(lppe);
		working=Process32First(hSnapshot,&lppe);
		while (working)
		{
			if(stricmp(lppe.szExeFile,process)==0)
			{
				targetPid=lppe.th32ProcessID;
				break;
			}
			working=Process32Next(hSnapshot,&lppe);
		}		
	}
	CloseHandle( hSnapshot );
	return targetPid;
}