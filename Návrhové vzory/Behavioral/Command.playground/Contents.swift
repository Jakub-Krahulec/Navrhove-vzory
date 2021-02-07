import Foundation

// MARK: - Command
// Zapouzdřím všechny detaily operace v separovaném objektu
// Můžu a nemusím naimplementovat "undo"

class BankAccount: CustomStringConvertible{
    private var balance = 0
    private let overdraftLimit = -500
    
    func deposit(_ amount: Int){
        balance += amount
        print("Uloženo \(amount), zůstatek = \(balance)")
    }
    func widthdraw(_ amount: Int) -> Bool{
        if balance - amount >= overdraftLimit{
            balance -= amount
            print("Výběr \(amount), zůstatek = \(balance)")
            return true
        }
        return false
    }
    
    var description: String{
        return "Balance = \(balance)"
    }
}

protocol Command{
    func call()
    func undo()
}

class BankAccountCommand: Command{
    private var account: BankAccount
    
    enum Action{
        case deposit
        case withdraw
    }
    
    private var action: Action
    private var amount: Int
    private var succeeded = false
    
    init(account: BankAccount, action: Action, amount: Int){
        self.account = account
        self.action = action
        self.amount = amount
    }
    
    func call() {
        switch action {
            case .deposit:
                account.deposit(amount)
                succeeded = true
            case .withdraw:
                succeeded = account.widthdraw(amount)
        }
    }
    
    // Ne úplně nejlepší implementace, ale pro ilustraci
    func undo() {
        if !succeeded {return}
        
        switch action {
            case .deposit:
                account.widthdraw(amount)
            case .withdraw:
                account.deposit(amount)
        }
    }
}

let ba = BankAccount()

let commands = [
    BankAccountCommand(account: ba, action: .deposit, amount: 100),
    BankAccountCommand(account: ba, action: .withdraw, amount: 25)
]

print(ba)
commands.forEach({$0.call()})
print(ba)

commands.reversed().forEach({$0.undo()})
print(ba)
