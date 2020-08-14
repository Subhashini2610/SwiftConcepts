/*
 Dynamic features:
 1. dynamic member lookup
 2. KVC
 */

@dynamicMemberLookup
struct Person {
    subscript (dynamicMember member: String) -> String {
        let properties = ["name": "Taylor Swift", "city": "Nashville"]
        return properties[member] ?? ""
    }
    
    subscript (dynamicMember member: String) -> Int {
        let properties = ["age": 26, "height": 178]
        return properties[member, default: 0]
    }
}
//overloads also possible
let taylor = Person()
let name: String = taylor.name
let age: Int = taylor.age
print("\(name) \(age)")
//print(taylor.favoriteIcecream) //will create error
//this makes properties access safe, but not functions/methods
