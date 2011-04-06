module Injector

open RNInvoke
open RNInjector.Patchyard
open RNInjector.Model
open RNInjector.Messages
open RNCLI

open System
open System.Collections.ObjectModel

let inject(patchRepository : PatchRepository) =
    new ObservableCollection<PatchModel>(patchRepository.GetAll()) |> fun patches ->
        new RNCLI.Patcher() |> fun patcher ->
            let rec patch pi =
                if pi < patches.Count then
                    patches.[pi] |> fun p ->
                        patcher.Inject(
                            p.ProcessName, 
                            p.ModuleName , 
                            p.Offset , 
                            p.Bytes ) |> fun patched ->
                            match patched with
                            | 0 -> patch <| pi + 1
                            | some -> GetMessage patched
                else null   // Fin

            patch 0 |> fun patched ->
                match patched with
                | null -> "Patch done"
                | some -> some