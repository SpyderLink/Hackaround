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
  unsigned char* binBuffer=new unsigned char[len];
  char* txtBuffer=new unsigned char[len*2+1];
  strcpy(txtBuffer,str.c_str()); txtBuffer[len*2]=0;
  HexToBin(txtBuffer,binBuffer,len);

  int j;
  unsigned short crc=0xFFFF, crcL,crcH;

  while(len--)
  { crc ^= *(binBuffer)++;
    for(j=0; j<8; j++)
    { if(crc & 1)  crc =(USHORT)( (crc>>1) ^ CRC16_POLY );
      else crc =(USHORT)( crc>>1);
  } }

  crcL=crc&0x00FF; crcH=(crc>>8)&0x00FF;
  sprintf(txtBuffer,"%02X",crcL); Edit2->Text=txtBuffer;
  sprintf(txtBuffer,"%02X",crcH); Edit2->Text=Edit2->Text+AnsiString(txtBuffer);

  delete binBuffer;
  delete txtBuffer;
}
//---------------------------------------------------------------------------
