import Foundation

enum Title{
    case mgr
    case ing
    case bc
    case csc
    case dis
    
    var isBeforeName: Bool {
        switch self{
            case .mgr, .ing, .bc:
                return true
            case .csc, .dis:
                return false
        }
    }
    
    var fullName: String {
        switch self {
            case .mgr:
                return "Magistr"
            case .ing:
                return "Inženýr"
            case .bc:
                return "Bakalář"
            case .csc:
                return "Kandidát věd"
            case .dis:
                return "Diplomovaný specialista"
        }
    }
    
    var shortcut: String {
        switch self{
            case .mgr, .ing, .bc:
                return String(describing: self).capitalizeFirstLetter()
            case .csc:
                return "CSc"
            case .dis:
                return "DiS"
        }
    }
}

extension String {
    func capitalizeFirstLetter() -> String{
        return self.prefix(1).uppercased() + self.dropFirst()
    }
}

extension Hashable where Self: BaseObject {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension Equatable where Self: BaseObject {
    static func == (lhs:Self, rhs:Self) -> Bool {
        return lhs.id == rhs.id
    }
}

protocol BaseObject{
    var id: Int {get}
}

extension Array where Element: BaseObject{
    
    func getObjectById(_ id: Int) -> Element?{
        let object = self.first(where: {$0.id == id})
        if let object = object {
            return object
        }
        print("Did not find ")
        return nil
    }
}

protocol PersonInfo{
    var firstName: String {get}
    var lastName: String {get}
    var birthDate: Date {get}
}

extension PersonInfo{
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    func getBirthYear() -> Int {
        let year = Calendar.current.dateComponents([.year], from: birthDate)
        if let year = year.year{
            return year
        }
        return 0
    }
}

class Student: PersonInfo, BaseObject {
    let id: Int
    let firstName: String
    let lastName: String
    let birthDate: Date
    var fullName: String {
        return "\(lastName) \(firstName)"
    }
    
    init(id: Int, firstName: String, lastName: String, birthDate: Date){
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.birthDate = birthDate
    }
    
    func getBirthYear() -> Int {
        return 20
    }
}

class SecondStudent: Student{
    override init(id: Int, firstName: String, lastName: String, birthDate: Date) {
        super.init(id: id, firstName: firstName, lastName: lastName, birthDate: birthDate)
    }
}

struct Teacher: PersonInfo, BaseObject {
    let id: Int
    let firstName: String
    let lastName: String
    let birthDate: Date
    var title: Title
    var fullName: String {
        return title.isBeforeName ? "\(title.shortcut) \(firstName) \(lastName)" : "\(firstName) \(lastName), \(title)"
    }
}
// MARK: - Poznámky comupted property
// Pokud Struct, Class dědí protocol s default počítanou property, tak u obou funguje stejně
// Pokud Struct, Class dědí protocol s default počítanou property, tak u obou funguje stejně i po přepsání (použije se přepsaná)
// Class dědí i přepsání počítáné property od super class (použije se přepsaná)
// Pokud Super Class nepřepíše počítanou property protocolu, tak child podědí defaultní implementaci (použije se default)
// MARK: - Poznámky default metody
// Pokud Struct, Class dědí protocol s default implementovanou metodou a přepíše ji tak se použije přepsaná
// Class dědí přepsanou metodu ze super class

let student2 = SecondStudent(id: 3, firstName: "Anastázie", lastName: "Juščáková", birthDate: Date())
let student = Student(id: 1, firstName: "Jakub", lastName: "Krahulec", birthDate: Date())
let prof = Teacher(id: 2, firstName: "Ondřej", lastName: "Herman", birthDate: Date(), title: .ing)
//print(student.fullName)
//print(prof.fullName)
print(student2.fullName)
print(student2.getBirthYear())



// MARK: - Test Array Metody
//var studentArray = [Student]()
//for i in 0...9{
//    studentArray.append(Student(id: i, firstName: "Jméno\(i)", lastName: "Příjmení\(i)"))
//}
//for i in 0...9{
//    if let student = studentArray.getObjectById(i){
//        print("\(student.id) \(student.fullName)")
//    }
//}




