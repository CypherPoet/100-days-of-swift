import UIKit

protocol Identifiable {
    var id: String { get set }
}

struct User: Identifiable {
    var id: String
}


func flashCredentials(of owner: Identifiable) {
    print("MY id is \(owner.id)")
}



