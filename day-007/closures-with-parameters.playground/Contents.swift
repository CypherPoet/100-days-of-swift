import UIKit

func awardPoints(computePoints: (Int) -> Int) {
    let startingScore = 100
    let finalScore = computePoints(startingScore)
    
    print("Congratulations! You earned \(String(finalScore)) points!")
}


awardPoints(computePoints: { (startingScore: Int) -> Int in
    return startingScore * 2
})
