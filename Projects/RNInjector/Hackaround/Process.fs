module Process

open System
open System.Diagnostics
open System.Runtime.InteropServices

let getProcess pc =   
    Process.GetProcesses() |> fun pcs ->
        pcs |> Array.find(fun p -> p.ProcessName = pc)