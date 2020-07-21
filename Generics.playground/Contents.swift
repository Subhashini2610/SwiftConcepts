/*
 Generics:
 Generic programming is a way to write functions and data types while making minimal assumptions about the type of data being used. Swift generics create code that does not get specific about underlying data types, allowing for elegant abstractions that produce cleaner code with fewer bugs. It allows you to write a function once and use it on different types.
 Source: https://www.raywenderlich.com/3535703-swift-generics-tutorial-getting-started
 */

//Generic type examples: Array, Dictionary, Optionals, Result(Swift 5 onwards)
enum MagicError: Error {
  case spellFailure
}

func cast(_ spell: String) -> Result<String, MagicError> {
  switch spell {
  case "flowers":
    return .success("💐")
  case "stars":
    return .success("✨")
  default:
    return .failure(.spellFailure)
  }
}

cast("flowers")

//Mutating functions: In swift, classes are reference type whereas structures and enumerations are value types. The properties of value types cannot be modified within its instance methods by default. In order to modify the properties of a value type, you have to use the mutating keyword in the instance method. With this keyword, your method can then have the ability to mutate the values of the properties and write it back to the original structure when the method implementation ends.


//Queue is a generic type with a type argument, Element in its generic argument clause
struct Queue<Element: Equatable> {
    private var elements: [Element] = []
    
    mutating func enqueue(newElement: Element) {
        elements.append(newElement)
    }
    
    mutating func dequeue() -> Element? {
        if let firstElement = elements.first {
            elements.remove(at: 0)
            return firstElement
        }
        return nil
    }
}

var q = Queue<Int>()
q.enqueue(newElement: 0)
q.enqueue(newElement: 1)
print(q)
q.dequeue()
q.enqueue(newElement: 2)
print(q)
print(q.peek())

//Tricky question:
//Extend the Queue type to implement a function isHomogeneous that checks if all elements of the queue are equal. You’ll need to add a type constraint in the Queue declaration to ensure its elements can be checked for equality to each other.
//Answer:
extension Queue {
    func isHomogeneous() -> Bool {
        guard let first = elements.first else {
            return true
        }
        return elements.contains(where: {$0 == first})
    }
}


//Extending a generic type
extension Queue {
    func peek() -> Element? {
        return elements.first
    }
}

//returns list of tuples
func pairs<Key, Value>(from dict:[Key: Value]) -> [(Key, Value)] {
    return Array(dict)
}
let somePairs = pairs(from: ["minimum": 199, "maximum": 299])
let morePairs = pairs(from: [1: "Swift", 2: "Generics", 3: "Rule"])
print(somePairs)
print(morePairs)

//note the conformance to Comparable
func mid<T: Comparable>(array: [T]) -> T? {
    guard !array.isEmpty else {
        return nil
    }
    return array.sorted()[(array.count - 1)/2]
}

//Custom protocols with generics
protocol Summable { static func + (lhs: Self, rhs: Self) -> Self }
extension Int: Summable {}
extension Double: Summable {}
extension String: Summable {}

//Subclassing a generic type
class Box<T> {
    
}
class Gift<T>: Box<T> {
    func wrap() {
        print("Wrap with plain white paper")
    }
}
class Rose {
    
}
class ValentinesBox: Gift<Rose> {
    
}
let box = ValentinesBox()
box.wrap()

//Enums with associated values
enum Reward<T> {
    
    case treasureChest(T)
    case medal
    
    var message: String {
        switch self {
        case .treasureChest(let treasure):
            return "Treasure is \(treasure)"
        case .medal:
            return "Reward is a medal"
        }
    }
}

let message = Reward.treasureChest("💰").message
print(message)
