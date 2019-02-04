import UIKit

var response = (status: 201, message: "Created a new 🦄")
var grabBag = (4, "🦄", [23, 11, 4], 99.3, Character("a"))

// Numeric Access
print(grabBag.0)
print(grabBag.1)

grabBag.0 = 44

print(grabBag.0)

// Key-based access
print(response.0)
print(response.1 == response.message)

