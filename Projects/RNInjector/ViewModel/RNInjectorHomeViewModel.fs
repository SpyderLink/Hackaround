namespace RNInjector.ViewModel

open System
open System.Windows
open System.Windows.Data
open System.Windows.Input
open System.ComponentModel
open System.Collections.ObjectModel
open RNInjector.Model
open RNInjector.Repository

type RNInjectorHomeViewModel(accountRepository : AccountRepository)  =  
    inherit ViewModelBase()

    let mutable selectedAccount = 
        {Name=""; Role=""; Password=""; ExpenseLineItems = []}

    let mutable login                   = ""
    let mutable password                = ""
    let mutable convertButtonEnabled    = false
    let mutable loginExpander           = false

    new () = RNInjectorHomeViewModel(new AccountRepository())

    member X.Accounts = 
        new ObservableCollection<AccountModel>(accountRepository.GetAll())

    member X.LoginCommand =
        new RelayCommand((fun canExecute -> true),(fun action ->
                X.SelectedAccount <-
                    match
                        X.Accounts
                        |> Seq.filter (fun acc -> 
                            acc.Name        = login && 
                            acc.Password    = password) with
                        | s when Seq.isEmpty s -> 
                            X.ConvertButtonEnabled <- false
                            ignore <| MessageBox.Show(sprintf 
                                "User %s doesn't exist or password incorrect password" X.Login) 
                            {Name=""; Role=""; Password=""; ExpenseLineItems = []}
                        | s -> 
                            X.ConvertButtonEnabled <- true
                            X.LoginExpander <- false
                            Seq.head s

                X.Login     <- ""
                X.Password  <- "" ))

    member X.Login
        with get()      = login
        and set value   = 
            login <- value
            X.OnPropertyChanged "Login"

    member X.Password
        with get()      = password
        and set value   = 
            password <- value
            X.OnPropertyChanged "Password"

    member X.ConvertButtonEnabled
        with get()      = convertButtonEnabled
        and set v       = 
            convertButtonEnabled <- v
            X.OnPropertyChanged "ConvertButtonEnabled"

    member X.LoginExpander
        with get()      = loginExpander
        and set v       = 
            loginExpander <- v
            X.OnPropertyChanged "LoginExpander"

    member X.SelectedAccount 
        with get () = selectedAccount
        and set value = 
            selectedAccount <- value
            X.OnPropertyChanged "SelectedAccount"