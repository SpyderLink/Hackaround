module RNInjector.Messages

let GetMessage m =
    match m with
    | 3 -> "Can't open process"
    | 4 -> "Can't VirtualProtectEx"
    | 5 -> "Error during WriteProcessMemory !"
    | 6 -> "Can't another VirtualProtectEx ... >_<"
    | _ -> "Not documented error -> Ask Desu"