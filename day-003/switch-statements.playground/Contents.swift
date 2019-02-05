import UIKit


// Combining switch statements with enums can be quite handy. Not only
// can we elide the top-level enum name, but we can also avoid needing to
// use `default` if we're exhaustive enough with our cases.

enum Planet: String {
    case mercury, venus, earth, mars, jupiter, saturn, neptune, uranus
}


let myHome = Planet.earth


switch myHome {
case .mercury:
    print("It's a bit dry")
case .venus:
    print("Smells funny")
case .earth:
    print("I might stay a while")
case .mars:
    print("See you soon?")
case .jupiter:
    print("Thanks for the shields")
case .saturn:
    print("Still more rings than Brady")
case .uranus:
    print("Stay frosty")
case .neptune:
    print("Far out")
}


// case statements can employ ranges
let steaks = 1

switch steaks {
case Int.min...0:
    print("Vegan mode")
case 0..<12:
    print("Less than a dozen")
case 12:
    print("Dozen")
case 12...Int.max:
    print("That's a lot of steak")
default:
    print("Where's the beef?")
}


let planet = Planet.jupiter

switch planet {
case _ where [.mercury, .venus].contains(planet):
    print("Close to the sun")
case _ where [.earth, .mars].contains(planet):
    print("Habitable zone")
default:
    print("Spaceman")
}
