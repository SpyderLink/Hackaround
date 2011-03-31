//---------------------------------------------------------------------------

#ifndef ServerSocketFormH
#define ServerSocketFormH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ComCtrls.hpp>
#include <ExtCtrls.hpp>
#include <ScktComp.hpp>
#include <Sockets.hpp>
#include <IdBaseComponent.hpp>
#include <IdComponent.hpp>
#include <IdUDPBase.hpp>
#include <IdUDPClient.hpp>
#include <IdUDPServer.hpp>
#include <IdSNTP.hpp>
#include <IdIcmpClient.hpp>
#include <IdRawBase.hpp>
#include <IdRawClient.hpp>
#include <IdTCPClient.hpp>
#include <IdTCPConnection.hpp>
#include <IdTCPServer.hpp>
#include <ADODB.hpp>
#include <DB.hpp>
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
        TMemo *Memo1;
        TPanel *Panel1;
        TTimer *Timer1;
        TLabel *Label3;
        TEdit *Edit1;
        TEdit *Edit2;
        TRadioGroup *RadioGroup1;
        TCheckBox *CheckBox1;
        TButton *Button1;
        TEdit *Edit3;
        TButton *Button6;
        TCheckBox *CheckBox2;
        TEdit *Edit4;
        TButton *Button8;
        TEdit *Edit5;
        TPanel *Panel2;
        TLabel *Label1;
        TLabel *Label2;
        TLabel *Label4;
        TButton *Button3;
        TEdit *MaskEdit1;
        TEdit *MaskEdit2;
        TButton *Button2;
        TButton *Button7;
        TRadioGroup *RadioGroup2;
        TButton *Button4;
        TButton *Button5;
        TCheckBox *cbUDP;
        TButton *buttSNTP;
        TCheckBox *cbICMP;
        TRadioGroup *RadioGroup3;
        TClientSocket *ClientSocket1;
        TServerSocket *ServerSocket1;
        TIdUDPServer *IdUDPServer1;
        TIdUDPClient *IdUDPClient1;
        TIdSNTP *IdSNTP1;
        TIdIcmpClient *IdIcmpClient1;
        TIdTCPServer *IdTCPServer1;
        TIdTCPClient *IdTCPClient1;
        TADOStoredProc *ADOStoredProc1;
        TCheckBox *CheckBox3;
        TButton *Button9;
        TMemo *Memo2;
        TCheckBox *CheckBox4;
        TCheckBox *CheckBox5;
        void __fastcall Button2Click(TObject *Sender);
        void __fastcall Button3Click(TObject *Sender);
        void __fastcall RadioGroup2Click(TObject *Sender);
        void __fastcall Button4Click(TObject *Sender);
        void __fastcall Button7Click(TObject *Sender);
        void __fastcall Button1Click(TObject *Sender);
        void __fastcall Button6Click(TObject *Sender);
        void __fastcall ClientSocket1Connect(TObject *Sender,
          TCustomWinSocket *Socket);
        void __fastcall ClientSocket1Disconnect(TObject *Sender,
          TCustomWinSocket *Socket);
        void __fastcall ClientSocket1Read(TObject *Sender,
          TCustomWinSocket *Socket);
        void __fastcall ServerSocket1ClientConnect(TObject *Sender,
          TCustomWinSocket *Socket);
        void __fastcall ServerSocket1ClientDisconnect(TObject *Sender,
          TCustomWinSocket *Socket);
        void __fastcall ServerSocket1ClientRead(TObject *Sender,
          TCustomWinSocket *Socket);
        void __fastcall FormCreate(TObject *Sender);
        void __fastcall FormCloseQuery(TObject *Sender, bool &CanClose);
        void __fastcall Button5Click(TObject *Sender);
        void __fastcall Timer1Timer(TObject *Sender);
        void __fastcall CheckBox2Click(TObject *Sender);
        void __fastcall Button8Click(TObject *Sender);
        void __fastcall ServerSocket1ClientError(TObject *Sender,
          TCustomWinSocket *Socket, TErrorEvent ErrorEvent,
          int &ErrorCode);
        void __fastcall IdUDPServer1UDPRead(TObject *Sender,
          TStream *AData, TIdSocketHandle *ABinding);
        void __fastcall IdUDPServer1Status(TObject *axSender,
          const TIdStatus axStatus, const AnsiString asStatusText);
        void __fastcall IdUDPClient1Status(TObject *axSender,
          const TIdStatus axStatus, const AnsiString asStatusText);
        void __fastcall IdSNTP1Status(TObject *axSender,
          const TIdStatus axStatus, const AnsiString asStatusText);
        void __fastcall buttSNTPClick(TObject *Sender);
        void __fastcall IdIcmpClient1Reply(TComponent *ASender,
          const TReplyStatus &AReplyStatus);
        void __fastcall IdTCPServer1Connect(TIdPeerThread *AThread);
        void __fastcall IdTCPServer1Disconnect(TIdPeerThread *AThread);
        void __fastcall IdIcmpClient1Status(TObject *axSender,
          const TIdStatus axStatus, const AnsiString asStatusText);
        void __fastcall IdTCPServer1Execute(TIdPeerThread *AThread);
        void __fastcall IdTCPServer1Status(TObject *axSender,
          const TIdStatus axStatus, const AnsiString asStatusText);
        void __fastcall Button9Click(TObject *Sender);
        void __fastcall CheckBox3Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TForm1(TComponent* Owner);
   void __fastcall ClientSocketOnSocketEvent(TObject *Sender,TCustomWinSocket* Socket,TSocketEvent SocketEvent);
   void __fastcall ClientSocketOnErrorEvent(TObject *Sender,TCustomWinSocket *Socket,TErrorEvent ErrorEvent,int &ErrorCode);
   void __fastcall CheckActiveConnections();

   void __fastcall UDP_Button1Click();

   void __fastcall IdPeerOnWorkEnd1(TObject *ASender, TWorkMode WMode);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
