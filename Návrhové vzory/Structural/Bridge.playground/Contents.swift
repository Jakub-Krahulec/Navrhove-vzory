import Foundation

// MARK: - Bridge
// Slouží k zapouzdření kódu
// Odděluje měnící se rozhraní od měnící implementace tohoto rozohraní. (Narozdíl od adaptéru počítá se změnou i implementace nejen rozhraní)
// Mezi "pohyblivou" implementací a rozhraním staví "most" (v mém příkladu rendered)

protocol Renderer{
    func renderCircle(_ radius: Float)
}

class VectorRenderer: Renderer{
    func renderCircle(_ radius: Float) {
        print("Nakresli vektorový kruh")
    }
}

class RasterRenderer: Renderer{
    func renderCircle(_ radius: Float) {
      //  print("Vykresli pixely")
        print("Vykresli pixely novou implementací")
    }
}

protocol Shape{
    func draw()
    func resize(_ factor: Float)
}

class Circle: Shape{
    var radius: Float
    var renderer: Renderer
    
    init(renderer: Renderer, radius: Float){
        self.radius = radius
        self.renderer = renderer
    }
    
    func draw() {
        renderer.renderCircle(radius)
    }
    
    func resize(_ factor: Float) {
        radius*=factor
    }
}

let circle = Circle(renderer: RasterRenderer(), radius: 5)
let circle2 = Circle(renderer: VectorRenderer(), radius: 5)

circle.draw()
circle2.draw()


