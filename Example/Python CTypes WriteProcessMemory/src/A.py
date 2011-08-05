from ctypes import * #@UnusedWildImport
from ctypes.wintypes import BOOL

BYTE      = c_ubyte
WORD      = c_ushort
DWORD     = c_ulong
LPBYTE    = POINTER(c_ubyte)
LPTSTR    = POINTER(c_char) 
HANDLE    = c_void_p
PVOID     = c_void_p
LPVOID    = c_void_p
UNIT_PTR  = c_ulong
SIZE_T    = c_ulong

class STARTUPINFO(Structure):
    _fields_ = [("cb",            DWORD),        
                ("lpReserved",    LPTSTR), 
                ("lpDesktop",     LPTSTR),  
                ("lpTitle",       LPTSTR),
                ("dwX",           DWORD),
                ("dwY",           DWORD),
                ("dwXSize",       DWORD),
                ("dwYSize",       DWORD),
                ("dwXCountChars", DWORD),
                ("dwYCountChars", DWORD),
                ("dwFillAttribute",DWORD),
                ("dwFlags",       DWORD),
                ("wShowWindow",   WORD),
                ("cbReserved2",   WORD),
                ("lpReserved2",   LPBYTE),
                ("hStdInput",     HANDLE),
                ("hStdOutput",    HANDLE),
                ("hStdError",     HANDLE),]

class PROCESS_INFORMATION(Structure):
    _fields_ = [("hProcess",    HANDLE),
                ("hThread",     HANDLE),
                ("dwProcessId", DWORD),
                ("dwThreadId",  DWORD),]

class MEMORY_BASIC_INFORMATION(Structure):
    _fields_ = [("BaseAddress", PVOID),
                ("AllocationBase", PVOID),
                ("AllocationProtect", DWORD),
                ("RegionSize", SIZE_T),
                ("State", DWORD),
                ("Protect", DWORD),
                ("Type", DWORD),]

class SECURITY_ATTRIBUTES(Structure):
    _fields_ = [("Length", DWORD),
                ("SecDescriptor", LPVOID),
                ("InheritHandle", BOOL)]

class Main():
    def __init__(self):
        self.h_process = None
        self.pid = None

    def launch(self, path_to_exe):
        #CREATE_NEW_CONSOLE = 0x00000010
        CREATE_PRESERVE_CODE_AUTHZ_LEVEL = 0x02000000

        startupinfo = STARTUPINFO()
        process_information = PROCESS_INFORMATION()
        security_attributes = SECURITY_ATTRIBUTES()

        startupinfo.dwFlags = 0x1
        startupinfo.wShowWindow = 0x0


        startupinfo.cb = sizeof(startupinfo)
        security_attributes.Length = sizeof(security_attributes)
        security_attributes.SecDescriptior = None
        security_attributes.InheritHandle = True

        if windll.kernel32.CreateProcessA(path_to_exe,
                                   None,
                                   byref(security_attributes),
                                   byref(security_attributes),
                                   True,
                                   CREATE_PRESERVE_CODE_AUTHZ_LEVEL,
                                   None,
                                   None,
                                   byref(startupinfo),
                                   byref(process_information)):

            self.pid = process_information.dwProcessId
            print ("Success: CreateProcess - ", path_to_exe)
        else:
            print ("Failed: Create Process - Error code: ", windll.kernel32.GetLastError())

    def get_handle(self, pid):
        #PROCESS_ALL_ACCESS = 0x001F0FFF
        PROCESS_VM_READ = 0x0010
        self.h_process = windll.kernel32.OpenProcess(PROCESS_VM_READ, False, pid)
        if self.h_process:
            print ("Success: Got Handle - PID:", self.pid)
        else:
            print ("Failed: Get Handle - Error code: ", windll.kernel32.GetLastError())
            windll.kernel32.SetLastError(10000)

    def read_memory(self, address):
        bufferSize = 32
        buffer = create_string_buffer(bufferSize)
        bytesRead = c_ulong(0)
        if windll.kernel32.ReadProcessMemory(self.h_process, address, buffer, bufferSize, byref(bytesRead)):
            print ("Success: Read Memory - ", buffer.value)
        else:
            print ("Failed: Read Memory - Error Code: ", windll.kernel32.GetLastError())
            windll.kernel32.CloseHandle(self.h_process)
            windll.kernel32.SetLastError(10000)

    def write_memory(self, address, data):
        count = c_ulong(0)
        length = len(data)
        c_data = c_char_p(data[count.value:])
        c_int(0)
        if not windll.kernel32.WriteProcessMemory(self.h_process, address, c_data, length, byref(count)):
            print  ("Failed: Write Memory - Error Code: ", windll.kernel32.GetLastError())
            windll.kernel32.SetLastError(10000)
        else:
            return False

    def virtual_query(self, address):
        basic_memory_info = MEMORY_BASIC_INFORMATION()
        windll.kernel32.SetLastError(10000)
        result = windll.kernel32.VirtualQuery(address, byref(basic_memory_info), byref(basic_memory_info))
        if result:
            return True
        else:
            print ("Failed: Virtual Query - Error Code: ", windll.kernel32.GetLastError())


main = Main()
address = None
main.launch("D:\Funtoo\putty.exe")
main.get_handle(main.pid)
#main.write_memory(address, "\x61")
while 1:
    print ('1 to enter an address')
    print ('2 to virtual query address')
    print ('3 to read address')
    choice = input('Choice: ')
    if choice == '1':
        address = input('Enter and address: ')
    if choice == '2':
        main.virtual_query(address)
    if choice == '3':
        main.read_memory(address)
