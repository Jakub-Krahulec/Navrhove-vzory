import Foundation


// MARK: - Builder
// Namísto objektu s 10ti init argumentama je lepší vytvořit BUILDER -> API pro vytvoření objektu krok za krokem
// Je to v podstatě objekt pro tvorbu objektů
// Pro plynulost (fluent) může vracet sám sebe v každé metodě a řetězit volání metod

class HtmlBuilder: CustomStringConvertible{
    private let rootName: String
    var root = HtmlElement()
    
    init(rootName: String){
        self.rootName = rootName
        root.name = rootName
    }
    
    func addChild(name: String, text: String){
        let e = HtmlElement(name: name, text: text)
        root.elements.append(e)
    }
    
    func addChildFluent(name: String, text: String) -> HtmlBuilder{
        let e = HtmlElement(name: name, text: text)
        root.elements.append(e)
        return self
    }
    
    func clear(){
        root = HtmlElement(name: rootName, text: "")
    }
    
    var description: String{
        return root.description
    }
}

class HtmlElement: CustomStringConvertible {
    var name = ""
    var text = ""
    var elements = [HtmlElement]()
    private let indentSize = 2
    
    init(){}
    init(name: String, text: String){
        self.name = name
        self.text = text
    }
    
    private func descriptions(indent: Int) -> String{
        var result = ""
        let  i = String(repeating: " ", count: indent)
        result += "\(i)<\(name)>\n"
        
        if !text.isEmpty{
            result += String(repeating: " ", count: indent + 1)
            result += text
            result += "\n"
        }
        
        for e in elements{
            result += e.descriptions(indent: indent + 1)
        }
        
        result += "\(i)</\(name)>\n"
        return result
    }
    
    public var description: String{
        return descriptions(indent: 0)
    }
}

let builder = HtmlBuilder(rootName: "ul")
// BUILDER
builder.addChild(name: "li", text: "něco")
builder.addChild(name: "li", text: "něco1")
builder.addChild(name: "li", text: "něco2")
// FLUENT BUILDER
let _ = builder.addChildFluent(name: "li", text: "Fluent něco")
    .addChildFluent(name: "li", text: "Fluent něco 2")
    .addChildFluent(name: "li", text: "Fluent něco 3")

print(builder.description)


// MARK: - Faceted Builder
// Pokud začne být i samostatný builder příliš komplikovaný, může se rozdělit na více builderů které pracují dohromady přes base třídu

class Person : CustomStringConvertible{
    //address
    var streetAddress = "", postcode = "", city = ""
    
    // employment
    var companyName = "", position = ""
    var annualIncome = 0
    
    var description: String{
        return "Adresa: \(streetAddress), \(postcode), \(city), Práce: \(companyName), pozice: \(position), výplata: \(annualIncome)"
    }
}

class PersonBuilder{
    var person = Person()
    var lives : PersonAddressBuilder{
        return PersonAddressBuilder(person)
    }
    var works: PersonJobBuilder{
        return PersonJobBuilder(person)
    }
    
    func build() -> Person {
        return person
    }
}

class PersonAddressBuilder: PersonBuilder {
    internal init(_ person: Person){
        super.init()
        self.person = person
    }
    
    func at(_ streetAddress: String) -> PersonAddressBuilder{
        person.streetAddress = streetAddress
        return self
    }
    
    func withPostcode(_ postcode: String) -> PersonAddressBuilder{
        person.postcode = postcode
        return self
    }
    
    func inCity(_ city: String) -> PersonAddressBuilder {
        person.city = city
        return self
    }
}

class PersonJobBuilder: PersonBuilder{
    internal init(_ person: Person){
        super.init()
        self.person = person
    }
    
    func at(_ companyName: String) -> PersonJobBuilder {
        person.companyName = companyName
        return self
    }
    
    func asA(_ position: String) -> PersonJobBuilder{
        person.position = position
        return self
    }
    
    func earning(_ annualIncome: Int) -> PersonJobBuilder{
        person.annualIncome = annualIncome
        return self
    }
}

let pb = PersonBuilder()
let p = pb
    .lives.at("Jižní 1969")
          .inCity("Hranice")
          .withPostcode("75301")
    .works.at("Bonver")
          .asA("Vývojář")
          .earning(123456)
    .build()

print(p)

