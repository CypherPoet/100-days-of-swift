import UIKit


class Player {
    var name: String
    var xp: Double = 0
    var level: Int = 1
    var hitPoints: Int = 0
    
    init(name: String, hitPoints: Int) {
        self.name = name
        self.hitPoints = hitPoints
    }
    
    func levelUp() -> Void {
        self.level += 1
    }
    
    deinit {
        print("😵")
    }
}

final class Archer: Player {
    var arrows: Int
    
    init(name: String, arrows: Int) {
        self.arrows = arrows

        super.init(name: name, hitPoints: 100)
    }
    
    override func levelUp() {
        super.levelUp()
        
        self.arrows += 10
        self.hitPoints += 10
    }
}


var player1 = Archer(name: "CypherPoet", arrows: 10)

// ⚠️ Unlike structs, class instances are copied by reference!
var anotherPlayer1 = player1
anotherPlayer1.name = "Thief"

print(player1.name)


// Automatic Deinitialization
for _ in 1...3 {
    Player(name: "xxxxx", hitPoints: 1)
}

// Manual Deinitialization
var ghost: Player? = Player(name: "👻", hitPoints: 0)
ghost = nil
