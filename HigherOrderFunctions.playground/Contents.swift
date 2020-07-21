/*
 Higher order functions are functions that take one or more functions as arguments and/or return another function as argument.
 Eg: sorted, filter, map, reduce, compactMap, flatMap
 */
//Source: https://www.appcoda.com/higher-order-functions-swift/

//reduce, filter, compactMap reduce the size of existing array

//Map on arrays, dictionaries
let numbers = [2, 5, 3, 9, 15, 12, 8, 17, 20, 11]
var info = [String: String]()
info["name"] = "andrew"
info["city"] = "berlin"
info["job"] = "developer"
info["hobby"] = "computer games"

let doubled = numbers.map { (number) -> Int in
    return number * 2
}
print(doubled)

//Map - shorthand argument
let doubleArray = numbers.map { $0 * 2 }
print(doubleArray)

//map on a dictionary returns the key-value pair as a tuple
let newArray = info.map { (key, value) -> String in
    return "Key: \(key) Value: \(value)"
}
print(newArray)

//getting all keys
let keys = info.map { (key, value) -> String in
    return key
}
print(keys)

let values = info.map { $0.value }
print(values)

let updatedKeysAndValues = info.map { ($0.key.uppercased(), $0.value.uppercased()) }
print(updatedKeysAndValues)

//shorthand
let updatedKeysAndValuesInShorthand = info.map { ($0.uppercased(), $1.uppercased()) }
print(updatedKeysAndValues)

//Map on dictionary to modify values alone: mapvalues
let mapValues = info.mapValues { $0.uppercased() }
print(mapValues)

class Tester {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

let testers = [Tester(name: "John", age: 23), Tester(name: "Lucy", age: 25), Tester(name: "Tom", age: 32), Tester(name: "Mike", age: 29), Tester(name: "Hellen", age: 19), Tester(name: "Jim", age: 35)]

let ages = testers.map { $0.age }
print(ages)

//CompactMap: does not return nil values
let numbersWithNil = [5, 15, nil, 3, 9, 12, nil, nil, 17, nil]
let doubleNumbersWithoutNil = numbersWithNil.map { $0 != nil ? $0! * 2 : nil }
print(doubleNumbersWithoutNil)

let doubleNumbersWithoutNilCM = numbersWithNil.compactMap { $0 != nil ? $0! * 2 : nil }
print(doubleNumbersWithoutNilCM)

//Flat map: Collections of collections
let marks = [[3, 4, 5], [2, 5, 3], [1, 2, 2], [5, 5, 4], [3, 5, 3]]
let allMarks = marks.flatMap { (array) -> [Int] in
    return array
}
print(allMarks)
let allMark = marks.flatMap{ $0 }
print(allMark)

let valuesWithNil = [[2, nil, 5], [4, 3, nil], [nil, nil, 1]]
let allValues = valuesWithNil.flatMap{ $0 }
print(allValues)

//Filter: return type is always bool
let numbersArr = [2, 5, 3, 9, 15, 12, 8, 17, 20, 11]
let over10 = numbersArr.filter { (num) -> Bool in //the return is always bool specifying whether the element should be added in new collection or not
    return num > 10
}
print(over10)
let over5 = numbersArr.filter { $0 > 5}
print(over5)

let results = testers.filter { (tester) -> Bool in
    tester.name.hasPrefix("J") && tester.age >= 30
}
print(results[0].name)

//Reduce: for arrays
let product = numbersArr.reduce(1) { (partialResult, element) -> Int in
    partialResult * element
}
print(product)
let prod = numbersArr.reduce(1, {$0 * $1})
print(prod)
let prodReduced = numbersArr.reduce(1, *)
print(prodReduced)

//Reduce: for dictionaries ($0 represents partial result)
let friendsAndMoney = ["Alex": 150.00, "Tim": 62.50, "Alice": 79.80, "Jane": 102.00, "Bob": 94.20]
let allMoney = friendsAndMoney.reduce(0, {$0 + $1.value})
print(allMoney)

//ForEach sample:
numbers.forEach { (num) in
    print(num.isMultiple(of: 2) ? "\(num) is even" : "\(num) is odd")
}
numbers.forEach({print($0.isMultiple(of: 2) ? "\($0) is even" : "\($0) is odd")})

//Contains: always returns a Bool value
class Staff {
    enum Gender {
        case male, female
    }
 
    var name: String
    var gender: Gender
    var age: Int
 
    init(name: String, gender: Gender, age: Int) {
        self.name = name
        self.gender = gender
        self.age = age
    }
}
 
let staff = [Staff(name: "Nick", gender: .male, age: 37), Staff(name: "Julia", gender: .female, age: 29), Staff(name: "Tom", gender: .male, age: 41), Staff(name: "Tony", gender: .male, age: 45), Staff(name: "Emily", gender: .female, age: 42), Staff(name: "Irene", gender: .female, age: 30)]

let staffOver40 = staff.contains { (staff) -> Bool in
    return staff.age > 40
}
print(staffOver40)
//Same goes for removeAll, removeAt

//Sorted: the elements should conform to comparable
//Intro_sort algorithm is used to perform the sorting.
let sorted = numbers.sorted()
print(sorted)

//40 times
let descArray = numbers.sorted { (elem1, elem2) -> Bool in
    return elem1 > elem2
}
print(descArray)

//41 times
let descArray1 = numbers.sorted(by: {$0 > $1})
print(descArray1)

let descArray2 = numbers.sorted(by: >)
print(descArray2)

//Split: elements should conform to Collection protocol
let message = "Hello world!!!"
let result = message.split{ $0 == " " }
print(result)
let anotherMessage = "This message   is going to be broken in pieces!"
let splitOnce = anotherMessage.split(maxSplits: 1, whereSeparator: { $0 == " " })
let emptySequences = anotherMessage.split(omittingEmptySubsequences: false, whereSeparator: { $0 == " " })
let messageSplit = message.split{ $0 == "." || $0 == "!"}
print(splitOnce)
print(emptySequences)
print(messageSplit)

//Note split always creates String.subsequence and not String
//To create strings out of it:
let strings = result.map { String($0) }
print(strings)
