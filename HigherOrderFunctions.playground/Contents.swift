/*
 Higher order functions are functions that take one or more functions as arguments and/or return another function as argument.
 Eg: sorted, filter, map, reduce, compactMap, flatMap
 */
//Source: https://www.appcoda.com/higher-order-functions-swift/

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
