namespace RNInjector.Model

type AccountModel =
    { Name : string
      Role : string
      Password : string
      ExpenseLineItems : seq<Expense> }
