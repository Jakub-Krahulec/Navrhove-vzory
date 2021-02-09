import Foundation

// MARK: - Interpreter

// Komponenta která procesuje strukturovaná textová data. Přetvoří je na tokeny (lexing) a pak interpretuje (parsing)
// Definuje jakým způsobem implementovat interpretaci nějakého jazyka pomocí OOP
// Může se jednat o interpretaci vlastního programovacího jazyka nebo např. o vyhodnocení matematického výrazu

extension String{
    subscript (i: Int) -> Character{
        return self[index(startIndex, offsetBy: i)]
    }
    
    var isNumber: Bool{
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
}

struct Token: CustomStringConvertible{
    enum TokenType{
        case integer
        case plus
        case minus
        case lparen
        case rparen
    }
    
    var tokenType: TokenType
    var text: String
    
    init(tokenType: TokenType, text: String){
        self.tokenType = tokenType
        self.text = text
    }
    
    var description: String{
        return "'\(text)'"
    }
}

protocol Element{
    var value: Int {get}
}

class Integer: Element{
    var value: Int
    
    init(_ value: Int){
        self.value = value
    }
}

class BinaryOperation: Element{
    
    enum OpType{
        case addition
        case substraction
    }
    
    var opType: OpType = OpType.addition
    var left: Element = Integer(0)
    var right: Element  = Integer(0)
    
    init(){}
    init(left: Element, right: Element, opType: OpType){
        self.left = left
        self.right = right
        self.opType = opType
    }
    
    var value: Int {
        switch opType {
            case .addition: return left.value + right.value
            case .substraction: return left.value - right.value
        }
    }
    
}

func lex(_ input: String) -> [Token]{
    var result = [Token]()
    
    var i = 0
    while i < input.count {
        switch input[i] {
            case "+":
                result.append(Token(tokenType: .plus, text: "+"))
            case "-":
                result.append(Token(tokenType: .minus, text: "-"))
            case "(":
                result.append(Token(tokenType: .lparen, text: "("))
            case ")":
                result.append(Token(tokenType: .rparen, text: ")"))
            default:
                var s = String(input[i])
                for j in (i+1)..<input.count{
                    if String(input[j]).isNumber{
                        s.append(input[j])
                        i += 1
                    }
                    else{
                        result.append(Token(tokenType: .integer, text: s))
                        break;
                    }
                }
        }
        i+=1
    }
    return result
}

func parse(tokens: [Token]) -> Element{
    let result = BinaryOperation()
    var haveLHS = false
    
    var i = 0
    while i < tokens.count{
        let token = tokens[i]
        switch token.tokenType {
            case .integer:
                let interger = Integer(Int(token.text)!)
                if !haveLHS{
                    result.left = interger
                    haveLHS = true
                } else{
                    result.right = interger
                }
            case .plus:
                result.opType = .addition
            case .minus:
                result.opType = .substraction
            case .lparen:
                var j = i
                while j < tokens.count{
                    if tokens[j].tokenType == Token.TokenType.rparen{
                        break
                    }
                    j+=1
                }
                let subexpression = tokens[(i+1)..<j]
                let element = parse(tokens: Array(subexpression))
                if !haveLHS{
                    result.left = element
                    haveLHS = true
                } else {
                    result.right = element
                }
                i = j
                
            default: break
        }
        i+=1
    }
    return result
}



let input = "(13+4)-(12-1)"
let tokens = lex(input)
print(tokens)

let parsed = parse(tokens: tokens)
print("\(input) = \(parsed.value)")

