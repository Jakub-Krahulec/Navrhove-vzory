import Foundation

// MARK: - Composite

class GraphicObject: CustomStringConvertible{
    var name: String = "Group"
    var color: String = ""
    
    var childre = [GraphicObject]()
    
    init(){}
    init(name: String){self.name = name}
    
    var description: String{
        var buffer = ""
        
    }
}
