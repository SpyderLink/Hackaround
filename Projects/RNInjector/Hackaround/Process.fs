module Process

open System
open System.Diagnostics
open System.Runtime.InteropServices

let getProcess pc =   
    Process.GetProcesses() |> fun pcs ->
        pcs |> Array.find(fun p -> p.ProcessName = pc)

let getModule m pc =
    getProcess(pc) |> fun pcs -> 
        if pcs <> null then
            [for mx in pcs.Modules ->
                if mx.ModuleName.ToLower() = m then
                    Some(mx)
                else
                    None ]
            |> Seq.choose id 
            |> Seq.head
            |> fun mdls ->
                if mdls <> null then
                    mdls.BaseAddress.ToInt32()
                else 0
        else 0