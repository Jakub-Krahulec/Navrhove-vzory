import Foundation

// MARK: - Chain of resposibility

// MARK: - Command = dotaz na akci nebo změnu (nastav jméno na "Jakub")
// MARK: - Query = Dotaz na ifnormaci (vrať mi jméno)
// MARK: - CQS = samostatné prostředky pro odesílání commandů a queries např. přímý přístup k fieldu

// Odděluje odesílatele požadavku od jeho příjemnců, kterých může být více. Požadavek je předáván mezi příjemcci až k tomu, který jej má vyřídit. (Měl bych počítat se situací, že příjemnce nemusí být nalezen!)
// Někdy se kombinuje s Composite (composite definuje stromovou strukturu) pro předávání odpovědností v stormové struktuře
// Některé frameworky jej využívají pro implementaci událostního modelu

// MARK: - Method Chain

class Creature: CustomStringConvertible{
    var name: String
    var attack: Int
    var defense: Int
    
    init(name: String, attack: Int, defense: Int){
        self.name = name
        self.attack = attack
        self.defense = defense
    }
    
    var description: String{
        return "Jméno: \(name), A: \(attack), D = \(defense)"
    }
}

class CreatureModifier{
    let creature: Creature
    var next: CreatureModifier?
    
    init(creature: Creature) {
        self.creature = creature
    }
    
    func add(_ cm: CreatureModifier){
        if let next = next{
            next.add(cm)
        } else{
            next = cm
        }
    }
    
    func handle(){
        next?.handle()
    }
}

class DoubleAttackModifier: CreatureModifier{
    override func handle() {
        print("Zdvojnásobuju attack")
        creature.attack *= 2
        super.handle()
    }
}

class IncreaseDefenseModifier: CreatureModifier{
    override func handle() {
        print("Zvětšuju obranu")
        creature.defense += 3
        super.handle()
    }
}

class NoBonusModifier: CreatureModifier{
    override func handle() {
        
    }
}

let goblin = Creature(name: "Goblin", attack: 2, defense: 2)
print(goblin)

let root = CreatureModifier(creature: goblin)
//root.add(NoBonusModifier(creature: goblin))
root.add(DoubleAttackModifier(creature: goblin))
root.add(IncreaseDefenseModifier(creature: goblin))
root.handle()

print(goblin)

