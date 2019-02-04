import UIKit

enum Size {
    case small
    case medium
    case large
}


// enums can have associated values

enum Medium {
    case film(runtime: Double)
    case game(missions: Int)
    case book(pages: Int)
}

let assassinsCreed = Medium.game(missions: 13)


// "Raw values" are what enums get assigned to in memory
enum Planet: Int {
    case mercury
    case venus
    case earth
    case mars
}

print(Planet.mercury.rawValue) // 0


// this allows us to access an enum by using `rawValue` as an argument
let earth = Planet(rawValue: 0)

