//: [Previous](@previous)

import Foundation


protocol Atomic {
    var atomicNumber: Int { get set }
}

protocol Symbolized {
    var symbol: String { get set }
}

protocol PeriodicElement: Atomic, Symbolized {
    var name: String { get set }
    
    func describe() -> Void
}


// Protocol Extensions
extension PeriodicElement {
    func describe() -> Void {
        print("\(name) | Atomic Number: \(atomicNumber) | Symbol: \(symbol)")
    }
}


struct Carbon: PeriodicElement {
    var name = "Carbon"
    var symbol = "C"
    var atomicNumber = 6
}

struct Xenon: PeriodicElement {
    var name = "Xenon"
    
    var symbol = "Xe"
    var atomicNumber = 54
    
    func describe() {
        print("I am \(name): \(symbol)")
    }
}

let element1 = Carbon()
let element2 = Xenon()

element1.describe()
element2.describe()

//: [Next](@next)
