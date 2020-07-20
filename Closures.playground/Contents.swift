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
