import UIKit

// Dictionaries use key-value pairs
var scoreData = [
    "Brian": 99,
    "Alex": 22,
    "North": 112
]

// key's can be of any type
var primeFactors = [
    9: [3, 3],
    12: [2, 2, 3],
    99: [3, 3, 11]
]

// Really... keys can be of any type
var deepMap = [
    ["A", "B", "C"]: 4,
    ["D", "E", "F"]: 9
]

// Reading from dictionaries produces an Optional
print(scoreData["Brian"])   // Optional(99)

// However, we can guarantee a value by
print(scoreData["Brian", default: 0])  // 99
