//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "ServerSocketForm.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"

TForm1 *Form1;

BYTE sntp_header[]={0x1B,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
                    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
                    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};

//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button2Click(TObject *Sender)
{
  AnsiString str;
  if(cbUDP->Checked)
  {
    IdUDPServer1->DefaultPort=MaskEdit2->Text.ToInt();
    IdUDPServer1->Active=true;
    str="Запущен сервер UDP";
  }
  else if(RadioGroup3->ItemIndex==0)
  {
    ServerSocket1->Port=MaskEdit2->Text.ToInt();
    ServerSocket1->Open();
    str="Запущен сервер TCP/IP(TServerSocket)";
    if(RadioGroup2->ItemIndex==0) str+=" stNonBlocking";
    else                          str+=" stThreadBlocking";
  }
  else if(RadioGroup3->ItemIndex==1)
  {
    //IdTCPServer1->Bindings->Items[0]->PeerPort=MaskEdit2->Text.ToInt();
    IdTCPServer1->DefaultPort=MaskEdit2->Text.ToInt();
    IdTCPServer1->Active=true;
    str="Запущен сервер TCP/IP(IdTCPServer)";
  }

  Button2->Enabled = false; RadioGroup2->Enabled=false;
  Button3->Enabled = false;  // Делаем недоступную "Соединиться" (так как мы уже сервер)
  Edit3->Enabled=true;
  Button4->Enabled = true;   // Делаем доступную "Отключиться"

  str+=Now().FormatString(" hh:nn:ss");
  Memo1->Lines->Add(str);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button3Click(TObject *Sender)
{
  if(cbICMP->Checked)
  {
    IdIcmpClient1->Host=MaskEdit1->Text;
    IdIcmpClient1->Ping();
  }
  else if(cbUDP->Checked)
  {
    IdUDPClient1->Host=MaskEdit1->Text;
    IdUDPClient1->Port=MaskEdit2->Text.ToInt();
    IdUDPClient1->Active=true;
  }
  else if(RadioGroup3->ItemIndex==0)
  {
    ClientSocket1->Address=MaskEdit1->Text;
    ClientSocket1->Host=MaskEdit1->Text;
    ClientSocket1->Port=MaskEdit2->Text.ToInt();
    ClientSocket1->Open();
  }
  else if(RadioGroup3->ItemIndex==1)
  {
    IdTCPClient1->Host=MaskEdit1->Text;
    IdTCPClient1->Port=MaskEdit2->Text.ToInt();
    IdTCPClient1->Connect();
  }

  Button2->Enabled = false;     // Делаем недоступную "Создать" (так как мы коннектимся)
  RadioGroup2->Enabled=false;
  Button3->Enabled = false;   Edit3->Enabled=false;
  Button4->Enabled = true;      // Делаем доступную "Отключиться"
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button4Click(TObject *Sender)
{
 if(cbUDP->Checked)
 {
    if (IdUDPServer1->Active == true)
    {
      IdUDPServer1->Active=false;
      AnsiString str="Сервер остановлен ";
      str+=Now().FormatString("hh:nn:ss");
      Memo1->Lines->Add(str);
    }
    else
    {
      IdUDPClient1->Active=false;
    }
 }
 else
 {
    if (ServerSocket1->Active == true)
    {
      ServerSocket1->Close();
      AnsiString str="Сервер остановлен ";
      str+=Now().FormatString("hh:nn:ss");
      Memo1->Lines->Add(str);
    }
    else if(ClientSocket1->Active)
    {
      ClientSocket1->Close();
    }

    else if(IdTCPServer1->Active)
    {
      IdTCPServer1->Active=false;
    }
    else if(IdTCPClient1->Connected())
    {
      IdTCPClient1->Disconnect();
    }
 }
  Button2->Enabled = true ; RadioGroup2->Enabled=true;
  Button3->Enabled = true ; Edit3->Enabled=false;
  Button4->Enabled = false;
}
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
void __fastcall TForm1::ClientSocket1Connect(TObject *Sender, TCustomWinSocket *Socket)
{
  AnsiString str="Соединение установлено ";
  str+=Now().FormatString("hh:nn:ss");
  Memo1->Lines->Add(str);
}
void __fastcall TForm1::ClientSocket1Disconnect(TObject *Sender,
      TCustomWinSocket *Socket)
{
  AnsiString str="Соединение закончено ";
  str+=Now().FormatString("hh:nn:ss");
  Memo1->Lines->Add(str);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::IdUDPServer1Status(TObject *axSender, const TIdStatus axStatus, const AnsiString asStatusText)
{
  AnsiString str="Статус UDP-сервера: "; str+=asStatusText;
  str+=" "; str+=Now().FormatString("hh:nn:ss");
  Memo1->Lines->Add(str);

  str=Now().FormatString("hh:nn:ss");
  str+=" ActiveConnections="; str+=IntToStr(IdUDPServer1->Bindings->Count);
  Memo1->Lines->Add(str);

  for(int i=0;i<IdUDPServer1->Bindings->Count;i++)
  {
    str="    -  сокет№"; str+=IntToStr(IdUDPServer1->Bindings->Items[i]->Handle);
    str+=", IP ";  str+=IdUDPServer1->Bindings->Items[i]->PeerIP;
    str+=" порт "; str+=IntToStr(IdUDPServer1->Bindings->Items[i]->PeerPort);
    str+=", connection"; str+=IntToStr(i);
    Memo1->Lines->Add(str);
  }
}
void __fastcall TForm1::IdUDPClient1Status(TObject *axSender, const TIdStatus axStatus, const AnsiString asStatusText)
{
  AnsiString str=asStatusText; str+=Now().FormatString(" hh:nn:ss");
  Memo1->Lines->Add(str);
}
//---------------------------------------------------------------------------


void __fastcall TForm1::ClientSocketOnSocketEvent(TObject *Sender,TCustomWinSocket* Socket, TSocketEvent SocketEvent)
{
  if(SocketEvent==seRead) ServerSocket1ClientRead(Sender,Socket);
  else if(SocketEvent==seDisconnect) ServerSocket1ClientDisconnect(Sender,Socket);
}

//---------------------------------------------------------------------------
void __fastcall TForm1::ServerSocket1ClientConnect(TObject *Sender,
      TCustomWinSocket *Socket)
{
 CheckActiveConnections();
 //Socket->Data=(void*)i;                               //Socket->ASyncStyles.Clear(); Socket->ASyncStyles<<asClose;
 Socket->OnSocketEvent=ClientSocketOnSocketEvent;
 Socket->OnErrorEvent=ClientSocketOnErrorEvent;
 Socket->Data=(void*)ServerSocket1->Socket->ActiveConnections;

  AnsiString str="Присоединился сокет№"; str+=IntToStr(Socket->SocketHandle);
  str+=", IP ";  str+=Socket->RemoteAddress; str+=":"; str+=Socket->RemotePort;
  str+=", connection"; str+=IntToStr(ServerSocket1->Socket->ActiveConnections-1);
  str+=" ";  str+=Now().FormatString("hh:nn:ss");
  str+=",  ActiveConnections="; str+=IntToStr(ServerSocket1->Socket->ActiveConnections);

  bool add=false;
  if(Memo2->Text.Trim().IsEmpty()) add=true;
  else for(int i=0;i<Memo2->Lines->Count;i++)
  { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
  if(add) Memo1->Lines->Add(str);

  add=false;
  if(Memo2->Text.Trim().IsEmpty()) add=true;
  else for(int i=0;i<Memo2->Lines->Count;i++)
  { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
  if(add) Memo1->Lines->Add(str);

  for(int i=0;i<ServerSocket1->Socket->ActiveConnections && !CheckBox4->Checked;i++)
  {
    str="    -  сокет№"; str+=IntToStr(ServerSocket1->Socket->Connections[i]->SocketHandle);
    str+=", IP ";  str+=ServerSocket1->Socket->Connections[i]->RemoteAddress;
    str+=":"; str+=ServerSocket1->Socket->Connections[i]->RemotePort;
    str+=", connection"; str+=IntToStr(i);

    add=false;
    if(Memo2->Text.Trim().IsEmpty()) add=true;
    else for(int i=0;i<Memo2->Lines->Count;i++)
    { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
    if(add) Memo1->Lines->Add(str);
  }
}

//---------------------------------------------------------------------------
void __fastcall TForm1::ServerSocket1ClientDisconnect(TObject *Sender, TCustomWinSocket *Socket)
{
  AnsiString str="Отсоединился сокет№"; str+=IntToStr(Socket->SocketHandle);
  str+=", IP ";  str+=Socket->RemoteAddress;
  str+=":"; str+=Socket->RemotePort;
  str+=" ";  str+=Now().FormatString("hh:nn:ss");

  bool add=false;
  if(Memo2->Text.Trim().IsEmpty()) add=true;
  else for(int i=0;i<Memo2->Lines->Count;i++)
  { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
  if(add) Memo1->Lines->Add(str);

        for(int i=0;i<ServerSocket1->Socket->ActiveConnections && !CheckBox4->Checked;i++)
        {
          str="    -  сокет№"; str+=IntToStr(ServerSocket1->Socket->Connections[i]->SocketHandle);
          str+=", IP ";  str+=ServerSocket1->Socket->Connections[i]->RemoteAddress;
          str+=":"; str+=ServerSocket1->Socket->Connections[i]->RemotePort;
          str+=", connection"; str+=IntToStr(i);

          add=false;
          if(Memo2->Text.Trim().IsEmpty()) add=true;
          else for(int i=0;i<Memo2->Lines->Count;i++)
          { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
          if(add) Memo1->Lines->Add(str);
        }
}

#define SSOCKET_PASS_LOG "GETLOG"
#define SSOCKET_PASS_GETTIM "GETTIM\n\r"  

void __fastcall TForm1::ServerSocket1ClientRead(TObject *Sender, TCustomWinSocket *Socket)
{
 AnsiString str=IntToStr(Socket->SocketHandle);
 str+=" "; str+=Now().FormatString(" nn:ss : ");

 char* binBuffer=new char[1000]; memset(binBuffer,0,1000);         //int RealReadBytes=ServerSocket1->Socket->Connections[0]->ReceiveBuf(binBuffer,1000);
 int   RealReadBytes=Socket->ReceiveBuf(binBuffer,1000);
 char* txtBuffer=new char[RealReadBytes*2+1]; memset(txtBuffer,0,RealReadBytes*2);
 AnsiString s;

  if(!CheckBox3->Checked)
  {  
     for(int i=0;i<RealReadBytes;i++) if(binBuffer[i]==0x00) binBuffer[i]=0x20; // заменить нули пробелами

     s=AnsiString(binBuffer); //Socket->ReceiveText(); // текст
     if(CheckBox5->Checked)
     { OemToChar(s.c_str(),txtBuffer);
       s=txtBuffer;
     }

     if( strcmp(s.c_str(),SSOCKET_PASS_LOG)==0 )  // 4C4F47313233
     {
       s="";
       for(int i=Memo1->Lines->Count-1, j=0; i>=0 && j<100; i--,j++)
           s=Memo1->Lines->Strings[i]+s;
       Socket->SendText(s);
          str+="GETLOG-команда";
        bool add=false;
        if(Memo2->Text.Trim().IsEmpty()) add=true;
        else for(int i=0;i<Memo2->Lines->Count;i++)
        { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
        if(add) Memo1->Lines->Add(str);
       return;
     }
     else if( strcmp(s.c_str(),SSOCKET_PASS_GETTIM)==0 )
     {
       TDateTime dtNow=Now();
       Socket->SendBuf(&(dtNow),8);
          str+="GETTIM-команда";
        bool add=false;
        if(Memo2->Text.Trim().IsEmpty()) add=true;
        else for(int i=0;i<Memo2->Lines->Count;i++)
        { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
        if(add) Memo1->Lines->Add(str);
       return;
     }

     str+=s;

        bool add=false;
        if(Memo2->Text.Trim().IsEmpty()) add=true;
        else for(int i=0;i<Memo2->Lines->Count;i++)
        { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
        if(add) Memo1->Lines->Add(str);

  }
  else
  {
     if( RealReadBytes==6 && strcmp(binBuffer,SSOCKET_PASS_LOG)==0 )  // 4C4F47313233
     {
       s="";
       for(int i=Memo1->Lines->Count-1, j=0; i>=0 && j<100; i--,j++)
           s=Memo1->Lines->Strings[i]+s;
       Socket->SendText(s);
          str+="GETLOG-команда";
        bool add=false;
        if(Memo2->Text.Trim().IsEmpty()) add=true;
        else for(int i=0;i<Memo2->Lines->Count;i++)
        { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
        if(add) Memo1->Lines->Add(str);
       return;
     }
     else if( strcmp(binBuffer,SSOCKET_PASS_GETTIM)==0 )
     {
       TDateTime dtNow=Now();
       Socket->SendBuf(&(dtNow),8);
          str+="GETTIM-команда";
        bool add=false;
        if(Memo2->Text.Trim().IsEmpty()) add=true;
        else for(int i=0;i<Memo2->Lines->Count;i++)
        { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
        if(add) Memo1->Lines->Add(str);
       return;
     }

    BinToHex(binBuffer,txtBuffer,RealReadBytes);
    txtBuffer[RealReadBytes*2]=0;

    str+=txtBuffer;

        bool add=false;
        if(Memo2->Text.Trim().IsEmpty()) add=true;
        else for(int i=0;i<Memo2->Lines->Count;i++)
        { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
        if(add) Memo1->Lines->Add(str);

  }

  delete binBuffer;
  delete txtBuffer;
  if(CheckBox1->Checked) Button1Click(NULL);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ClientSocket1Read(TObject *Sender, TCustomWinSocket *Socket)
{
  char* binBuffer=new char[1000]; memset(binBuffer,0,1000);
  int   RealReadBytes=ClientSocket1->Socket->ReceiveBuf(binBuffer,1000);
  char* txtBuffer=new char[RealReadBytes*2+1]; memset(txtBuffer,0,RealReadBytes*2);
  AnsiString s;

  if(!CheckBox3->Checked)
  {
     for(int i=0;i<RealReadBytes;i++) if(binBuffer[i]==0x00) binBuffer[i]=0x20; // заменить нули пробелами

     s=AnsiString(binBuffer);                // текст
     if(CheckBox5->Checked)
     { OemToChar(s.c_str(),txtBuffer);
       s=txtBuffer;
     }
     Memo1->Lines->Add(s);
  }
  else
  {
    BinToHex(binBuffer,txtBuffer,RealReadBytes);
    txtBuffer[RealReadBytes*2]=0;
    Memo1->Lines->Add(txtBuffer);
  }

  delete binBuffer;
  delete txtBuffer;
}
//---------------------------------------------------------------------------

#define DT1SECOND (1.1574074074074074074074074074074e-5)  // 1  секунда  1./24./60./60.

void __fastcall TForm1::IdUDPServer1UDPRead(TObject *Sender, TStream *AData, TIdSocketHandle *ABinding)
{
 int size=AData->Size;
 BYTE* Buf=new BYTE[size+1];
 memset(Buf,0,size+1);
 AData->ReadBuffer(Buf,size);

 AnsiString str=ABinding->PeerIP; str+=" ";
 str+=IntToStr(ABinding->PeerPort); str+=" :";

  if(!CheckBox3->Checked)
  {
   str+=(char*)Buf; str+=Now().FormatString(" - hh:nn:ss");
   Memo1->Lines->Add(str);
  }    
  else
  {
    char* binBuffer=new char[1000]; memset(binBuffer,0,1000);
    memcpy(binBuffer,Buf,size);
    char* txtBuffer=new char[size*2+1]; memset(txtBuffer,0,size*2);
    BinToHex(binBuffer,txtBuffer,size);
    txtBuffer[size*2]=0;

    str+=txtBuffer; str+=Now().FormatString(" - hh:nn:ss");
    Memo1->Lines->Add(str);

    delete binBuffer;
    delete txtBuffer;
  }

 /*if(size==48 && memcmp(Buf,sntp_header,40)==0)  // sntp, кол-во с 1 января 1900 г. секунд по UTC.
 {

  TDateTime dt;
    dt
 }*/

 delete Buf;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::FormCloseQuery(TObject *Sender, bool &CanClose)
{
  Button4Click(NULL);        
}
//---------------------------------------------------------------------------

void __fastcall TForm1::RadioGroup2Click(TObject *Sender)
{
  if(RadioGroup2->ItemIndex==0) ServerSocket1->ServerType=stNonBlocking;
  else                          ServerSocket1->ServerType=stThreadBlocking;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::FormCreate(TObject *Sender)
{
  RadioGroup2Click(NULL);
}
//---------------------------------------------------------------------------

//int err1=0;
void __fastcall TForm1::ClientSocketOnErrorEvent(TObject *Sender, TCustomWinSocket *Socket, TErrorEvent ErrorEvent, int &ErrorCode)
{
 AnsiString str=IntToStr(Socket->SocketHandle);
 for(int i=ServerSocket1->Socket->ActiveConnections-1; i>=0; i--)
   if(ServerSocket1->Socket->Connections[i]==Socket)
   { str+=",conn."; str+=IntToStr(i); break; }
 str+=Now().FormatString(" nn:ss - ");

   str+=" ошибка - "; str+=IntToStr(ErrorCode);   // 10053 10054

        bool add=false;
        if(Memo2->Text.Trim().IsEmpty()) add=true;
        else for(int i=0;i<Memo2->Lines->Count;i++)
        { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
        if(add) Memo1->Lines->Add(str);

   if(ErrorEvent==eeGeneral) str=" The socket received an error message that does not fit into any of the following categories ";
   else if(ErrorEvent==eeSend) str=" An error occurred when trying to write to the socket connection ";
   else if(ErrorEvent==eeReceive) str=" An error occurred when trying to read from the socket connection ";
   else if(ErrorEvent==eeConnect)
     str=" For client sockets, this indicates that the client socket can’t locate the server, or that a problem on the server prevents the opening of a connection. For server sockets, this indicates that a client connection request that has already been accepted could not be completed ";
   else if(ErrorEvent==eeDisconnect) str=" An error occurred when trying to close a connection ";
   else if(ErrorEvent==eeAccept) str=" For server sockets only, this indicates that a problem occurred when trying to accept a client connection request ";

        add=false;
        if(Memo2->Text.Trim().IsEmpty()) add=true;
        else for(int i=0;i<Memo2->Lines->Count;i++)
        { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
        if(add) Memo1->Lines->Add(str);
                                 //err1++; BYTE buf[]={0xFF,0xFF,0xFF,0xFF,0xFF}; if(err1==1 && ErrorCode==10053)
if(ErrorCode==10053)
{                          //Socket->SendBuf(buf,5);
  ErrorCode=0; // не выводить системное сообщение
  return;
}                          //else err1=0;

   ErrorCode=0; // не выводить системное сообщение

 str="close Socket"; str+=IntToStr(Socket->SocketHandle);
 for(int i=ServerSocket1->Socket->ActiveConnections-1; i>=0; i--)
   if(ServerSocket1->Socket->Connections[i]==Socket)
   { str+=",conn."; str+=IntToStr(i); break; }
 str+=": ";

   Socket->Close();   //delete Socket;
   str+=" ";  
   str+=",  ActiveConnections="; str+=IntToStr(ServerSocket1->Socket->ActiveConnections);

        add=false;
        if(Memo2->Text.Trim().IsEmpty()) add=true;
        else for(int i=0;i<Memo2->Lines->Count;i++)
        { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
        if(add) Memo1->Lines->Add(str);

        for(int i=0;i<ServerSocket1->Socket->ActiveConnections && !CheckBox4->Checked;i++)
        {
          str="    -  сокет№"; str+=IntToStr(ServerSocket1->Socket->Connections[i]->SocketHandle);
          str+=", IP ";  str+=ServerSocket1->Socket->Connections[i]->RemoteAddress;
          str+=":"; str+=ServerSocket1->Socket->Connections[i]->RemotePort;
          str+=", connection"; str+=IntToStr(i);

          add=false;
          if(Memo2->Text.Trim().IsEmpty()) add=true;
          else for(int i=0;i<Memo2->Lines->Count;i++)
          { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
          if(add) Memo1->Lines->Add(str);
        }                                            //ErrorCode=0; // не выводить системное сообщение
}
//---------------------------------------------------------------------------


void __fastcall TForm1::CheckActiveConnections()
{
  AnsiString str;
  for(int i=ServerSocket1->Socket->ActiveConnections-1; i>=0; i--)
   if(!ServerSocket1->Socket->Connections[i]->Connected)
   {
     str="очистка старого connection"; str+=IntToStr(i);
     ServerSocket1->Socket->Connections[i]->Close();     //delete ServerSocket1->Socket->Connections[i];
     //str+=" ";  str+=Now().FormatString("hh:nn:ss");
     //str+=",  ActiveConnections="; str+=IntToStr(ServerSocket1->Socket->ActiveConnections);

        bool add=false;
        if(Memo2->Text.Trim().IsEmpty()) add=true;
        else for(int i=0;i<Memo2->Lines->Count;i++)
        { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
        if(add) Memo1->Lines->Add(str);
   }
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button5Click(TObject *Sender)
{
  Memo1->Lines->Clear();        
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button6Click(TObject *Sender)
{
 if(!ServerSocket1->Active) return;

 int Num=Edit3->Text.ToInt();
 TCustomWinSocket *Socket=NULL;
 if(ServerSocket1->Active==true)
 { for(int i=0;i<ServerSocket1->Socket->ActiveConnections;i++)
    if(ServerSocket1->Socket->Connections[i]->SocketHandle==Num)
    { Socket=ServerSocket1->Socket->Connections[i]; break; }
 }
 else Socket=ClientSocket1->Socket;
 if(!Socket || !Socket->Connected) return;

 Socket->Close();

  AnsiString str=Now().FormatString("hh:nn:ss");
  str+=",  ActiveConnections="; str+=IntToStr(ServerSocket1->Socket->ActiveConnections);

        bool add=false;
        if(Memo2->Text.Trim().IsEmpty()) add=true;
        else for(int i=0;i<Memo2->Lines->Count;i++)
        { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
        if(add) Memo1->Lines->Add(str);

    for( int i=0;i<ServerSocket1->Socket->ActiveConnections && !CheckBox4->Checked;i++)
    {
      str="    -  сокет№"; str+=IntToStr(ServerSocket1->Socket->Connections[i]->SocketHandle);
      str+=", IP ";  str+=ServerSocket1->Socket->Connections[i]->RemoteAddress;
      str+=":"; str+=ServerSocket1->Socket->Connections[i]->RemotePort;
      str+=", connection"; str+=IntToStr(i);

        add=false;
        if(Memo2->Text.Trim().IsEmpty()) add=true;
        else for(int i=0;i<Memo2->Lines->Count;i++)
        { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
        if(add) Memo1->Lines->Add(str);
    }
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button7Click(TObject *Sender)
{
  Memo1->Lines->SaveToFile("Socket.log");
}
//---------------------------------------------------------------------------

void __fastcall TForm1::CheckBox2Click(TObject *Sender)
{
  Timer1->Enabled=false; Timer1->Interval=Edit5->Text.ToInt()*1000;
  Timer1->Enabled=CheckBox2->Checked;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Timer1Timer(TObject *Sender)
{
  Button1Click(NULL);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button1Click(TObject *Sender)
{
 if(cbUDP->Checked)
 { UDP_Button1Click();
   return;
 }

 int Num=Edit3->Text.ToInt();
 TCustomWinSocket *Socket=NULL;
 if(ServerSocket1->Active==true)
 { for(int i=0;i<ServerSocket1->Socket->ActiveConnections;i++)
    if(ServerSocket1->Socket->Connections[i]->SocketHandle==Num)
    { Socket=ServerSocket1->Socket->Connections[i]; break; }
 }
 else Socket=ClientSocket1->Socket;
 if(!Socket || !Socket->Connected){ Edit3->Text="0"; return; }

  AnsiString str;
  if(RadioGroup1->ItemIndex==0)
  {
    str=IntToStr(Socket->SocketHandle); str+="-->> "; str+=Edit1->Text;
    Socket->SendText(Edit1->Text);
    Memo1->Lines->Add(str);
  }
  else
  {
    str=Edit2->Text;
    float fLen=str.Length()/2.; int iLen=(int)fLen; if(fLen>iLen) str="0"+str;

    int NumWriteBytes=(int)str.Length()/2;
    char* binBuffer=new char[NumWriteBytes];
    char* txtBuffer=new char[NumWriteBytes*2+1];

    strcpy(txtBuffer,str.c_str()); txtBuffer[NumWriteBytes*2]=0;
    HexToBin(txtBuffer,binBuffer,NumWriteBytes);

    str=IntToStr(Socket->SocketHandle); str+="-->> "; str+=Edit2->Text;
    Socket->SendBuf(binBuffer,NumWriteBytes);
    Memo1->Lines->Add(str);

    delete binBuffer;
    delete txtBuffer;
  }
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ServerSocket1ClientError(TObject *Sender,
      TCustomWinSocket *Socket, TErrorEvent ErrorEvent, int &ErrorCode)
{
 AnsiString str=IntToStr(Socket->SocketHandle);
 for(int i=ServerSocket1->Socket->ActiveConnections-1; i>=0; i--)
   if(ServerSocket1->Socket->Connections[i]==Socket)
   { str+=",conn."; str+=IntToStr(i); break; }
 str+=": ";

   str+=" ошибка - "; str+=IntToStr(ErrorCode);             // 10053 10054 ...
   str+=Now().FormatString(" - hh:nn:ss");

        bool add=false;
        if(Memo2->Text.Trim().IsEmpty()) add=true;
        else for(int i=0;i<Memo2->Lines->Count;i++)
        { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
        if(add) Memo1->Lines->Add(str);

   /*str="delete Socket"; str+=IntToStr(Socket->SocketHandle);
   Socket->Close();   //delete Socket;
   str+=" ";  str+=Now().FormatString("hh:nn:ss");
   str+=",  ActiveConnections="; str+=IntToStr(ServerSocket1->Socket->ActiveConnections);
        add=false;
        if(Memo2->Text.Trim().IsEmpty()) add=true;
        else for(int i=0;i<Memo2->Lines->Count;i++)
        { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
        if(add) Memo1->Lines->Add(str);

        for(int i=0;i<ServerSocket1->Socket->ActiveConnections && !CheckBox4->Checked;i++)
        {
          str="    -  сокет№"; str+=IntToStr(ServerSocket1->Socket->Connections[i]->SocketHandle);
          str+=", IP ";  str+=ServerSocket1->Socket->Connections[i]->RemoteAddress;
          str+=":"; str+=ServerSocket1->Socket->Connections[i]->RemotePort;
          str+=", connection"; str+=IntToStr(i);

          add=false;
          if(Memo2->Text.Trim().IsEmpty()) add=true;
          else for(int i=0;i<Memo2->Lines->Count;i++)
          { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
          if(add) Memo1->Lines->Add(str);
        }*/

   ErrorCode=0;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button8Click(TObject *Sender)
{
  AnsiString str=Memo1->Text;
  int len=Edit4->Text.Length();
  int i=0, pos=str.AnsiPos(Edit4->Text);
  while(pos>0)
  { i++;
    str=str.SubString(pos+len,str.Length());
    pos=str.AnsiPos(Edit4->Text);
  }
  Memo1->Lines->Add("Количество последовательностей '"+Edit4->Text+"' : "+IntToStr(i));
}
//---------------------------------------------------------------------------

void __fastcall TForm1::UDP_Button1Click()
{
 AnsiString str;
 int i=Edit3->Text.ToInt();
  if(RadioGroup1->ItemIndex==0)
  {
    if(IdUDPServer1->Active == true)
    { if(IdUDPServer1->Bindings->Count<=i) return;
      if(!IdUDPServer1->Bindings->Items[i])
      {
        AnsiString str="delete connection"; str+=IntToStr(i);
        IdUDPServer1->Bindings->Items[i]->CloseSocket(true);         //delete ServerSocket1->Socket->Connections[i];
        str+=" ";  str+=Now().FormatString("hh:nn:ss");
        str+=",  ActiveConnections="; str+=IntToStr(IdUDPServer1->Bindings->Count);

        bool add=false;
        if(Memo2->Text.Trim().IsEmpty()) add=true;
        else for(int i=0;i<Memo2->Lines->Count;i++)
        { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
        if(add) Memo1->Lines->Add(str);

        for(i=0;i<IdUDPServer1->Bindings->Count;i++)
        {
          str="    -  сокет№"; str+=IntToStr(IdUDPServer1->Bindings->Items[i]->Handle);
          str+=", IP ";  str+=IdUDPServer1->Bindings->Items[i]->PeerIP;
          str+=" порт "; str+=IntToStr(IdUDPServer1->Bindings->Items[i]->PeerPort);
          str+=", connection"; str+=IntToStr(i);

          add=false;
          if(Memo2->Text.Trim().IsEmpty()) add=true;
          else for(int i=0;i<Memo2->Lines->Count;i++)
          { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
          if(add) Memo1->Lines->Add(str);
        }
        return;
      }
      str="->"; str+=IntToStr(i); str+=": "; str+=Edit1->Text;
      IdUDPServer1->Bindings->Items[i]->Send(Edit1->Text.c_str(),Edit1->Text.Length(),MSG_OOB);
    }
    else
    {
      str="-> : "; str+=Edit1->Text;
      IdUDPClient1->Send(Edit1->Text);
    }
    Memo1->Lines->Add(str);
  }
  else
  {
    str=Edit2->Text;
    float fLen=str.Length()/2.; int iLen=(int)fLen; if(fLen>iLen) str="0"+str;

    int NumWriteBytes=(int)str.Length()/2;
    char* binBuffer=new char[NumWriteBytes];
    char* txtBuffer=new char[NumWriteBytes*2+1];

    strcpy(txtBuffer,str.c_str()); txtBuffer[NumWriteBytes*2]=0;
    HexToBin(txtBuffer,binBuffer,NumWriteBytes);

    if(IdUDPServer1->Active == true)
    { if(IdUDPServer1->Bindings->Count<=i) return;
      if(!IdUDPServer1->Bindings->Items[i])
      {
        AnsiString str="delete connection"; str+=IntToStr(i);
        IdUDPServer1->Bindings->Items[i]->CloseSocket(true);         //delete ServerSocket1->Socket->Connections[i];
        str+=" ";  str+=Now().FormatString("hh:nn:ss");
        str+=",  ActiveConnections="; str+=IntToStr(IdUDPServer1->Bindings->Count);

        bool add=false;
        if(Memo2->Text.Trim().IsEmpty()) add=true;
        else for(int i=0;i<Memo2->Lines->Count;i++)
        { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
        if(add) Memo1->Lines->Add(str);

        for(i=0;i<IdUDPServer1->Bindings->Count;i++)
        {
          str="    -  сокет№"; str+=IntToStr(IdUDPServer1->Bindings->Items[i]->Handle);
          str+=", IP ";  str+=IdUDPServer1->Bindings->Items[i]->PeerIP;
          str+=" порт "; str+=IntToStr(IdUDPServer1->Bindings->Items[i]->PeerPort);
          str+=", connection"; str+=IntToStr(i);

          add=false;
          if(Memo2->Text.Trim().IsEmpty()) add=true;
          else for(int i=0;i<Memo2->Lines->Count;i++)
          { if(str.AnsiPos(Memo2->Lines->Strings[i].Trim())>0){ add=true; break; } }
          if(add) Memo1->Lines->Add(str);
        }
        return;
      }
      str="->"; str+=IntToStr(i); str+=": "; str+=Edit2->Text;
      IdUDPServer1->Bindings->Items[i]->Send(binBuffer,NumWriteBytes,MSG_OOB);
    }
    else
    {
      str="-> : "; str+=Edit2->Text;
      IdUDPClient1->SendBuffer(binBuffer,NumWriteBytes);
    }
    Memo1->Lines->Add(str);

    delete binBuffer;
    delete txtBuffer;
  }

 //Edit1->Text = "" ; //Edit2->Text = "" ;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::IdSNTP1Status(TObject *axSender, const TIdStatus axStatus, const AnsiString asStatusText)
{
  AnsiString str="Статус SNTP: "; str+=asStatusText;
  str+=" "; str+=Now().FormatString("hh:nn:ss");
  Memo1->Lines->Add(str);
}
//---------------------------------------------------------------------------


void __fastcall TForm1::buttSNTPClick(TObject *Sender)
{
  /*BYTE sntp_query[48];
  memset(sntp_query,0,48);
  sntp_query[0]=0x1B; */

  IdSNTP1->Active = false;
  IdSNTP1->Host=MaskEdit1->Text;
  IdSNTP1->Port=MaskEdit2->Text.ToInt();
  IdSNTP1->Active = true;

  //bool res=
  IdSNTP1->SyncTime();

  AnsiString str="SNTP "; str+=IdSNTP1->DateTime.FormatString("hh:nn:ss");
  str+=", local "; str+=Now().FormatString("hh:nn:ss");
  Memo1->Lines->Add(str);

}
//---------------------------------------------------------------------------

void __fastcall TForm1::IdIcmpClient1Reply(TComponent *ASender, const TReplyStatus &AReplyStatus)
{
  AnsiString str=Now().FormatString("hh:nn:ss");
  str+=" ICMP ответ: ";
  str+=IntToStr(AReplyStatus.BytesReceived); str+="байт от ";
  str+=AReplyStatus.FromIpAddress; str+=", ";
  if(AReplyStatus.BytesReceived==0) str+=" таймаут";
  else{ str+=IntToStr(AReplyStatus.MsRoundTripTime); str+=" мс"; }
  Memo1->Lines->Add(str);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::IdIcmpClient1Status(TObject *axSender,
      const TIdStatus axStatus, const AnsiString asStatusText)
{
  AnsiString str=Now().FormatString("hh:nn:ss");
  str+=" ICMP статус: ";  str+=asStatusText;
  Memo1->Lines->Add(str);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::IdTCPServer1Connect(TIdPeerThread *AThread)
{
  AnsiString str="Присоединился сокет№"; //str+=IntToStr(AThread-> Socket->SocketHandle);
  str+=", IP ";  str+=AThread->Connection->Binding->IP;
  str+=":";      str+=IntToStr(AThread->Connection->Binding->Port);
  str+=" ";  str+=Now().FormatString("hh:nn:ss");
  Memo1->Lines->Add(str);

  AThread->Connection->OnWorkEnd=IdPeerOnWorkEnd1;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::IdTCPServer1Disconnect(TIdPeerThread *AThread)
{
  Memo1->Lines->Add("Отсоединился сокет№");
}
//---------------------------------------------------------------------------

void __fastcall TForm1::IdTCPServer1Execute(TIdPeerThread *AThread)
{
  //AThread->Connection-
  ;   
}
//---------------------------------------------------------------------------

void __fastcall TForm1::IdPeerOnWorkEnd1(TObject *ASender, TWorkMode WMode)
{
 //char binBuffer[1000]; memset(binBuffer,0,1000);
 //int bufsize=AThread->Connection->RecvBufferSize;

 if(WMode==wmRead) //wmWrite
 {
   int i=0;
   i++;
 }

 //AThread->Connection->ReadBuffer(binBuffer,1000);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::IdTCPServer1Status(TObject *axSender,
      const TIdStatus axStatus, const AnsiString asStatusText)
{
  Memo1->Lines->Add(asStatusText);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button9Click(TObject *Sender)
{
    if(!Edit1->Text.IsEmpty())
    {
     int cBytes=Edit1->Text.Length();
     char* binBuffer=new char[cBytes+1]; memset(binBuffer,0,cBytes+1);
     strcpy(binBuffer,Edit1->Text.c_str());
     char* txtBuffer=new char[cBytes*2+1]; memset(txtBuffer,0,cBytes*2+1);
       BinToHex(binBuffer,txtBuffer,cBytes);
       txtBuffer[cBytes*2]=0;
       Edit2->Text=txtBuffer;
     delete binBuffer;
     delete txtBuffer;
    }
}
//---------------------------------------------------------------------------

void __fastcall TForm1::CheckBox3Click(TObject *Sender)
{
  CheckBox5->Visible=!CheckBox3->Checked;        
}
//---------------------------------------------------------------------------

