import UIKit

var str = "Hello, playground"


import UIKit

let greet = { (name: String) in
    print("👋 Hello, \(name)")
}

let makeGreeting = { (name: String) -> String in
    return "👋 Hello, \(name)"
}


func introduce(name: String, greet: (String) -> Void) {
    greet(name)
    print("Nice to meet you.")
}


func zap(response: () -> Void) {
    print("⚡️")
}

zap {
    print("Yo!")
}


introduce(name: "Star Lord", greet: greet)


// Trailing return syntax!

introduce(name: "friend") { (name: String) -> Void in
    print("🙋‍♂️ Greetings, \(name)")
}

introduce(name: "everybody") { (name: String) in
    print("Hey \(name)")
}



