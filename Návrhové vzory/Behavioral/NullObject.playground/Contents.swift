import Foundation

// MARK: - Null Object
// Naimplementuju potřebný interface (protocol), metody nechám prázdné a pokud mají něco vracet, tak vracím defaultní hodnoty (!POKUD SE TYTO HODNOTY POUŽÍVAJÍ, TAK TENTO NÁVRHOVÝ VZOR NEJSPÍŠ NENÍ SPRÁVNÁ VOLBA!)
// Použiju pokud bych potřeboval ne-optional objekt mít optional... viz níže

protocol Log{
    func info(msg: String) -> Bool
    func warn(msg: String)
}

class ConsoleLog: Log{
    func info(msg: String) -> Bool{
        print(msg)
        return true
    }
    func warn(msg: String){
        print("WARNING: \(msg)")
    }
}

class NullLog: Log{
    func info(msg: String) -> Bool {return true}
    func warn(msg: String) {}
}

class BankAccount{
    var log: Log
    var balance = 0
    
    init(log: Log){
        self.log = log
    }
    
    func deposit(amount: Int){
        balance+=amount
        log.info(msg: "uloženo \(amount), zůstatek činí \(balance)")
    }
}

let log = ConsoleLog()
let ba = BankAccount(log: log)
ba.deposit(amount: 100)

print()

let nullLog = NullLog()
let ba2 = BankAccount(log: nullLog)
ba2.deposit(amount: 100)
