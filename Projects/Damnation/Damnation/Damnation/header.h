#include "stdafx.h";

#ifndef NTAPI
    typedef  WINAPI NTAPI;
#endif

typedef struct _MY_AWESOME_STRUCTURE {
    USHORT Argument;
    USHORT NextArgument;
    PWSTR  Whatever;
} MY_AWESOME_STRUCTURE;

typedef MY_AWESOME_STRUCTURE PMY_AWESOME_STRUCTURE;

NTSTATUS
(NTAPI *NtAwesomeFunction)
( PMY_AWESOME_STRUCTURE  Something ,PCWSTR NextSomething);