import UIKit

let planets = ["Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"]


deepNesting: for planet in planets {
    print("Passing through \(planet)")
    
    numbers: for i in 1...10 {
        if i == 3 { break numbers }
        print("Inside of `numbers` loop")
    }
    
    spaceDust: for i in 1...3 {
        print("Moving through space dust")
        asteroids: for j in 1...3 {
            print("Saw an asteroid")
            
            if i == 2 { break spaceDust }
        }
        
        if i == 2 { break }
        if i == 333 { break deepNesting }
    }
}


