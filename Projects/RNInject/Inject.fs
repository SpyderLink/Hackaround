module Injector

open RNInvoke
open RNInjector.Patchyard
open RNInjector.Model

open System
open System.Collections.ObjectModel

let inject(patchRepository : PatchRepository) =
    let Patches = 
        new ObservableCollection<PatchModel>(patchRepository.GetAll())
    for p in Patches do
        ()
        //let offset : uint32 = p.Offset
        //let 
        //Native.PatchSomething(
        //p.ProcessName,p.ModuleName,
    ()