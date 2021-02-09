import Foundation

// MARK: - Memento
// Řeší uložení vnitřního stavu objektu, aniž by byl porušen princip zapouzdření. Je možné si doimplementovat historii - undo / redo (ale v základním vzoru se jedná pouze o ukládání jednoho stavu na který se lze vrátit)

class Memento{
    // !let aby se nedal uložený stav změnit!
    let balance: Int
    init(balance: Int){
        self.balance = balance
    }
}

class BankAccount: CustomStringConvertible{
    private var balance: Int
    private var changes = [Memento]()
    private var current = 0
    
    init(balance: Int){
        self.balance = balance
        changes.append(Memento(balance: self.balance))
    }
    
    func deposit(amount: Int) -> Memento{
        balance += amount
        let memento = Memento(balance: balance)
        changes.append(memento)
        current+=1
        return memento
    }
    
    func restore(memento: Memento?){
        guard let memento = memento else {return}
        balance = memento.balance
        changes.append(memento)
        current = changes.count - 1
    }
    
    func undo() -> Memento?{
        if current > 0{
            current -= 1
            let m = changes[current]
            balance = m.balance
            return m
        }
        return nil
    }
    
    func redo() -> Memento?{
        if (current+1) < changes.count{
            let m = changes[current+1]
            balance = m.balance
            return m
        }
        return nil
    }
    
    var description: String{
        return "Balance = \(balance)"
    }
}

let ba = BankAccount(balance: 100)
let m1 = ba.deposit(amount: 50) //150
let m2 = ba.deposit(amount: 25) // 175
print(ba)

//ba.restore(memento: m1)
//print(ba)
//
//ba.restore(memento: m2)
//print(ba)

ba.undo()
print("Undo: \(ba)")
ba.undo()
print("Undo2: \(ba)")
ba.redo()
print("Redo \(ba)")
