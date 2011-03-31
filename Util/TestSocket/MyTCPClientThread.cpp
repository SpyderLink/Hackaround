//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "MyTCPClientThread.h"
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Important: Methods and properties of objects in VCL can only be
//   used in a method called using Synchronize, for example:
//
//      Synchronize(UpdateCaption);
//
//   where UpdateCaption could look like:
//
//      void __fastcall TMyTCPClientThread::UpdateCaption()
//      {
//        Form1->Caption = "Updated in a thread";
//      }
//---------------------------------------------------------------------------

__fastcall TMyTCPClientThread::TMyTCPClientThread(bool CreateSuspended, TServerClientWinSocket* ASocket)
        : TServerClientThread(CreateSuspended, ASocket)
{
  KeepInCache=false;
  FreeOnTerminate=true;
  Priority=tpNormal;
  //Data=new ..
  //FatalException HandleException
}
//---------------------------------------------------------------------------

                                           //void __fastcall TMyTCPClientThread::Execute(){        //---- Place thread code here ----}//---------------------------------------------------------------------------
void __fastcall TMyTCPClientThread::ClientExecute()

{
  TWinSocketStream *pStream;
  char Buffer[10];
  // make sure connection is active
  while(!Terminated && ClientSocket->Connected)
  {
    try
    {
      Stream = new TWinSocketStream(ClientSocket, 60000);
      try
      {
        memset(Buffer, 0, 10); // initialize the buffer
        // give the client 60 seconds to start writing
        if(pStream->WaitForData(60000))
        {
          if(pStream->Read(Buffer,10)==0) // if can’t read in 60 seconds
             ClientSocket->Close();       // close the connection
          // now process the request
          ...
        }
        else ClientSocket->Close();       // if client doesn’t start, close
      }
      __finally
      {
        delete pStream;
      }
    }
    catch (Exception &E)
    {
      HandleException();
    }
  }
}
