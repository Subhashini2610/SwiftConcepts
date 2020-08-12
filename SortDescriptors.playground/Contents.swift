/*
 NSSortDesciptors
 Source: http://chris.eidhof.nl/post/sort-descriptors-in-swift/
 */

import Foundation

var numberStrings = [(2, "two"), (1, "one"), (3, "three")]
numberStrings.sort(by: <)

final class Person: NSObject {
    var first: String
    var last: String
    var yearOfBirth: Int
    init(first: String, last: String, yearOfBirth: Int) {
        self.first = first
        self.last = last
        self.yearOfBirth = yearOfBirth
    }

}
let people = [
    Person(first: "Jo", last: "Smith", yearOfBirth: 1970),
    Person(first: "Joe", last: "Smith", yearOfBirth: 1970),
    Person(first: "Joe", last: "Smyth", yearOfBirth: 1970),
    Person(first: "Joanne", last: "smith", yearOfBirth: 1985),
    Person(first: "Joanne", last: "smith", yearOfBirth: 1970),
    Person(first: "Robert", last: "Jones", yearOfBirth: 1970),
]
let lastDescriptor = NSSortDescriptor(key: "last", ascending: true,
  selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
let firstDescriptor = NSSortDescriptor(key: "first", ascending: true,
  selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
let yearDescriptor = NSSortDescriptor(key: "yearOfBirth", ascending: true)

var strings = ["Hello", "hallo", "Hallo", "hello"]
strings.sort { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending}
strings // ["hallo", "Hallo", "Hello", "hello"]

