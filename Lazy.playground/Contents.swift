/*
 A lazy stored property is a property whose initial value is not calculated until the first time it is used. You indicate a lazy stored property by writing the lazy modifier before its declaration.
 1. The closure associated to the lazy property is executed only if you read that property. So if for some reason that property is not used (maybe because of some decision of the user) you avoid unnecessary allocation and computation.
 2. You can populate a lazy property with the value of a stored property.
 3.  You can use self inside the closure of a lazy property. It will not cause any retain cycles. The reason is that the immediately applied closure {}() is considered @noescape. It does not retain the captured self.
 4. You can’t use lazy with let.(Obvio right?)
 5. You can’t use it with computed properties . Because, a computed property returns the value every time we try to access it after executing the code inside the computation block.
 6. Lazy variables are not initialised atomically and so is not thread safe.
 7. You can use lazy only with members of struct and class.
 Source: https://medium.com/@abhimuralidharan/lazy-var-in-ios-swift-96c75cb8a13a
 */

//Lazy computed variables working on stored properties: Notice the anamoly
class A {

    var firstName = "Subhashini"
    var lastName = "Narayanaswamy"

    lazy var fullName: String = {
        return "\(firstName) \(lastName)"
    }()

}
let a = A()
print(a.fullName)
a.firstName = "NewName"
print(a.fullName)
