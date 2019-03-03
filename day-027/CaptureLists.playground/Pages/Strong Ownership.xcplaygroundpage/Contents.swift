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
    
    return  {
        singer.sing()
    }
}

let sing = makeSing()

// Oh, this sings, for sure. But that's because the `singer` reference in our closure is
// never destroyed. In an actual application, that leads to memory leaks.
sing()


