import Foundation

// MARK: - Proxy (Zástupce)
// Proxy má stejný interface jako základní objekt
// Pro vytvoření proxy jednoduše replikuju existující interface objektu
// přidám funkcionalitu redefinovaným funkcím
// Proxy návrhů může být více (communication, logging, caching) a chovájí se různě

// MARK: - Motivace
// Když chci řídit přístup k nějakému objektu. Ať už kvůli bezpečnosti, nebo kvůli přidání další funkcionality, zefektivnění, nebo kvůli snadnějšímu ladění apliakce.

// MARK: - Rozdíl proti decorátoru
// Proxy používá identický interface, kdežto dekorátor používá rozšířený interface ("odekorovaný")
// Decorator typicky obsahuje nebo má referenci na to co dekoruje - proxy nemusí
// Proxy nemusí vůbec pracovat s hotovým objektem (lazy loading)

// MARK: - Protection proxy
protocol Vehicle{
    func drive()
}

class Car{
    func drive(){
        print("Auto je řízeno")
    }
}

class CarProxy: Vehicle{
    private let car = Car()
    private let driver: Driver
    
    init(driver: Driver){
        self.driver = driver
    }
    
    func drive(){
        if driver.age > 18{
            car.drive()
        } else {
            print("Řidič je příliš mladý")
        }
    }
}

class Driver{
    var age: Int
    init(age: Int){
        self.age = age
    }
}

let car: Vehicle = CarProxy(driver: Driver(age: 12))
car.drive()

// MARK: - Property proxy

class Property<T: Equatable>{
    private var _value: T
    
    public var value: T{
        get{
            return _value
        }
        set(value){
            if _value == value {return}
            print("Nastavuju hodnotu")
            _value = value
        }
    }
    
    init(_ value: T){
        _value = value
    }
}

extension Property: Equatable{}

func == <T>(lhs: Property<T>, rhs: Property<T>) -> Bool{
    return lhs.value == rhs.value
}

class Creature{
    private let _agility = Property<Int>(0)
    var agility: Int{
        get{return _agility.value}
        set(value){_agility.value = value}
    }
}

let c = Creature()
c.agility = 10
print(c.agility)

