module RNCompiler

open System
open System.IO
open System.CodeDom.Compiler
open Microsoft.FSharp.Compiler.CodeDom

let private CompileFSharpString(str, assemblies, output) =
        use pro = new FSharpCodeProvider()
        let opt = CompilerParameters(assemblies, output)
        let res = pro.CompileAssemblyFromSource( opt, [|str|] )
        if res.Errors.Count = 0 then 
             Some(FileInfo(res.PathToAssembly)) 
        else None

let (++) v1 v2   = Path.Combine(v1, v2)    
let defaultAsms  = [|"System.dll"; "FSharp.Core.dll"; "FSharp.Powerpack.dll"|] 
let randomFile() = __SOURCE_DIRECTORY__ ++ Path.GetRandomFileName() + ".dll"   

type private System.CodeDom.Compiler.CodeCompiler with 
    static member CompileFSharpString (str, ?assemblies, ?output) =
        let assemblies  = defaultArg assemblies defaultAsms
        let output      = defaultArg output (randomFile())
        CompileFSharpString(str, assemblies, output)     

// Our set of library functions.
let library = "
module Temp.Main
let f(x,y) = sin x + cos y
"
// Create the assembly
let private fileinfo = CodeCompiler.CompileFSharpString(library)

// Purely reflective invocation of the function.
let asm = Reflection.Assembly.LoadFrom(fileinfo.Value.FullName)
let mth  = asm.GetType("Temp.Main").GetMethod("f")

// Wrap weakly typed function with strong typing.
let f(x,y) = mth.Invoke(null, [|box (x:float); box (y:float)|]) :?> float

let b = f (0.5 * Math.PI, 0.0) 
