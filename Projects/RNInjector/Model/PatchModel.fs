namespace RNInjector.Model

type PatchModel =
    { ProcessName   : string
      ModuleName    : string
      Offset        : uint32
      Bytes         : byte array }