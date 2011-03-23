//---------------------------------------------------------------------------

#include <vcl.h>
#include <stdlib.h>
#pragma hdrstop

#include "main.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::g_encClick(TObject *Sender)
{
 t_dec->Text = "";
 char out[3];
 unsigned int temp;

 for (unsigned long int i = 0; i < t_enc->Text.Length(); i++)
 {
  temp = (unsigned int)t_enc->Text.t_str()[i];
  if ((cb_cchar->Checked == true) && (temp == 0x5C))
  {
   i++;
   temp = (unsigned int)t_enc->Text.t_str()[i];
   switch (temp)
   {
	case 'a': {temp = 0x07;} break;
	case 'b': {temp = 0x08;} break;
	case 't': {temp = 0x09;} break;
	case 'f': {temp = 0x0C;} break;
	case 'n': {temp = 0x0A;} break;
	case 'r': {temp = 0x0D;} break;
	default: {ShowMessage("Illegal C-style special character detected."); return;} break;
   }
  }
  itoa(temp, out, 10);
  t_dec->Text = t_dec->Text + UnicodeString(out) + ",";
 }

 t_dec->Text = t_dec->Text + "0";
}
//---------------------------------------------------------------------------
void __fastcall TForm1::g_decClick(TObject *Sender)
{
 t_enc->Text = "";
 unsigned int temp;
 unsigned long int i = 0;

 temp = (unsigned int)(t_dec->Text.t_str()[i] - '0');

 for (i = 1; i < t_dec->Text.Length(); i++)
 {
  if (t_dec->Text.t_str()[i] == ',')
   {t_enc->Text = t_enc->Text + (char)temp; temp = 0;}
  else
   {
	temp = temp*10 + (unsigned int)(t_dec->Text.t_str()[i] - '0');
   }
 }
}
//---------------------------------------------------------------------------

