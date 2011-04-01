module RNInjector.Patchyard

open RNInjector.Model
open System

type PatchRepository() =
    member X.GetAll() =
        seq{ yield {ProcessName="war3.exe" 
                    ModuleName="game.dll" 
                    Offset = new uint32()
                    Bytes = System.Text.Encoding.ASCII.GetBytes("So bytes here") }
           }