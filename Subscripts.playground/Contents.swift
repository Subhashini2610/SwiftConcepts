/*
 Subscripts are used to access information from a collection, sequence and a list in Classes, Structures and Enumerations without using a method.
 subscript(index: Int) -> Element { get set }
 */

//subscripting an array
let array = [1, 2, 3, 5, 8]
print(array[0])
print(array[1..<4])

//subscripting a dictionary
var dictionary = ["male": "I'm a male"]
print(dictionary["male"]!)

class DaysOfWeek {
    private var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "saturday"]
    
    subscript(index: Int) -> String {
        get {
            return days[index]
        }
        set(newValue) {
            self.days[index] = newValue
        }
    }
}

var p = DaysOfWeek()
print(p[0])


struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}

var mat = Matrix(rows: 2, columns: 2)
mat[0, 0] = 2
mat[0, 1] = 3
print(mat[1, 0])
print(mat[0, 1])
