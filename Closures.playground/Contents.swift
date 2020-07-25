//source: https://www.programiz.com/swift-programming/closures
import Foundation

let simpleClosure = { print("Closure executing") }
simpleClosure()

let closureWithParam: (String) -> Void = {
    name in
    print(name)
}
closureWithParam("sample test")

let returnClosure: ((String) -> String) = {
    text in
    return "This is modified text: \(text)"
}
print(returnClosure)//take note
print(returnClosure("return closure"))

//Closure as function parameter
func simpleFunction(closure: (() -> Void)) {
    print("simple function")
    closure()
}
simpleFunction(closure: {
    print("closure executing")
})
simpleFunction {
    print("trailing closure")
}

//@Autoclosure
func someSimpleFunction(someClosure: @autoclosure () -> (), msg: String) {
    print(msg)
    someClosure()
}
someSimpleFunction(someClosure: (print("Closure is executing")), msg: "Message")

//Escaping closure
func webServiceCall(completion: @escaping (() -> Void)) {
    print("inside web service call")
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        completion()
    }
}
webServiceCall {
    print("web service call result obtained")
}

//Escaping closure - need for it: The following will create an error - just to demonstrate
/*
func escapingFunc(completion: () -> Void) {
    print("inside escaping func")
    DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
        completion()
    }
}
escapingFunc {
    print("demo of escaping func")
}
*/

//Tricky question:
var counter = 0
//Web service call keeps making the call until the response is true
func repeatedWebServiceCall(completion: @escaping (() -> Void)) {
    print("inside web service call")
    counter += 1
    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
        print("inside async after")
        if counter > 3 {
            completion()
        } else {
            print("counter: \(counter); calling again")
            repeatedWebServiceCall(completion: completion)
        }
        
    }
}
repeatedWebServiceCall {
    print("finally done!!")
}

//Capture lists and ref cycles
//Like objects, closures are also ref types and causes cycles
//Class holds a ref of closure and if self is used inside closure, it causes strong ref cycles (cyclic dependency). To avoid this, weak self is used.
var x = 5
var y = 5
let someClosure = { [x] in //here x is capture list (so captured by value), y is not in capture list, so its captured by ref
    print("\(x) \(y)")
}
x = 6
y = 6
someClosure()//prints 5 6 (x is what it was at the time of capture)
print("\(x) \(y)")//prints 6 6
