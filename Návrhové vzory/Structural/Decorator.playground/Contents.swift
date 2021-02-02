import Foundation

// MARK: - Decorator

// Dekorátor si uchovává referenci na dekorovaný objekt / objekty -> více je vidět v příkladech

// Decorator Stringu (Protože ho nemůžu podědit, tak si vytvořím decorator)
class CodeBuilder: CustomStringConvertible{
    private var buffer: String = ""
    
    init(){}
    init(buffer: String){
        self.buffer = buffer
    }
    
    // Původní funkcionalita stringu
    func append(_ s: String) -> CodeBuilder{
        // Zavolám funkci stringu
        buffer.append(s)
        return self
    }
    
    // vlastní funkcionalita
    func appendLine(_ s: String) -> CodeBuilder{
        buffer.append("\(s)\n")
        return self
    }
    
    static func +=(cb: inout CodeBuilder, s: String){
        cb.buffer.append(s)
    }
    
    var description: String{
        return buffer
    }
}

var cb = CodeBuilder()
cb.appendLine("class Třída").appendLine("{")
cb += "  // test\n"
cb.appendLine("}")
print(cb)

// Multiple Inheritance usecase - jelikož jazyk neumožňuje multiple dědění, tak můžu zvážit využití decoratoru

protocol ICanFly{
    func fly()
}

protocol ICanCrawl{
    func crawl()
}

class Bird: ICanFly{
    func fly(){}
}

class Lizard: ICanCrawl{
    func crawl(){}
}

// NELZE!
//class Dragon: Bird, Lizard{
//
//}

class Dragon: ICanFly, ICanCrawl{
    private let bird = Bird()
    private let lizard = Lizard()
    
    func fly(){
        bird.fly() // delegation
    }
    
    func crawl(){
        lizard.crawl() // delegation
    }
}

// Skládání dekorátorů

protocol Shape: CustomStringConvertible{
    var description: String {get}
}

class Circle: Shape{
    private var radius: Float = 0
    
    init(_ radius: Float){
        self.radius = radius
    }
    
    func resize(_ factor: Float){
        radius *= factor
    }
    
    var description: String{
        return "Kruh (\(radius))"
    }
}

class Square: Shape{
    private var side: Float = 0
    
    init(_ side: Float){
        self.side = side
    }
    
    var description: String{
        return "Čtverec (\(side))"
    }
}

class ColoredShape: Shape{
    var shape: Shape
    var color: String
    
    init(shape: Shape, color: String){
        self.shape = shape
        self.color = color
    }
    
    var description: String{
        return "\(shape) barva: \(color)"
    }
}

class TransparentShape: Shape{
    var shape: Shape
    var transparency: Float
    
    
    init(shape: Shape, transparency: Float) {
        self.shape = shape
        self.transparency = transparency
    }
    
    var description: String{
        return "\(shape) průhlednost: \(transparency * 100)%"
    }
}

let square = Square(1.23)
print(square)

let redSquare = ColoredShape(shape: square, color: "red")
print(redSquare)

let redHalfTransparentSquare = TransparentShape(shape: redSquare, transparency: 0.5)
print(redHalfTransparentSquare)

