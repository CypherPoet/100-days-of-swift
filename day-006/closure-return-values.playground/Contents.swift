import UIKit

let greet = { (name: String) in
    print("👋 Hello, \(name)")
}

let makeGreeting = { (name: String) -> String in
    return "👋 Hello, \(name)"
}


greet("friend")
print(makeGreeting("Star Lord"))
