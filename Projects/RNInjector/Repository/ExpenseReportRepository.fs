module RNInjector.Repository

open RNInjector.Model

type AccountRepository() =
    member x.GetAll() =
        seq{ yield {Name="Admin" 
                    Role="Administrator" 
                    Password = "helloworld"
                    ExpenseLineItems = 
                        [{ExpenseType="Lunch" 
                          ExpenseAmount="50"};
                         {ExpenseType="Transportation" 
                          ExpenseAmount="50"}]}
             yield {Name="zzz"
                    Role="zzz" 
                    Password = "zzz"
                    ExpenseLineItems = 
                        [{ExpenseType="Document printing" 
                          ExpenseAmount="50"};
                         {ExpenseType="Gift" 
                          ExpenseAmount="125"}]}    }
