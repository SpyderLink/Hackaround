module RNInjector.Repository

open RNInjector.Model

type AccountRepository() =
    member X.GetAll() =
        seq{ yield {Name="nc" 
                    Role="coder" 
                    Password = "123"
                    ExpenseLineItems = 
                        [{ExpenseType="Lunch" 
                          ExpenseAmount="50"};
                         {ExpenseType="Transportation" 
                          ExpenseAmount="50"}]}
             yield {Name="desu"
                    Role="coder" 
                    Password = "321"
                    ExpenseLineItems = 
                        [{ExpenseType="Tralala" 
                          ExpenseAmount="50"};
                         {ExpenseType="Gift" 
                          ExpenseAmount="125"}]}    }
