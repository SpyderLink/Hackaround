//---------------------------------------------------------------------------

#include <vcl.h>
#include <stdio.h>
#pragma hdrstop

#include "Unit1.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;

#define CRC16_POLY      0xA001 //X^16 + X^15 + X^2 + 1

//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------

//----------------- Получение контрольной суммы -----------------------------
void __fastcall TForm1::Button1Click(TObject *Sender)
{
  AnsiString str=Edit1->Text;
  float fLen=str.Length()/2.; int iLen=(int)fLen; if(fLen>iLen) str="0"+str;
  Edit1->Text=str;

  int len=(int)str.Length()/2;
  unsigned char* binBuffer=new unsigned char[len+1];
  char* txtBuffer=new unsigned char[len*2+1];
  strcpy(txtBuffer,str.c_str()); txtBuffer[len*2]=0;
  HexToBin(txtBuffer,binBuffer,len);

  unsigned char crc=0; //binBuffer[0];

  for(int i=0; i<len; i++)
    crc^=binBuffer[i];

  sprintf(txtBuffer,"%02X",crc); Edit2->Text=txtBuffer;

  delete binBuffer;
  delete txtBuffer;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button2Click(TObject *Sender)
{
  char BufferOUT[300];
  int len=Edit3->Text.Length();
  memcpy(BufferOUT, Edit3->Text.c_str(), len);

    BYTE bcc=0;
    for(int i=0; i<(len-1); i++)
       bcc^=BufferOUT[i];

   //Edit4->Text=bcc;
   if(bcc==BufferOUT[len-1])
        Edit4->Text="Ok";
   else Edit4->Text="No";

}
//---------------------------------------------------------------------------

