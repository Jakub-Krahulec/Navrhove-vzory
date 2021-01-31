import Foundation

// MARK: - Prototype
// částečně nebo plně incializovaný objekt který můžu naklonovat a použít
// dalo by se obejít použitím structů, ale pokud je potřeba použít třídy přichází na řadu Prototype

protocol Copying{
    // Copy Constructor
    init(copyFrom other: Self)
    // Explicit Deep Copy Interface
    func clone() -> Self
}

class Address: CustomStringConvertible, Copying{
    var streetAddress: String
    var city: String
    
    init(streetAddress: String, city: String){
        self.city = city
        self.streetAddress = streetAddress
    }
    
    required init(copyFrom other: Address) {
        streetAddress = other.streetAddress
        city = other.city
    }
    
    var description: String{
        return "\(streetAddress), \(city)"
    }
    
    func clone() -> Self{
        return cloneImpl()
    }
    
    private func cloneImpl<T>() -> T{
        return Address(streetAddress: streetAddress, city: city) as! T
    }
}

class Employee: CustomStringConvertible, Copying{
    var name: String
    var address: Address
    
    init(name: String, address: Address){
        self.name = name
        self.address = address
    }
    
    required init(copyFrom other: Employee) {
        name = other.name
        address = Address(copyFrom: other.address)
    }
    
    var description: String{
        return("Jméno: \(name), Adresa: \(address)")
    }
    
    func clone() -> Self{
        cloneImpl()
    }
    
    private func cloneImpl<T>() -> T {
        return Employee(name: name, address: address.clone()) as! T
    }
}

var jakub = Employee(name: "Jakub", address: Address(streetAddress: "Jižní 1969", city: "Hranice"))
//var ondrej = Employee(copyFrom: jakub)
var ondrej = jakub.clone()
ondrej.address = Address(streetAddress: "Jiná adresa", city: "Zlín")
ondrej.name = "Ondřej"
print(jakub)
print(ondrej)
