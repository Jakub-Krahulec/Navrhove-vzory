import Foundation

// MARK: - Flyweight

// Pro optimalizaci místa můžu ukládat data externě pro podobné objekty

class User{
    var fullName: String
    
    init(_ fullName: String){
        self.fullName = fullName
    }
    
    var charCount: Int{
        return fullName.utf8.count
    }
}

class User2{
    static var strings = [String]()
    private var names = [Int]()
    
    init(_ fullName: String){
        
        func getOrAdd(_ s: String) -> Int{
            if let idx = type(of: self).strings.firstIndex(of: s){
                return idx
            } else {
                type(of: self).strings.append(s)
                return type(of: self).strings.count - 1
            }
        }
        names = fullName.components(separatedBy: " ").map{getOrAdd($0)}
    }
    
    static var charCount: Int{
        return strings.map{$0.utf8.count}.reduce(0, +)
    }
}

let user1 = User("Jakub Krahulec")
let user2 = User("Ladislav Krahulec")
let user3 = User("Ladislav Juščák")

let totalChars = user1.charCount + user2.charCount + user3.charCount
print(totalChars)

let user4 = User2("Jakub Krahulec")
let user5 = User2("Ladislav Krahulec")
let user6 = User2("Ladislav Juščák")
print(user2.charCount)


