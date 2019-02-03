import UIKit

let pi = 3.141592653589793
let myInt = 9
var myIntVar = 22

let isSwiftAwesome = true


print(pi + 1.0)

// Doubles and Ints can be mixed in an expression when they're raw values.
// The Int will be "upcasted" to avoid information loss
print(993.1 + 1)
print(4 + 33.2)


// Mixing types in an expression won't work with variables or constants, however
//print(pi + myIntConstant)
//print(pi + myIntVar)


if isSwiftAwesome {
    print("Swift is pretty awesome")
}

// Conditional if/else statements have to use actual Booleans
//if pi {
//    print("What kind of hacky language is this?")
//}
