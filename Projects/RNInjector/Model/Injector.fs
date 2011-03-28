namespace RNInjector.Model

open Process
open System

module Hack = 
    let Inject() =
        let wc3 = getProcess("War3")

        if (snd wc3) then
            let handler = (fst wc3).Handle
            let baseAdress = getModule("game.dll" , wc3)

            let size = 6

            let testoffset = new IntPtr(baseAdress + 0x74d1ab)
            let buffer = [| byte size |]

            let mutable bytes_read = 0

            buffer.[0] <- Convert.ToByte(0x83)
        else 
            () //here must be a message
        ()