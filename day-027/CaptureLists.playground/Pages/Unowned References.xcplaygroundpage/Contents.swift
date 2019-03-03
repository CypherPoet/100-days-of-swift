import UIKit

class Singer {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func sing() {
        print("Goodnight, sweet prince")
    }
}


func makeSing() -> () -> Void {
    let singer = Singer(name: "Taylor")
    
    return  { [unowned singer] in
        singer.sing()
    }
}

let sing = makeSing()

// ⚠️ This code will straight up crash. We promised the compiler that `singer` singer
// will exist when we try to use it -- but it doesn't because it only lives inside the
// `makeSing` function.
sing()


