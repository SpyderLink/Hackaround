//---------------------------------------------------------------------------

#include <vcl.h>
#include <stdio.h>
#include <Tlhelp32.h>
#include <windows.h>
#include <wincrypt.h>
#pragma hdrstop

#include "main.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TMainForm *MainForm;
//---------------------------------------------------------------------------

char* do_md5(char data[], unsigned long int size);
void DumpFile(char data[], char name[]);
void ScanPID(DWORD* list);
void ScanMod(DWORD pid, DWORD* list);
void Refresh_lb();

DWORD pid_list[255];
DWORD mod_list[255];
DWORD sec_list[255];
DWORD sec_ra_list[255];

//---------------------------------------------------------------------------
__fastcall TMainForm::TMainForm(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::b_fpathselClick(TObject *Sender)
{
 c_filedial->Execute();
 e_fpath->Text = c_filedial->FileName;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::b_fhashClick(TObject *Sender)
{
 char* data;
 FILE* in = fopen(e_fpath->Text.t_str(), "rb");
 if (in == 0) {ShowMessage("File not found or can't be accessed for reading."); return;}
 fseek(in, 0, SEEK_END);
 unsigned long int size = ftell(in);
 fclose(in);

 data = new char[size+1];

 DumpFile(data, e_fpath->Text.t_str());
 e_fhash->Text = UnicodeString(do_md5(data, size));

 delete[] data;
}
//---------------------------------------------------------------------------
char* do_md5(char data[], unsigned long int size)
{
 HCRYPTPROV hProv;
 HCRYPTHASH hHash;

 unsigned char md5hash[17];
 DWORD md5hash_size;
 DWORD dwSize = 4;  //sizeof(DWORD)
 static char str_hash[33];
 unsigned int i;
 char temp[255];

 memset(str_hash, 0, sizeof(str_hash));
 memset(md5hash, 0, sizeof(md5hash));

 CryptAcquireContext(&hProv, NULL, NULL, PROV_RSA_FULL, 0);
 CryptCreateHash(hProv, CALG_MD5, 0, 0, &hHash);
 CryptHashData(hHash, (BYTE*)data, size, 0);
 CryptGetHashParam(hHash, HP_HASHSIZE, (BYTE*)&md5hash_size, &dwSize, 0);
 CryptGetHashParam(hHash, HP_HASHVAL, md5hash, &md5hash_size, 0);
 CryptDestroyHash(hHash);
 CryptReleaseContext(hProv, 0);

 for(i = 0 ; i < md5hash_size ; i++)
 {
  sprintf(str_hash + 2*i, "%2.2x", md5hash[i]);
 }

 return str_hash;
}
//---------------------------------------------------------------------------
void DumpFile(char data[], char name[])
{
 FILE* in = fopen(name, "rb");
 unsigned long int i = 0;

 do {data[i] = fgetc (in); i++;}
  while (!feof(in));

 fclose(in);
 return;
}
//---------------------------------------------------------------------------
void ScanPID(DWORD* list)
{
 DWORD pid = 0;
 BOOL working = 0;
 PROCESSENTRY32 lppe = {0};
 lppe.dwFlags = sizeof(PROCESSENTRY32);
 unsigned int i = 0;

 HANDLE hSnapshot;

   hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS ,0);
   if (hSnapshot)
   {
	lppe.dwSize = sizeof(lppe);
	working = Process32First(hSnapshot,&lppe);
	while (working)
	{
	 MainForm->lb_proc->Items->Add(UnicodeString(lppe.szExeFile));
	 list[i] = lppe.th32ProcessID;
	 working = Process32Next(hSnapshot,&lppe);
	 i++;
	}
   }
  CloseHandle(hSnapshot);
 return;
}
//---------------------------------------------------------------------------
void ScanMod(DWORD pid, DWORD* list)
{
 MainForm->lb_mod->Items->Clear();
 MainForm->tv_memspc->Items->Clear();
 MainForm->clb_sec->Items->Clear();
 memset(mod_list, 0, sizeof(mod_list));

 DWORD retval = 0;
 BOOL working = 0;
 MODULEENTRY32 me32 = {0};
 me32.dwSize = sizeof(MODULEENTRY32);
 unsigned int i = 0;

 HANDLE hSnapshot;

  hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, pid);
  if (hSnapshot)
  {
   working = Module32First(hSnapshot, &me32);
   while (working)
   {
	MainForm->lb_mod->Items->Add(UnicodeString(me32.szModule));
	list[i] = (DWORD)me32.modBaseAddr;
	working = Module32Next(hSnapshot,&me32);
	i++;
   }
   CloseHandle(hSnapshot);
  }
 return;
}
//---------------------------------------------------------------------------
void Refresh_lb()
{
 memset(pid_list, 0, sizeof(pid_list));
 memset(mod_list, 0, sizeof(mod_list));
 memset(sec_list, 0, sizeof(sec_list));
 memset(sec_ra_list, 0, sizeof(sec_ra_list));
 MainForm->lb_proc->Items->Clear();
 MainForm->lb_mod->Items->Clear();
 MainForm->tv_memspc->Items->Clear();
 MainForm->clb_sec->Items->Clear();
 ScanPID(pid_list);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::b_refreshClick(TObject *Sender)
{
 Refresh_lb();
}
//---------------------------------------------------------------------------

void __fastcall TMainForm::lb_procClick(TObject *Sender)
{
 if (MainForm->lb_proc->ItemIndex != -1)
  {ScanMod(pid_list[MainForm->lb_proc->ItemIndex], mod_list);}
}
//---------------------------------------------------------------------------

void __fastcall TMainForm::lb_modClick(TObject *Sender)
{
 if (MainForm->lb_mod->ItemIndex != -1)
 {
  MainForm->tv_memspc->Items->Clear();
  MainForm->clb_sec->Items->Clear();
  memset(sec_list, 0, sizeof(sec_list));
  memset(sec_ra_list, 0, sizeof(sec_ra_list));

  char data[0x1000];
  char block[8]; block[8] = '\0';
  char temp[255];
  unsigned long int dwRead = 0;
  unsigned int i = 0;
  unsigned long int pe_base = 0;
  DWORD size = 0;
  TTreeNode* last_node = 0;
  memset(data, 0, sizeof(data));
  memset(block, 0, sizeof(block));
  memset(temp, 0, sizeof(temp));

  HANDLE hProc = OpenProcess(PROCESS_VM_READ, false, pid_list[MainForm->lb_proc->ItemIndex]);

  if (!hProc) {ShowMessage("Could not open handle to the process."); return;}

  ReadProcessMemory(hProc,
					(LPCVOID)(mod_list[MainForm->lb_mod->ItemIndex]),
					data, 0x1000, &dwRead);

  pe_base = (unsigned long int)(data + (*(unsigned long int*)(data + 0x3C)));

  while (i < *(unsigned short int*)(pe_base + 0x06))
  {
   memcpy(block, (void*)(pe_base + 0xF8 + 0x28*i), 8);
   last_node = MainForm->tv_memspc->Items->Add(0, UnicodeString(block));
   MainForm->clb_sec->Items->Add(UnicodeString(block));

   memcpy(&size, (void*)(pe_base + 0xF8 + 0x28*i + 0x0C), 4);
   sprintf(temp, "Rel. addr.: +0x%X", size);
   sec_ra_list[i] = size;
   MainForm->tv_memspc->Items->AddChild(last_node, UnicodeString(temp));

   memcpy(&size, (void*)(pe_base + 0xF8 + 0x28*i + 0x10), 4);
   sprintf(temp, "Size: 0x%X", size);
   sec_list[i] = size;
   MainForm->tv_memspc->Items->AddChild(last_node, UnicodeString(temp));

   i++;
  }
  CloseHandle(hProc);
 }
}
//---------------------------------------------------------------------------

void __fastcall TMainForm::b_mhashClick(TObject *Sender)
{
 if (MainForm->clb_sec->Items->Count != 0)
 {
  unsigned int i = 0;
  DWORD size = 0;
  DWORD last_sz = 0;

  for (i = 0; i < MainForm->clb_sec->Items->Count; i++)
  {
   if (MainForm->clb_sec->Checked[i] == true)
	{size = size + sec_list[i];}
  }
  if (size == 0)
  {ShowMessage("No memory blocks selected."); return;}

  HANDLE hProc = OpenProcess(PROCESS_VM_READ, false, pid_list[MainForm->lb_proc->ItemIndex]);

  if (!hProc) {ShowMessage("Could not open handle to the process."); return;}

  char* data = new char[size];
  unsigned long int dwRead;

  for (i = 0; i < MainForm->clb_sec->Items->Count; i++)
  {
   if (MainForm->clb_sec->Checked[i] == true)
	{
	 ReadProcessMemory(hProc, (LPCVOID)(mod_list[MainForm->lb_mod->ItemIndex] + sec_ra_list[i]),
					   (void*)(data + last_sz), sec_list[i], &dwRead);
	 last_sz = sec_list[i];
	}
  }
  MainForm->e_mhash->Text = UnicodeString(do_md5(data, size));
  delete[] data;
 }
}
//---------------------------------------------------------------------------
