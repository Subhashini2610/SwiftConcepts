/*
 Predicates
 Source: https://nshipster.com/nspredicate/
 NSArray - filteredArrayUsingPredicate
 NSMutableArray - filterUsingPredicate - replacements are made in place
 NSSet - filteredSetUsingPredicate
 NSMutableSet - filterUsingPredicate - replacements are made in place
 */
import Foundation

@objcMembers class Person: NSObject {
    let firstName: String
    let lastName: String
    let age: Int
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
}

let alice = Person(firstName: "Alice", lastName: "Smith", age: 24)
let bob = Person(firstName: "Bob", lastName: "Jones", age: 27)
let charlie = Person(firstName: "Charlie", lastName: "Smith", age: 33)
let quentin = Person(firstName: "Quentin", lastName: "Alberts", age: 31)
let people: NSArray = [alice, bob, charlie, quentin]

let bobPredicate = NSPredicate(format: "firstName == %@", "Bob")
let smithPredicate = NSPredicate(format: "lastName == %@", "Smith")
let thirtiesPredicate = NSPredicate(format: "age >= 30")

people.filtered(using: bobPredicate)
people.filtered(using: smithPredicate)
people.filtered(using: thirtiesPredicate)

//Substitutions
//%K is variable substitution for key path
let ageIs33Predicate = NSPredicate(format: "%K = %@", "age", "33")
people.filtered(using: ageIs33Predicate)

//$VARIABLE_NAME is a value that can be substituted with NSPredicate -predicateWithSubstitutionVariables
let namesBeginning = NSPredicate(format: "(firstName BEGINSWITH[cd] $letter) OR (lastName BEGINSWITH[cd] $letter)")//c-case insensitive, d-diacritic insensitive
people.filtered(using: namesBeginning.withSubstitutionVariables(["letter": "A"]))

//COMPARISONS: =, ==, <, <=, !=, <>, >, >=, BETWEEN
//<> is not equal to
//1 BETWEEN {0, 33} (or) $INPUT BETWEEN {$LOWER, $UPPER}

//BASIC COMPOUND PREDICATES: OR, AND, NOT

//STRING COMPARISON: BEGINSWITH, CONTAINS, ENDSWITH, LIKE(? is 1 char, * is 0 or more chars), MATCHES(uses regex)

//AGGREGATE OPERATIONS: RELATIONAL OPERATIONS(ANY, SOME, ALL, NONE, IN)
//Eg: ANY children.age < 18
//NONE = NOT (ANY)

//ARRAY OPERATIONS: array[index], array[FIRST], array[LAST], array[SIZE]

//Bool value predicates: TRUEPREDICATE(always evaluates to true), FALSEPREDICATE(always evaluates to false)

//COMPOUND PREDICATE
let compPredicate = NSCompoundPredicate(
    type: .and,
    subpredicates: [
        NSPredicate(format: "age > 25"),
        NSPredicate(format: "firstName = %@", "Quentin")
    ]
)
people.filtered(using: compPredicate)

//BLOCK PREDICATES
let shortNamePredicate = NSPredicate { (evaluatedObject, _) in
    return (evaluatedObject as! Person).firstName.utf16.count <= 5
}
people.filtered(using: shortNamePredicate)

//NSComparisonPredicate
//lhs: The left hand expression.
//rhs: The right hand expression.
//modifier: The modifier to apply. (ANY or ALL)
//type: The predicate operator type.
//options: The options to apply. For no options, pass 0.

/*
 enum NSComparisonPredicate.Operator: UInt {
     case lessThan
     case lessThanOrEqualTo
     case greaterThan
     case greaterThanOrEqualTo
     case equalTo
     case notEqualTo
     case matches
     case like
     case beginsWith
     case endsWith
     case `in`
     case customSelector
     case contains
     case between
 }
 */
