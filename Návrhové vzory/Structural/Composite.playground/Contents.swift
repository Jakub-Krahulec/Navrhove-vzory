import Foundation

// MARK: - Composite

class GraphicObject: CustomStringConvertible{
    var name: String = "Group"
    var color: String = ""
    
    var children = [GraphicObject]()
    
    init(){}
    init(name: String){self.name = name}
    
    func print(_ buffer: inout String, _ depth: Int){
        buffer.append(String(repeating: "*", count: depth))
        buffer.append(color.isEmpty ? "" : "\(color) ")
        buffer.append("\(name)\n")
        
        for child in children{
            child.print(&buffer, depth+1)
        }
    }
    
    var description: String{
        var buffer = ""
        print(&buffer, 0)
        return buffer
    }
}

class Square: GraphicObject{
    init(color: String){
        super.init(name: "Čtverec")
        self.color = color
    }
}

class Circle: GraphicObject{
    init(color: String){
        super.init(name: "Kruh")
        self.color = color
    }
}

let drawing = GraphicObject(name: "Kresba")
drawing.children.append(Circle(color: "Žlutá"))
drawing.children.append(Square(color: "Modrá"))

let group = GraphicObject(name: "Skupina objektů")
group.children.append(Circle(color: "hnědá"))
group.children.append(Square(color: "Béžová"))
drawing.children.append(group)

print(drawing.description)

// Ideální na řešení stromových struktur -> např menu (rekurzivně zanořené) kde každá položka může být nebo nebo podmenu. Se složenými objekty potom můžu pracovat jako s jednoduchými objekty
