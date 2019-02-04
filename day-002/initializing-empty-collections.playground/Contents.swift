import UIKit

var names = [String]()
var scores = [String: Int]()

names.append("Alex")
scores[names[0]] = 33

// sets have to use the "official", angle-bracket-based type signature
var items = Set<String>()

items.insert("Computer")

// .... But this can be use for arrays and dictionaries if desired
var oldSchoolArray = Array<Int>()
var atomicNumbers = Dictionary<String, Int>()

atomicNumbers["Xe"] = 54



