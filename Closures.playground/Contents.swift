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
