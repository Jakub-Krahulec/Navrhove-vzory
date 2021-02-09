import Foundation

// MARK: - Mediator
// Prostředník mezi přímou komukací několika objektů. Tím snížím počet vazeb mezi objekty a reguluju jejich odpovědnost.

class Person{
    var name: String
    var room: ChatRoom?
    private var chatLog = [String]()
    
    init(name: String){
        self.name = name
    }
    
    func receive(sender: String, message: String){
        let s = "\(sender): '\(message)'"
        print("[\(name)'s chat session] \(s)")
        chatLog.append(s)
    }
    
    func pm(to target: String, message: String){
        room?.message(sender: name, destination: target, message: message)
    }
    
    func say(message: String){
        room?.broadcast(sender: name, message: message)
    }
}

class ChatRoom{
    private var people = [Person]()
    
    func broadcast(sender: String, message: String){
        for p in people{
            if p.name != sender{
                p.receive(sender: sender, message: message)
            }
        }
    }
    
    func join(person: Person){
        let joinMsg = "\(person.name) joins the chat"
        broadcast(sender: "room", message: joinMsg)
        person.room = self
        people.append(person)
    }
    
    func message(sender: String, destination: String, message: String){
        people.first{$0.name == destination}?.receive(sender: sender, message: message)
    }
}

let room = ChatRoom()
let jakub = Person(name: "Jakub")
let jana = Person(name: "Jana")

room.join(person: jakub)
room.join(person: jana)

jana.say(message: "Ahoj")
jakub.say(message: "Čau všichni")

let ema = Person(name: "Ema")
room.join(person: ema)
ema.say(message: "Ahojte")
ema.pm(to: "Jakub", message: "Jak se máš?")
