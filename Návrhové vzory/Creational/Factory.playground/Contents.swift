import Foundation

// MARK: - FACTORIES

// MARK: - Factory Method
// Hlavní výhodou je možnost lépe pojmenovat "konstruktor"
// V jiných jazycích je často problém, že není možné mít dva stejné konstruktory se stejnými vstupy (i když jsou jinak pojmenovány)

class Point{
    var x: Double
    var y: Double
    
    private init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    private init(rho: Double, theta: Double) {
        x = rho * cos(theta)
        y = rho * sin(theta)
    }
    
    static func createCartesian(x: Double, y: Double) -> Point{
        return Point(x: x, y: y)
    }
    
    static func createPolar(rho: Double, theta: Double) -> Point{
        return Point(rho: rho, theta: theta)
    }
}

// MARK: - Factory
// Oproti Factory method je nevýhoda, že nemůžu mít privatní konstruktory, výhoda je stejná - přesnější pojmenování "konstruktorů"

class Point2{
    var x: Double
    var y: Double
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    init(rho: Double, theta: Double) {
        x = rho * cos(theta)
        y = rho * sin(theta)
    }
}

class PointFactory{
    // metoda může být statická, nebo ne - je to jedno - není potřeba držet žádný stav
    func createCartesian(x: Double, y: Double) -> Point2{
        return Point2(x: x, y: y)
    }
    
    func createPolar(rho: Double, theta: Double) -> Point2{
        return Point2(rho: rho, theta: theta)
    }
}


// MARK: - Inner Factory
// Implementace je docela matoucí, ale umožňuje lepší způsob zapouzdření než obyčejné Factory

class Point3{
    var x: Double
    var y: Double
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    init(rho: Double, theta: Double) {
        x = rho * cos(theta)
        y = rho * sin(theta)
    }
    
//    class PointFactory{
//        // metoda může být statická, nebo ne - je to jedno - není potřeba držet žádný stav
//        func createCartesian(x: Double, y: Double) -> Point2{
//            return Point2(x: x, y: y)
//        }
//
//        func createPolar(rho: Double, theta: Double) -> Point2{
//            return Point2(rho: rho, theta: theta)
//        }
//    }
    
    // Kdybych nechtěl mít metody statické a potřeboval si držet nějaký stav, tak je možné vyřešit singletonem
    static let factory = PointFactory.instance
    class PointFactory{
        private init(){}
        static let instance = PointFactory()
        func createCartesian(x: Double, y: Double) -> Point2{
            return Point2(x: x, y: y)
        }
        
        func createPolar(rho: Double, theta: Double) -> Point2{
            return Point2(rho: rho, theta: theta)
        }
    }
}
