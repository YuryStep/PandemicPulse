//
//  ThreadSafeMatrix.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 24.03.2024.
//

import Foundation

/// Двумерный потокобезопасный массив.
/// - NOTE: Потокобезопасность обеспечивается за счет использования GCD ConcurrentQueue
public final class ThreadSafeMatrix<Element> {

    private var array: [[Element]]
    private let threadSafeConcurrentQueue = DispatchQueue(label: "com.YuryStep.github", attributes: .concurrent)

    /// Создает двумерный массив, приближенный по распределению элементов к квадратной матрице
    /// - Parameter array: Массив, который необходимо преобразовать в двумерный
    init(_ array: [Element] = [Element]()) {
        self.array = array.splitToSquareMatrix()
    }

    /// Создает двумерный массив с заданным количеством элементов  в ряду
    /// - Parameters:
    ///   - array: Массив, который необходимо преобразовать в двумерный
    ///   - elementsInRow: Количество элементов в ряду
    init(_ array: [Element] = [Element](), elementsInRow: Int) {
        self.array = array.split(by: elementsInRow)
    }
}

// MARK: Subscript
extension ThreadSafeMatrix {
    subscript(row: Int, column: Int) -> Element {
        get {
            threadSafeConcurrentQueue.sync {
                self.array[row][column]
            }
        }
        set {
            threadSafeConcurrentQueue.async(flags: .barrier) {
                self.array[row][column] = newValue
            }
        }
    }
}

extension ThreadSafeMatrix: CustomStringConvertible {
    public var description: String {
        threadSafeConcurrentQueue.sync { return array.description }
    }
}

// MARK: Properties
extension ThreadSafeMatrix {

    var first: [Element]? {
        threadSafeConcurrentQueue.sync { return array.first }
    }

    var last: [Element]? {
        threadSafeConcurrentQueue.sync { return array.last }
    }

    var countRows: Int {
        threadSafeConcurrentQueue.sync { return array.count }
    }

    var countColumns: Int { // TODO: CHECK to delete
        threadSafeConcurrentQueue.sync { return array.first?.count ?? 0 }
    }

    var isEmpty: Bool {
        threadSafeConcurrentQueue.sync { return array.isEmpty }
    }
}

// MARK: Regular methods
extension ThreadSafeMatrix {

    func first(where predicate: ([Element]) -> Bool) -> [Element]? {
        threadSafeConcurrentQueue.sync { return array.first(where: predicate) }
    }

    func last(where predicate: ([Element]) -> Bool) -> [Element]? {
        threadSafeConcurrentQueue.sync { return array.last(where: predicate) }
    }

//    func filter(_ isIncluded: @escaping ([Element]) -> Bool) -> ThreadSafeMatrix {
//        threadSafeConcurrentQueue.sync { return ThreadSafeMatrix(array.filter(isIncluded)) }
//    }

    func index(where predicate: ([Element]) -> Bool) -> Int? {
        threadSafeConcurrentQueue.sync { return array.firstIndex(where: predicate) }
    }

//    func sorted(by areInIncreasingOrder: ([Element], [Element]) -> Bool) -> ThreadSafeMatrix {
//        threadSafeConcurrentQueue.sync { return ThreadSafeMatrix(array.sorted(by: areInIncreasingOrder)) }
//    }

    func map<TransformedElement>(_ transform: @escaping ([Element]) -> TransformedElement) -> [TransformedElement] {
        threadSafeConcurrentQueue.sync { return array.map(transform) }
    }

    func compactMap<TransformedElement>(_ transform: ([Element]) -> TransformedElement?) -> [TransformedElement] {
        threadSafeConcurrentQueue.sync { return array.compactMap(transform) }
    }

    func reduce<TransformedElement>(_ initialResult: TransformedElement, _ nextPartialResult: @escaping (TransformedElement, [Element]) -> TransformedElement) -> TransformedElement {
        threadSafeConcurrentQueue.sync { return array.reduce(initialResult, nextPartialResult) }
    }

    func reduce<TransformedElement>(into initialResult: TransformedElement, _ updateAccumulatingResult: @escaping (inout TransformedElement, [Element]) -> Void) -> TransformedElement {
        threadSafeConcurrentQueue.sync { return array.reduce(into: initialResult, updateAccumulatingResult) }
    }

    func forEach(_ body: ([Element]) -> Void) {
        threadSafeConcurrentQueue.sync { return array.forEach(body) }
    }

    func contains(where predicate: ([Element]) -> Bool) -> Bool {
        threadSafeConcurrentQueue.sync { return array.contains(where: predicate) }
    }

    func allSatisfy(_ predicate: ([Element]) -> Bool) -> Bool {
        threadSafeConcurrentQueue.sync { return array.allSatisfy(predicate) }
    }
}

// MARK: Mutating methods
extension ThreadSafeMatrix {

    func append(_ element: [Element]) {
        threadSafeConcurrentQueue.async(flags: .barrier) {
            self.array.append(element)
        }
    }

    func insert(_ element: [Element], at index: Int) {
        threadSafeConcurrentQueue.async(flags: .barrier) {
            self.array.insert(element, at: index)
        }
    }

    func remove(at index: Int, completion: (([Element]) -> Void)? = nil) {
        threadSafeConcurrentQueue.async(flags: .barrier) {
            let element = self.array.remove(at: index)
            DispatchQueue.main.async { completion?(element) }
        }
    }

    func remove(where predicate: @escaping ([Element]) -> Bool, completion: (([[Element]]) -> Void)? = nil) {
        var elements = [[Element]]()
        threadSafeConcurrentQueue.async(flags: .barrier) {
            while let index = self.array.firstIndex(where: predicate) {
                elements.append(self.array.remove(at: index))
            }
            DispatchQueue.main.async { completion?(elements) }
        }
    }

    func removeAll(completion: (([[Element]]) -> Void)? = nil) {
        threadSafeConcurrentQueue.async(flags: .barrier) {
            let elements = self.array
            self.array.removeAll()
            DispatchQueue.main.async { completion?(elements) }
        }
    }
}
