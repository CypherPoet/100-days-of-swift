import UIKit

struct City {
    var name: String
    var country: String
    var isCapital: Bool
    
    var population: Int {
        didSet {
            print("New population of \(name): \(population)")
        }
    }
    
    var capitalStatus: String {
        return "\(name) is \(isCapital ? "" : "not ")the capital of \(country)"
    }
    
    func taxIncome() -> Double {
        return Double(population) * 0.0  // 😛
    }
    
    mutating func grantEntry() -> Void {
        population += 1
    }
}


let paris = City(name: "Paris", country: "France", isCapital: true, population: 2_241_346)
var nyc = City(name: "New York City", country: "The United States", isCapital: false, population: 8_550_405)


print(paris.capitalStatus)
print(nyc.capitalStatus)

nyc.population += 1
nyc.grantEntry()

//paris.grantEntry()  // Error: Cannot use mutating member on immutable value
