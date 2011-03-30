//---------------------------------------------------------------------------

#include <vcl.h>
#include <stdio.h>
#include <math.h>
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

// функция перевода DWORD из формата BCD(двоичнодесятичного) в double
double BufferBCD2Double(BYTE* pBCD, int countByte)
{
 BYTE bVal;
 double dVal, dResult=0.;

 for(int i=countByte-1, j=0; i>=0; i--)
 {                                  // по 2 цифры в каждом из байтов
   bVal = pBCD[i] & 0x0F;           // младшая цифра
   dVal=bVal; dVal=dVal*pow10(j);
   dResult=dResult+dVal;
   j++;
   bVal =(pBCD[i]>>4)&0x0F;         // старшая
   dVal=bVal; dVal=dVal*pow10(j);
   dResult=dResult+dVal;
   j++;
 }

 return dResult;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button7Click(TObject *Sender)
{
  AnsiString str=Edit3->Text;
  float fLen=str.Length()/2.; int iLen=(int)fLen; if(fLen>iLen) str="0"+str;
  Edit3->Text=str;

  unsigned char binBuffer[6];
  char txtBuffer[13];
  strcpy(txtBuffer,str.c_str()); txtBuffer[12]=0;
  HexToBin(txtBuffer,binBuffer,6);

  double dVal=BufferBCD2Double(binBuffer,6);
  Edit4->Text=FloatToStr(dVal);

}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button4Click(TObject *Sender)
{
  AnsiString str=Edit7->Text;
  if(str.Length()<8){ Edit8->Text="Введите 4 байта";  return; }

  unsigned char binBuffer[4];
  char txtBuffer[9];
  strcpy(txtBuffer,str.c_str()); txtBuffer[8]=0;
  HexToBin(txtBuffer,binBuffer,4);

  __int32 iVal;
  memcpy(&iVal,binBuffer,4);
  Edit8->Text=IntToStr(iVal);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button5Click(TObject *Sender)
{
 TDateTime dt=TDateTime(1997,1,1); dt+=TDateTime(0,0,0,0);
 int iVal=Edit8->Text.ToInt();
 double dDT=iVal/24./60./60.;
 dt+=dDT;
 Edit8->Text=dt.FormatString("yyyy.mm.dd hh:nn:ss");
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button6Click(TObject *Sender)
{
 TDateTime dt=TDateTime(1997,1,1); dt+=TDateTime(0,0,0,0);
 TDateTime dt1=Now();
 dt1-=dt;
 double dDT=double(dt1);
 dDT=dDT*24.*60.*60.;
 __int32 iVal=dDT;
  char txtBuffer[9];
  BinToHex((BYTE*)&iVal,txtBuffer,4); txtBuffer[8]=0;
  Edit7->Text=txtBuffer;

}
//---------------------------------------------------------------------------


void __fastcall TForm1::Button3Click(TObject *Sender)
{
  float fVal=StrToFloat(Edit5->Text); //.ToDouble();
  __int32 iVal;
  memcpy(&iVal,&fVal,4);

  char txtBuffer[9];
  BinToHex((BYTE*)&iVal,txtBuffer,4); txtBuffer[8]=0;
  Edit6->Text=txtBuffer;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button8Click(TObject *Sender)
{
  double dVal=Edit5->Text.ToDouble();
  __int64 iVal;
  memcpy(&iVal,&dVal,8);

  char txtBuffer[17];
  BinToHex((BYTE*)&iVal,txtBuffer,8); txtBuffer[16]=0;
  Edit6->Text=txtBuffer;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button2Click(TObject *Sender)
{
  AnsiString str=Edit3->Text;
  if(str.Length()<8){ Edit4->Text="Введите 4 байта";  return; }

  int len=4;
  unsigned char* binBuffer=new unsigned char[len];
  char* txtBuffer=new unsigned char[len*2+1];
  strcpy(txtBuffer,str.c_str()); txtBuffer[len*2]=0;
  HexToBin(txtBuffer,binBuffer,len);

  float fVal;
  memcpy(&fVal,binBuffer,4);
  Edit4->Text=FloatToStr(fVal);

  delete binBuffer;
  delete txtBuffer;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button9Click(TObject *Sender)
{
  AnsiString str=Edit3->Text;
  if(str.Length()<16){ Edit4->Text="Введите 8 байт";  return; }

  int len=8;
  unsigned char* binBuffer=new unsigned char[len];
  char* txtBuffer=new unsigned char[len*2+1];
  strcpy(txtBuffer,str.c_str()); txtBuffer[len*2]=0;
  HexToBin(txtBuffer,binBuffer,len);

  double dVal;
  memcpy(&dVal,binBuffer,len);
  Edit4->Text=FloatToStr(dVal);

  delete binBuffer;
  delete txtBuffer;
}
//---------------------------------------------------------------------------

#include <time.h>

void __fastcall TForm1::Button10Click(TObject *Sender)
{
  AnsiString str=Edit7->Text;
  if(str.Length()<8){ Edit8->Text="Введите 4 байта";  return; }

  unsigned char binBuffer[4];
  char txtBuffer[9];
  strcpy(txtBuffer,str.c_str()); txtBuffer[8]=0;
  HexToBin(txtBuffer,binBuffer,4);

  time_t RecTime;
  struct tm  tmLoc;
  TDateTime dt;

  memcpy(&RecTime,binBuffer,4);
  memcpy(&tmLoc, localtime(&RecTime), sizeof(struct tm) );
  dt=TDateTime(tmLoc.tm_year+1900,tmLoc.tm_mon+1,tmLoc.tm_mday);
  dt+=TDateTime(tmLoc.tm_hour,tmLoc.tm_min,tmLoc.tm_sec,0);

  Edit8->Text=dt.FormatString("yyyy/mm/dd hh:nn:ss");
}
//---------------------------------------------------------------------------

//----------------- Получение контрольной суммы -----------------------------
void __fastcall TForm1::Button1Click(TObject *Sender)
{
  AnsiString str=Edit1->Text;
  float fLen=str.Length()/2.; int iLen=(int)fLen; if(fLen>iLen){ Edit2->Text=" длина нечётная !"; return; } //str="0"+str;  Edit2->Text=str;
  Edit1->Text=str;

  int len=(int)str.Length()/2;
  unsigned char* binBuffer=new unsigned char[len]; unsigned char* pbuff=binBuffer;
  char* txtBuffer=new unsigned char[len*2+1];
  strcpy(txtBuffer,str.c_str()); txtBuffer[len*2]=0;
  HexToBin(txtBuffer,binBuffer,len);

  int j;
  unsigned short crc=0xFFFF, crcL,crcH;

  while(len--)
  { crc ^= *(binBuffer++);
    for(j=0; j<8; j++)
    { if(crc & 1)  crc =(USHORT)( (crc>>1) ^ CRC16_POLY );
      else crc =(USHORT)( crc>>1);
  } }

  crcL=crc&0x00FF; crcH=(crc>>8)&0x00FF;
  sprintf(txtBuffer,"%02X",crcL); Edit2->Text=txtBuffer;
  sprintf(txtBuffer,"%02X",crcH); Edit2->Text=Edit2->Text+AnsiString(txtBuffer);

  delete pbuff;
  delete txtBuffer;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button11Click(TObject *Sender)
{
  AnsiString str=Edit9->Text;
  float fLen=str.Length()/2.; int iLen=(int)fLen; if(fLen>iLen){ Edit10->Text=" длина нечётная !"; return; } //str="0"+str;  Edit9->Text=str;

  int len=(int)str.Length()/2;
  unsigned char* binBuffer=new unsigned char[len]; unsigned char* pbuff=binBuffer;
  char* txtBuffer=new unsigned char[len*2+1];
  strcpy(txtBuffer,str.c_str()); txtBuffer[len*2]=0;
  HexToBin(txtBuffer,binBuffer,len);

  //-----------------------------
  WORD j, crc=0, crcH,crcL;

  while( len-- > 0 )
  {
    crc = crc ^ (int) *binBuffer++ << 8;
    for(j=0; j<8; j++)
    { if(crc & 0x8000)  crc = (crc<<1) ^ 0x1021 ;
      else crc <<= 1;
    }
  }

  crcH=(crc>>8)&0x00FF; crcL=crc&0x00FF;
  sprintf(txtBuffer,"%02X",crcH); Edit10->Text=txtBuffer;
  sprintf(txtBuffer,"%02X",crcL); Edit10->Text=Edit10->Text+AnsiString(txtBuffer);

  delete pbuff;
  delete txtBuffer;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button12Click(TObject *Sender)
{
  AnsiString str=Edit9->Text;
  float fLen=str.Length()/2.; int iLen=(int)fLen; if(fLen>iLen){ Edit10->Text=" длина нечётная !"; return; } //str="0"+str;  Edit9->Text=str;

  int len=(int)str.Length()/2;
  unsigned char* binBuffer1=new unsigned char[len];   unsigned char* pbuff1=binBuffer1;
  unsigned char* binBuffer2=new unsigned char[len*2]; unsigned char* pbuff2=binBuffer2;
  char* txtBuffer=new unsigned char[len*4+1];
  strcpy(txtBuffer,str.c_str()); txtBuffer[len*2]=0;
  HexToBin(txtBuffer,binBuffer1,len);

  int i=0,j=0;
  for(;i<len;i++,j++)
  {
   if(binBuffer1[i]==0x01||binBuffer1[i]==0x02||binBuffer1[i]==0x03||binBuffer1[i]==0x10||binBuffer1[i]==0x1F)
   { binBuffer2[j]=0x10; j++; }
   binBuffer2[j]=binBuffer1[i];
  }

  BinToHex(binBuffer2,txtBuffer,j); txtBuffer[j*2]=0;
  Edit9->Text=AnsiString(txtBuffer);

  delete pbuff1; delete pbuff2;
  delete txtBuffer;
}
//---------------------------------------------------------------------------

