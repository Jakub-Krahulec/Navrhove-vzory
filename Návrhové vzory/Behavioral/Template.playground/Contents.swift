import Foundation

// MARK: - Template

// Nadefinuju si kostru algoritmu a konkrétní implementaci vložím do sub tříd

class Game{
    // Nadefinuju si algoritmus na high level s abstractním vnitřkem (metody / vlastnosti)
    func run(){
        start()
        while !haveWinner{
            takeTurn()
        }
        print("Player \(winningPlayer) wins!")
    }
    
    internal var haveWinner: Bool{
        get{
          //  precondition(false, "metoda musí být přepsána")
            return false
        }
    }
    
    internal var winningPlayer: Int{
        get{
          //  precondition(false, "metoda musí být přepsána")
            return -1
        }
    }
    
    internal func start(){
        precondition(false, "metoda musí být přepsána")
    }
    
    internal func takeTurn(){
        precondition(false, "metoda musí být přepsána")
    }
    
    internal var currentPlayer = 0
    internal let numberOfPlayers: Int
    
    init(numberOfPlayers: Int){
        self.numberOfPlayers = numberOfPlayers
    }
}

// Podědím třídu s algoritmem a přepíšu potřebné části
class Chess: Game{
    private let maxTurns = 10
    private var turn = 1
    
    init() {
        super.init(numberOfPlayers: 2)
    }
    
    override func start() {
        print("Hra začíná")
    }
    
    override var haveWinner: Bool{
        return turn == maxTurns
    }
    
    override func takeTurn() {
        print("Tah \(turn) hráčem \(currentPlayer)")
        currentPlayer = (currentPlayer + 1) % numberOfPlayers
        turn += 1
    }
    
    override var winningPlayer: Int{
        return currentPlayer
    }
}

let chess = Chess()
chess.run()
