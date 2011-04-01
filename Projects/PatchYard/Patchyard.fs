module RNInjector.Patchyard
open RNInjector.Model

type PatchRepository() =
    member X.GetAll() =
        seq{ yield {ProcessName="war3.exe" 
                    ModuleName="game.dll" 
                    Offset = "0xmgreiojgre"
                    Bytes = "grekriomnNFEU" }
             yield {ProcessName="war3.exe" 
                    ModuleName="game.dll" 
                    Offset = "0xmgreiojgre"
                    Bytes = "grekriomnNFEU" }
           }