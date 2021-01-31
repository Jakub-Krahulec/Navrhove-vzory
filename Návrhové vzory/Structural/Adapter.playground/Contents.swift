import Foundation

// MARK: - Adapter (Wrapper)
// Pokud má komponenta nekompatibilní rozhraní, tak ji "obalím" vlastním rozhraním
// Například když budu používat kód třetích stran který často mění rozhraní, tak si vytvořím adaptér a budu měnit kód pouze na jednom místě (v adaptéru).. zbytek aplikace bude používat funkční adaptér


class Point: CustomStringConvertible{
    var x,y: Int
    
    init(x: Int, y: Int){
        self.x = x
        self.y = y
    }
    
    var description: String{
        return "\(x), \(y)"
    }
}

class Line{
    var start: Point
    var end: Point
    
    init(start: Point, end: Point){
        self.start = start
        self.end = end
    }
}


class VectorObject: Sequence{
    var lines = [Line]()
    
    func makeIterator() -> some IteratorProtocol {
        return IndexingIterator(_elements: lines)
    }
}

class VectorRectangle: VectorObject{
    init(x: Int, y: Int, width: Int, height: Int){
        super.init()
        lines.append(Line(start: Point(x: x, y: y), end: Point(x: x + width, y: y)))
        lines.append(Line(start: Point(x: x+width, y: y), end: Point(x: x + width, y: y+height)))
        lines.append(Line(start: Point(x: x, y: y), end: Point(x: x, y: y + height)))
        lines.append(Line(start: Point(x: x, y: y + height), end: Point(x: x + width, y: y+height)))
    }
}

// Vytvořím si adaptér který mi z lajny udělá pointy pro renderer který umí vykreslovat jednotlivé body
class LineToPointAdapter: Sequence{
    private static var count = 0
    var points = [Point]()
    
    init(line: Line){
        type(of: self).count += 1
        print("\(type(of: self).count): Generuji pointy pro line", "[\(line.start.x), \(line.start.y)]-[\(line.end.x), \(line.end.y)]")
        
        let left = Swift.min(line.start.x, line.end.x)
        let right = Swift.max(line.start.x, line.end.x)
        let top = Swift.min(line.start.y, line.end.y)
        let bottom = Swift.max(line.start.y, line.end.y)
        
        let dx = right - left
        let dy = line.end.y - line.start.y
        
        if dx == 0 {
            for y in top...bottom{
                points.append(Point(x: left, y: y))
            }
        } else if dy == 0 {
            for x in left...right{
                points.append(Point(x: x, y: top))
            }
        }
    }
    
    func makeIterator() -> some IteratorProtocol {
        return IndexingIterator(_elements: points)
    }
}
