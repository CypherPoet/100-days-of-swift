import UIKit

class Singer {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func sing() {
        print("🎶🎶🎶🎶")
    }
}


func makeSing() -> () -> Void {
    let singer = Singer(name: "Taylor")
    
    return { [weak singer] in
        singer?.sing()
    }
}

let sing = makeSing()

// Nothing happens because the `singer` reference in our closure was destroyed
// when the `makeSing` function exited
sing()


