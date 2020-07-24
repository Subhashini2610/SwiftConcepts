/*
 Structs and classes:
 
 Commonalities:
 Define properties to store values
 Define methods to provide functionality
 Define subscripts to provide access to their values using subscript syntax
 Define initializers to set up their initial state
 Be extended to expand their functionality beyond a default implementation
 Conform to protocols to provide standard functionality of a certain kind
 Extensions possible in both
 
 Differences:
 Inheritance enables one class to inherit the characteristics of another. Struct or enum cannot do inheritance.
 Type casting enables you to check and interpret the type of a class instance at runtime.
 Deinitializers enable an instance of a class to free up any resources it has assigned.
 Reference counting allows more than one reference to a class instance.
 Structs are value type; Classes are reference type
 */

import Foundation
import UIKit

struct Location {
    //if class, it needs an init
    let latitude: Double
    let longitude: Double
}

//functions in structs
struct DeliveryRange {
    var range: Double
    let center: Location
    func isInRange(customer: Location) -> Bool {
      let difference = sqrt(pow((customer.latitude - center.latitude), 2) +
            pow((customer.longitude - center.longitude), 2))
      return difference < range
    }
}
let storeLocation = Location(latitude: 44.9871, longitude: -93.2758)
let pizzaRange = DeliveryRange(range: 2, center: Location(latitude: 35.99, longitude: -91.2))
let isInRange = pizzaRange.isInRange(customer: storeLocation)
print(isInRange)

struct ClimateControl {
    var temperature: Double
    var humidity: Double?

    init(temp: Double) {
        temperature = temp
    }
    init(temp: Double, hum: Double) {
        temperature = temp
        humidity = hum
    }
}
let control = ClimateControl(temp: 90.0)


//Protocols and Structs
//associated type is like generics
protocol Queue {
    associatedtype ItemType
    var count: Int {get}
    mutating func push(_ element: ItemType)
    mutating func pop() -> ItemType?
    init()
}

struct Container<Item>: Queue {
    
    private var items: [Item] = []
    var count: Int {
        return items.count
    }
    
    mutating func push(_ element: Item) {
        items.append(element)
    }
    
    mutating func pop() -> Item? {
        return items.removeFirst()
    }
}

//protocols cant be instantiated
//let q = Queue()

//Optional Methods in protocols -> can be achieved by adding them in the protocol's extension
protocol ErrorHandler {
    func handle(error: Int)
}

struct Handler: ErrorHandler {
    //Code A
    func handle(error: Int) {
        print("Code A")
        print(error)
    }
    
}
//with this code A becomes optional
extension ErrorHandler {
    func handle(error: Int) {
        print("Extension")
        print(error)
    }
}
let error = Handler()
error.handle(error: 6)

//Conditional Extensions
extension ErrorHandler where Self: UIViewController {
    func handle(error: Int) {
        
    }
}

//Ambiguous method implementations
protocol P1 {
    func method()
}
protocol P2 {
    func method() //bodies must not be present in protocols
}

struct S: P1, P2 {
    //dont know whether this belongs to P1 or P2
    func method() {
        print("first method")
    }
}

let s = S()
s.method()

//Another ambiguous method implementation
protocol Pr1 {
    func method()
}
protocol Pr2 {
    func method()
}

extension Pr1 {
    func method() {
        print("Pr1")
    }
}

extension Pr2 {
    func method() {
        print("Pr2")
    }
}

struct S1: Pr1, Pr2 {
    func method() {
        print("Method S")
    }
}
let st = S1()
st.method()


//Adding new methods
extension Queue {
    func compare<Q: Queue>(queue: Q) -> ComparisonResult {// same as compare<Q>(queue: Q) -> ComparisonResult where Q: Queue
        if count < queue.count { return .orderedDescending }
        if count > queue.count { return .orderedAscending }
        return .orderedSame
    }
}

/*
 Note: Protocol extensions vs Base Classes
 With base classes, multiple inheritance is not possible.
 Protocols can be adopted by enums, classes, structs etc, but base classes are possible with classes only
 */
