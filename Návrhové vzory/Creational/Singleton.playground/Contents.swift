import Foundation

// MARK: - Singleton
// Pro objekty kde dává smysl mít jen jednu instanci - komunikace s DB, Object Factory (kde neudržuju stav)
// Pro objekty u kterých je inicializace náročná na zdroje
// Pokud nechci aby vznikali kopie
// Jednoduše řečeno se jedná o objekt, který se inicializuje pouze jednou
// Jsou obtížné testovat


class SingletonDatabase{
    var data: Data?
    static let instance = SingletonDatabase()
    private init(){}
}


// MARK: - Monostate


class CEO: CustomStringConvertible{
    private static var _name = ""
    private static var _age = 0
    
    var name: String{
        get { return type(of: self)._name}
        set(value) {type(of: self)._name = value}
    }
    
    var age: Int{
        get { return type(of: self)._age}
        set(value) {type(of: self)._age = value}
    }
    
    var description: String{
        return "\(name), \(age)"
    }
}

var ceo = CEO()
ceo.name = "Jakub"
ceo.age = 24
var ceo2 = CEO()
ceo2.name = "Ondřej"
ceo2.age = 26
print(ceo)
