import Foundation

// MARK: - Visitor
// Naimplementuju accept metodu v celé hiearchii
// Pro každý element v hiearchii vytvořím visit metodu
// Každý accept předává self - tím se pohlídá typ

protocol Expression{
    func print(buffer: inout String)
    func accept(visitor: ExpressionVisitor)
}

protocol ExpressionVisitor{
    func visit(_ de: DoubleExpression)
    func visit(_ ae: AdditionExpression)
}

class DoubleExpression: Expression{
    var value: Double
    
    init(value: Double){
        self.value = value
    }
    
    func print(buffer: inout String) {
        buffer.append(String(value))
    }
    
    func accept(visitor: ExpressionVisitor) {
        visitor.visit(self)
    }
}

class AdditionExpression: Expression{
    var left, right: Expression
    init(left: Expression, right: Expression){
        self.left = left
        self.right = right
    }
    
    func print(buffer: inout String) {
        buffer.append("(")
        left.print(buffer: &buffer)
        buffer.append(" + ")
        right.print(buffer: &buffer)
        buffer.append(")")
    }
    
    func accept(visitor: ExpressionVisitor) {
        visitor.visit(self)
    }
}

class ExpressionCalculator: ExpressionVisitor{
    
    var result = 0.0
    
    func visit(_ de: DoubleExpression) {
        result = de.value
    }
    
    func visit(_ ae: AdditionExpression) {
        ae.left.accept(visitor: self)
        let a = result
        ae.right.accept(visitor: self)
        let b = result
        result = a+b
    }
}

class ExpressionPrinter: ExpressionVisitor, CustomStringConvertible{
    private var buffer2 = ""
    // !!!Špatně!!!
//    func print(_ e: DoubleExpression, buffer: inout String){
//        buffer.append(String(e.value))
//    }
//
//    func print(_ e: AdditionExpression, buffer: inout String){
//        buffer.append("(")
//        print(e.left, buffer: &buffer)
//    }
    
    // Funkční řešení
    func print(_ e: Expression, buffer: inout String){
        if let de = e as? DoubleExpression{
            s.append(String(de.value))
        } else if let ae = e as? AdditionExpression{
            buffer.append("(")
            print(ae.left, buffer: &buffer)
            buffer.append(" + ")
            print(ae.right, buffer: &buffer)
            buffer.append(")")
        }
    }
    
    // Visitor řešení (Double dispatch)
    
    func visit(_ de: DoubleExpression) {
        buffer2.append(String(de.value))
    }
    
    func visit(_ ae: AdditionExpression) {
        buffer2.append("(")
        ae.left.accept(visitor: self)
        buffer2.append(" + ")
        ae.right.accept(visitor: self)
        buffer2.append(")")
    }
    
    var description: String{
        return buffer2
    }
    
    
}

// 1 + (2 + 3)
let e = AdditionExpression(left: DoubleExpression(value: 1),
                           right: AdditionExpression(left: DoubleExpression(value: 2),
                                                     right: DoubleExpression(value: 3)))
var s = ""
e.print(buffer: &s)
print(s)

let ep = ExpressionPrinter()
ep.visit(e)
print(ep)

let calc = ExpressionCalculator()
calc.visit(e)
print("\(ep): \(calc.result)")

// MARK: - Dispatch

//protocol Stuff{
//
//}
//
//class Foo: Stuff{}
//class Bar: Stuff{}
//
//func f(_ foo: Foo){}
//func f(_ bar: Bar){}
//
//let x: Stuff = Foo()
//f(x)
