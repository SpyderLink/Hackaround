module Injector

open RNInvoke
open RNInjector.Patchyard
open RNInjector.Model
open RNCLI

open System
open System.Collections.ObjectModel

let inject(patchRepository : PatchRepository) =
    let Patches = 
        new ObservableCollection<PatchModel>(patchRepository.GetAll())
    let patcher = new RNCLI.Patcher()
    for p in Patches do
        let patched = patcher.Inject(p.ProcessName, p.ModuleName , p.Offset , p.Bytes )
        ()
        //let offset : uint32 = p.Offset
        //let 
        //Native.PatchSomething(
        //p.ProcessName,p.ModuleName,
    ()