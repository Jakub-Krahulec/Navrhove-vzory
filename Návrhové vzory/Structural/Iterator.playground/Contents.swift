import Foundation

// MARK: - Iterator
 // Objekt (nebo metoda) usnadňující procházení datové struktury
// Návrhový vzor zavádí samostatný objekt, který umožňuje jednoduché lineární procházení kolekcemi, aniž bych musel znát vnitřní strukturu. Je implementován v knihovnách téměř všech jazyků.
// Objekt většinou poskytuje rozhraní obsahující: Current (prvek na aktuální pozici), Next (přesune kurzor na další prvek v kolekci), Reset (přesune kurzor na první pozici)

class Node<T>{
    var value: T
    var left: Node<T>? = nil
    var right: Node<T>? = nil
    var parent: Node<T>? = nil
    
    init(value:T){
        self.value = value
    }
    
    init(value: T, left: Node<T>, right: Node<T>){
        self.value = value
        self.right = right
        self.left = left
        
        left.parent = self
        right.parent = self
    }
}

class InOrderIterator<T> : IteratorProtocol{
    
    var current: Node<T>?
    var root: Node<T>
    var yieledStart = false
    
    init(root: Node<T>){
        self.root = root
        current = root
        while current!.left != nil {
            current = current!.left!
        }
    }
    
    func reset(){
        current = root
        yieledStart = false
    }
    
    func next() -> Node<T>? {
        if !yieledStart{
            yieledStart = true
            return current
        }
        
        if current!.right != nil{
            current = current!.right
            while current!.left != nil{
                current = current!.left
            }
            return current
        } else{
            var p = current!.parent
            while p != nil && current === p!.right{
                current = p!
                p = p!.parent
            }
            current = p
            return current
        }
    }
}

class BinaryTree<T> : Sequence{
    private let root: Node<T>
    
    init(root: Node<T>){
        self.root = root
    }
    
    func makeIterator() -> InOrderIterator<T> {
        return InOrderIterator<T>(root: root)
    }
    
}

//    1
//   / \
//  2   3

// 213

let root = Node(value: 1, left: Node(value: 2), right: Node(value: 3))
let it = InOrderIterator(root: root)
while let element = it.next(){
    print(element.value, terminator: " ")
}
print("")

let nodes = AnySequence{InOrderIterator(root: root)}
print(nodes.map({$0.value}))

let tree = BinaryTree(root: root)
print(tree.map({$0.value}))


// MARK: - Array-Backed Properties

class Creature: Sequence{
    var stats = [Int](repeating: 0, count: 3)
    
    private let _strength = 0
    private let _agility = 1
    private let _intelligence = 2
    
    var strenght: Int{
        get {return stats[_strength]}
        set(value){stats[_strength] = value}
    }
    
    var agility: Int{
        get {return stats[_agility]}
        set(value){stats[_agility] = value}
    }
    
    var intelligence: Int{
        get {return stats[_intelligence]}
        set(value){stats[_intelligence] = value}
    }
    
    var averageStat: Int{
        return stats.reduce(0,+) / stats.count
    }
    
    func makeIterator() -> some IteratorProtocol {
        return IndexingIterator(_elements: stats)
    }
    
    subscript(index: Int) -> Int{
        get {return stats[index]}
        set(value) {stats[index] = value}
    }
}

let c = Creature()
c.strenght = 10
c.agility = 15
c.intelligence = 11

c[0] = 10

print(c.averageStat)

for s in c{
    print(s)
}
