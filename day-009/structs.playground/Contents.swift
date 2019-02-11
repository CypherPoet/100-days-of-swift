import UIKit

struct City {
    static var citiesFounded = 0
    
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
    
    init(name: String, country: String, isCapital: Bool = false) {
        self.name = name
        self.country = country
        self.isCapital = isCapital
        
        self.population = 0
        City.citiesFounded += 1
    }
}


var paris = City(name: "Paris", country: "France", isCapital: true)
var chicago = City(name: "Chicago", country: "The United States")

paris.population = 3_000_000
print(chicago.capitalStatus)
