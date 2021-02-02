import Foundation

// MARK: - Facade
// můžu použít pokud chci mít jednodušší API pro více tříd
// zároveň můžu nechat příštupné ty třídy nad kterými stavím api
// To znamená že můžu mít například jednoduché API, ale zároveň mít přístup k low level věcem pokud je to nutné / potřebné

class Buffer{
    var width, height: Int
    var buffer: [Character]
    
    init(width: Int, height: Int){
        self.width = width
        self.height = height
        buffer = [Character](repeating: " ", count: width*height)
    }
    
    subscript(_ index: Int) -> Character{
        return buffer[index]
    }
}

class Viewport{
    var buffer: Buffer
    var offset = 0
    
    init(buffer:  Buffer){
        self.buffer = buffer
    }
    
    func getCharacterAt(_ index: Int) -> Character{
        return buffer[offset+index]
    }
}

class Console{
    var buffers = [Buffer]()
    var viewports = [Viewport]()
    var offset = 0
    
    init(){
        let buffer = Buffer(width: 30, height: 20)
        let viewport = Viewport(buffer: buffer)
        buffers.append(buffer)
        viewports.append(viewport)
    }
    
    func getCharacterAt(_ index: Int) -> Character{
        return viewports[0].getCharacterAt(index)
    }
}

let c = Console()
let u = c.getCharacterAt(1)
