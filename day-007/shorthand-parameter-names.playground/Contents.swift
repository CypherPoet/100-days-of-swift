import UIKit

func attackEnemy(onHit: (Int) -> Void) {
    let didHit = Int.random(in: 0...1) % 2 == 0
    
    if didHit {
        let damageDone = Int.random(in: 0...100)
        
        onHit(damageDone)
    } else {
        print("Missed!")
    }
}


// Full Syntax
attackEnemy(onHit: { (damageDone: Int) -> Void in
    print("We did \(String(damageDone)) damage points!")
})


// Omit Return Type
attackEnemy(onHit: { (damageDone: Int) in
    print("We did \(String(damageDone)) damage points!")
})


// Omit parameter label
attackEnemy { (damageDone) -> Void in
    print("We did \(String(damageDone)) damage points!")
}


// Omit parameter label and parentheses
attackEnemy { damageDone -> Void in
    print("We did \(String(damageDone)) damage points!")
}

// Omit parameter label and parentheses, and return type
attackEnemy { damageDone in
    print("We did \(String(damageDone)) damage points!")
}

// Trailing return syntax, complete omission of function signature
attackEnemy {
    print("We did \(String($0)) damage points!")
}
