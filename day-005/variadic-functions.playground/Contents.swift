import UIKit


func add(numbers: Int...) -> Int {
    return numbers.reduce(0, { accumulated, currentNum in
        accumulated + currentNum
    })
}

add(numbers: 3, 4, 5, 6, 7)


