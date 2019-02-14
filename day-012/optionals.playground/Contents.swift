import UIKit


class Atom {
    var mass: Int?
    
    init(mass: Int? = nil) {
        self.mass = mass
    }
}

let atom1 = Atom()
let atom2 = Atom(mass: 0)
let atom3 = Atom(mass: 100)


let atoms = [atom1, atom2, atom3]

print("________Direct access________")
for atom in atoms {
    print(atom.mass)
}


print("\n________Nil Coalescing________")
for atom in atoms {
    print(atom.mass ?? "Unknown")
}


print("\n________Optional Chaining________")
for atom in atoms {
    print(atom.mass?.hashValue)
}

