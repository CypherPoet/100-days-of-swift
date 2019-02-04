import UIKit

//   - Items must be unique. Even trying to initialize a set with duplicate values will produce a deduped set
var characters = Set(["Ezio", "Altair", "Bayek", "Desomond", "Evie", "Bayek"])

print(characters)

// Because sets have no guaranteed order, they can't be indexed like arrays...
// characters[4] // error

// ...And insertions are general
characters.insert("Kassandra")

print(characters)
