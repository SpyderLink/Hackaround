module RNInvoke

open System
open System.Runtime.InteropServices
open Microsoft.FSharp.NativeInterop
open Microsoft.FSharp.Math

// System.Text.Encoding.ASCII.GetString  // bytes to string

module Native =
    [<System.Runtime.InteropServices.DllImport(@"DesuDLL.dll",EntryPoint="add", CharSet=CharSet.Ansi)>]
    //extern int PatchSomething(string, string, uint32, uint8, uint16);
    extern int PatchSomething(char*, char*, uint32, uint8*, uint16);