import Foundation
import QuartzCore

// MARK: - BENCHMARK FUNKCE
public class BenchTimer{
    
    public static func measureBlock(closure: () -> Void) -> CFTimeInterval{
        let runCount = 10
        var executionTimes = Array<Double>(repeating: 0.0, count: runCount)
        
        for i in 0..<runCount{
            let startTime = CACurrentMediaTime()
            closure()
            let endTime = CACurrentMediaTime()
            let execTime = endTime - startTime
            executionTimes[i] = execTime
        }
        
        return (executionTimes.reduce(0, +)) / Double(runCount)
    }
    
}

extension CFTimeInterval{
    public var formattedTime: String {
        return self >= 1000 ? String(Int(self)) + "s"
        : self >= 1 ? String(format: "%.3gs", self)
        : self >= 1e-3 ? String(format: "%.3gms", self) //milisekunda
        : self >= 1e-6 ? String(format: "%.3µs", self) //mikrosekunda
        : self < 1e-9 ? "0s"
        : String(format: "%.3gns", self * 1e9)
    }
}

// MARK: - CONSTANT TIME
// Čas je vždy stejný (konstatní) nezávisle na velikosti vstupu

print("CONSTANT TIME\nJe první element v poli 0?\n")

// MARK: - Pole začíná nulou?

func startsWithZero(array: [Int]) -> Bool {
    guard array.count != 0 else {return false}
    return array.first == 0
}

let smallArray = [0,1,2,3]
var execTime = BenchTimer.measureBlock {
    _ = startsWithZero(array: smallArray)
}
print("Small Array: \(execTime)")

let bigArray = Array<Int>(repeating: 0, count: 10_000)
execTime = BenchTimer.measureBlock {
    _ = startsWithZero(array: bigArray)
}
print("Big Array: \(execTime)")

let extraBigArray = Array<Int>(repeating: 0, count: 1_000_000)
execTime = BenchTimer.measureBlock {
    _ = startsWithZero(array: extraBigArray)
}
print("EXTRA BIG Array: \(execTime)")

// MARK: - Generování slovníku
print("\n Generování slovníku \n")

func generateDict(size: Int) -> Dictionary<String, Int> {
    var result = Dictionary<String, Int>()
    
    guard size > 0 else {
        return result
    }
    
    for i in 0..<size{
        let key = String(i)
        result[key] = i
    }
    
    return result
}

let smallDict = generateDict(size: 5)

execTime = BenchTimer.measureBlock {
    let _ = smallDict["4"]
}
print("Small Dict: \(execTime)")

let bigDict = generateDict(size: 500)

execTime = BenchTimer.measureBlock {
    let _ = bigDict["496"]
}
print("BIG Dict: \(execTime)")

let hugeDict = generateDict(size: 50000)

execTime = BenchTimer.measureBlock {
    let _ = hugeDict["4999"]
}
print("HUGE Dict: \(execTime)")


// MARK: - Linear Time
// Čas pro provedení algortimu roste proporciálně v závislosti na velikostu inputu

// Příklad: Velikost vstupu   1_000 -> 1s
//                           10_000 -> 10s
//                          100_000 -> 100s

print("\nLINEAR TIME\nSUMA pole\n")


func generateRandomArray(size: Int, maxValue: UInt32) -> [Int]{
    guard size > 0 else { return [Int]()}
    var result = Array<Int>(repeating: 0, count: size)
    for i in 0..<size{
        result[i] = Int(arc4random_uniform(maxValue))
    }
    return result
}

// MARK: - SUM Pole

func sum(array: [Int]) -> Int{
    var result = 0
    for i in 0..<array.count {
        result += array[i]
    }
    return result
}

let smallIntArray = generateRandomArray(size: 100, maxValue: UInt32.max)
execTime = BenchTimer.measureBlock {
    let _ = sum(array: smallIntArray)
}
print("SMALL SUM: \(execTime.formattedTime)")

let mediumIntArray = generateRandomArray(size: 1_000, maxValue: UInt32.max)
execTime = BenchTimer.measureBlock {
   let _ = sum(array: mediumIntArray)
}
print("MEDIUM SUM: \(execTime.formattedTime)")

let bigIntArray = generateRandomArray(size: 10_000, maxValue: UInt32.max)
execTime = BenchTimer.measureBlock {
    let _ = sum(array: bigIntArray)
}
print("BIG SUM: \(execTime.formattedTime)")

// MARK: - Počet sudých lichých čísel v poli
print("\n Počet sudých lichých")

func countOddEven(array: [Int]) -> (even: UInt, odd: UInt){
    var even: UInt = 0
    var odd: UInt = 0
    
    for elem in array{
        if elem % 2 == 0{
            even += 1
        } else {
            odd += 1
        }
    }
    return (even, odd)
}

execTime = BenchTimer.measureBlock {
    let _ = countOddEven(array: smallIntArray)
}
print("SMALL: \(execTime.formattedTime)")

execTime = BenchTimer.measureBlock {
    let _ = countOddEven(array: mediumIntArray)
}
print("MEDIUM: \(execTime.formattedTime)")

execTime = BenchTimer.measureBlock {
    let _ = countOddEven(array: bigIntArray)
}
print("BIG: \(execTime.formattedTime)")

// MARK: - Quadratic Time
// čas roste jako mocnina vstupu
// Příklad: Velikost vstupu   100 -> 100ms
//                          2_000 -> 40s
//                          4_000 -> 26 MINUT!!!!

// Pokud možno stanžit se úplně vyhnout

//print("\nDva for loopy v sobě procházející každý element\n")
//
//func multTable(size: Int) -> [Int]{
//    var table = [Int]()
//    let array = [Int](1...size)
//
//    for i in 0..<size{
//        for j in 0..<size{
//            let val = array[i] * array[j]
//            table.append(val)
//        }
//    }
//    return table
//}
//
//let sizes = [10, 50, 100]
//
//for size in sizes{
//    execTime = BenchTimer.measureBlock {
//        let _ = multTable(size: size)
//    }
//    print("Velikost \(size): \(execTime.formattedTime)")
//}


// MARK: - RECURSION
// Rekurzivní funkce je taková funkce, která volá sebe sama
// Při každém dalším volání sebe sama se uloží předchozí volání do stacku (lze si představit jako rostoucí pyramidu)
// Až dojde k posledním volání sebe sama tak se vrací hodnota přes jednotlivé volání ve stacku a zároveň se po vrácení hodnoty ze stacku smaže (lze si představit jako klesající pyramidu (přesně naopak než při volání)
// Je potřeba si dát pozor aby nedošlo k přetečení paměti (stack overflow) pokud by volání bylo moc

class Node{
    // Recursive data structure
    var next: Node?
    var value: String
    
    init(value: String){
        self.value = value
    }
}

let node1 = Node(value: "node1")
let node2 = Node(value: "node2")
let node3 = Node(value: "node3")

node1.next = node2
node2.next = node3
node3.next = nil

func parseNode(_ node: Node?){
    guard let node = node else {return}
    print(node.value)
    // rekurzivní volání
    parseNode(node.next)
}

parseNode(node1)


// MARK: - Optimalizovaná verze SUM

// Lineární
func sum(_ n: UInt) -> UInt {
    var result: UInt = 0
    for i in 0 ..< n {
        result += i
    }
    return result
}

// Konstantní
func sumOtimized(_ n: UInt) -> UInt {
    return n * (n + 1) / 2
}


