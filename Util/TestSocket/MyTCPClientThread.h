//---------------------------------------------------------------------------
#ifndef MyTCPClientThreadH
#define MyTCPClientThreadH

//---------------------------------------------------------------------------
#include <Classes.hpp>
//---------------------------------------------------------------------------


class TMyTCPClientThread : public TServerClientThread
{            
private:
protected:
        void __fastcall ClientExecute();
public:
        __fastcall TMyTCPClientThread(bool CreateSuspended, TServerClientWinSocket* ASocket);
};





//---------------------------------------------------------------------------
#endif
