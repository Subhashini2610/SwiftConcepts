/*
 Custom operators and precedence groups
 infix: <value>+<value>
 prefix: !<value>
 postfix: <value>!
 ternary: <val> ? <val> : <val>
 Source: https://medium.com/@abhimuralidharan/how-to-create-a-custom-operator-like-operator-in-swift-55953c0c0bf2
 
 */
import Foundation

prefix operator √

prefix func √(lhs: Double) -> Double {
    return sqrt(lhs)
}
print(√81)

infix operator ◉: SquareSumOperatorPrecedence

//note the absence of infix keyword in func declaration
func ◉(lhs: Double, rhs: Double) -> Double {
    return lhs * lhs + rhs * rhs
}
let a = 2.2
let b = 3.3
let squaresum = a ◉ b
print(squaresum)

/*
 Operator precedence: gives some operators high priority than others
 Operator associativity: how operators of the same precedence are grouped together
 Left associativity: v1 + v2+ v3 = (v1 + v2) + v3
 Right associativity: v1 + v2+ v3 = v1 + (v2 + v3)
 If you declare a new operator without specifying a precedence group, it is a member of the DefaultPrecedence precedence group. DefaultPrecedence has no associativity and a precedence immediately higher than TernaryPrecedence.
 */

precedencegroup SquareSumOperatorPrecedence {
    lowerThan: MultiplicationPrecedence
    higherThan: AdditionPrecedence
    associativity: left
    assignment: false
}

//Generics and custom operators
prefix operator ++++

prefix func ++++<T: Numeric>(lhs: T) -> T {
    return lhs * 4
}

print(++++19)
