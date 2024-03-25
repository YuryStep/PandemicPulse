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

    private var matrix: [[Element]]
    private let threadSafeConcurrentQueue = DispatchQueue(label: "com.YuryStep.github", attributes: .concurrent)

    /// Создает двумерный массив, приближенный по распределению элементов к квадратной матрице
    /// - Parameter matrix: Массив, который необходимо преобразовать в двумерный
    init(_ array: [Element] = [Element]()) {
        self.matrix = array.splitToSquareMatrix()
    }

    /// Создает двумерный массив с заданным количеством элементов  в ряду
    /// - Parameters:
    ///   - matrix: Массив, который необходимо преобразовать в двумерный
    ///   - elementsInRow: Количество элементов в ряду
    init(_ array: [Element] = [Element](), elementsInRow: Int) {
        self.matrix = array.split(by: elementsInRow)
    }
}

// MARK: Subscript
extension ThreadSafeMatrix {
    subscript(row: Int, column: Int) -> Element {
        get {
            threadSafeConcurrentQueue.sync {
                self.matrix[row][column]
            }
        }
        set {
            threadSafeConcurrentQueue.async(flags: .barrier) {
                self.matrix[row][column] = newValue
            }
        }
    }
}

extension ThreadSafeMatrix: CustomStringConvertible {
    public var description: String {
        threadSafeConcurrentQueue.sync { return matrix.description }
    }
}

// MARK: - Sequence conformance
extension ThreadSafeMatrix: Sequence {

    public func makeIterator() -> AnyIterator<[Element]> {
        var currentIndex = 0

        return AnyIterator {
            var result: [Element]?

            self.threadSafeConcurrentQueue.sync {
                guard currentIndex < self.countRows else {
                    return
                }

                result = self.matrix[currentIndex]
                currentIndex += 1
            }

            return result
        }
    }
}

// MARK: Properties
extension ThreadSafeMatrix {

    var first: [Element]? {
        threadSafeConcurrentQueue.sync { return matrix.first }
    }

    var last: [Element]? {
        threadSafeConcurrentQueue.sync { return matrix.last }
    }

    var countRows: Int {
        threadSafeConcurrentQueue.sync { return matrix.count }
    }

    var countColumns: Int { // TODO: CHECK to delete
        threadSafeConcurrentQueue.sync { return matrix.first?.count ?? 0 }
    }

    var isEmpty: Bool {
        threadSafeConcurrentQueue.sync { return matrix.isEmpty }
    }
}

// MARK: Regular methods
extension ThreadSafeMatrix {

    func first(where predicate: ([Element]) -> Bool) -> [Element]? {
        threadSafeConcurrentQueue.sync { return matrix.first(where: predicate) }
    }

    func last(where predicate: ([Element]) -> Bool) -> [Element]? {
        threadSafeConcurrentQueue.sync { return matrix.last(where: predicate) }
    }

//    func filter(_ isIncluded: @escaping ([Element]) -> Bool) -> ThreadSafeMatrix {
//        threadSafeConcurrentQueue.sync { return ThreadSafeMatrix(matrix.filter(isIncluded)) }
//    }

    func index(where predicate: ([Element]) -> Bool) -> Int? {
        threadSafeConcurrentQueue.sync { return matrix.firstIndex(where: predicate) }
    }

//    func sorted(by areInIncreasingOrder: ([Element], [Element]) -> Bool) -> ThreadSafeMatrix {
//        threadSafeConcurrentQueue.sync { return ThreadSafeMatrix(matrix.sorted(by: areInIncreasingOrder)) }
//    }

    func map<TransformedElement>(_ transform: @escaping ([Element]) -> TransformedElement) -> [TransformedElement] {
        threadSafeConcurrentQueue.sync { return matrix.map(transform) }
    }

    func compactMap<TransformedElement>(_ transform: ([Element]) -> TransformedElement?) -> [TransformedElement] {
        threadSafeConcurrentQueue.sync { return matrix.compactMap(transform) }
    }

    func reduce<TransformedElement>(_ initialResult: TransformedElement, _ nextPartialResult: @escaping (TransformedElement, [Element]) -> TransformedElement) -> TransformedElement {
        threadSafeConcurrentQueue.sync { return matrix.reduce(initialResult, nextPartialResult) }
    }

    func reduce<TransformedElement>(into initialResult: TransformedElement, _ updateAccumulatingResult: @escaping (inout TransformedElement, [Element]) -> Void) -> TransformedElement {
        threadSafeConcurrentQueue.sync { return matrix.reduce(into: initialResult, updateAccumulatingResult) }
    }

    func forEach(_ body: ([Element]) -> Void) {
        threadSafeConcurrentQueue.sync { return matrix.forEach(body) }
    }

    func contains(where predicate: ([Element]) -> Bool) -> Bool {
        threadSafeConcurrentQueue.sync { return matrix.contains(where: predicate) }
    }

    func allSatisfy(_ predicate: ([Element]) -> Bool) -> Bool {
        threadSafeConcurrentQueue.sync { return matrix.allSatisfy(predicate) }
    }
}

// MARK: Mutating methods
extension ThreadSafeMatrix {

    func append(_ element: [Element]) {
        threadSafeConcurrentQueue.async(flags: .barrier) {
            self.matrix.append(element)
        }
    }

    func insert(_ element: [Element], at index: Int) {
        threadSafeConcurrentQueue.async(flags: .barrier) {
            self.matrix.insert(element, at: index)
        }
    }

    func remove(at index: Int, completion: (([Element]) -> Void)? = nil) {
        threadSafeConcurrentQueue.async(flags: .barrier) {
            let element = self.matrix.remove(at: index)
            DispatchQueue.main.async { completion?(element) }
        }
    }

    func remove(where predicate: @escaping ([Element]) -> Bool, completion: (([[Element]]) -> Void)? = nil) {
        var elements = [[Element]]()
        threadSafeConcurrentQueue.async(flags: .barrier) {
            while let index = self.matrix.firstIndex(where: predicate) {
                elements.append(self.matrix.remove(at: index))
            }
            DispatchQueue.main.async { completion?(elements) }
        }
    }

    func removeAll(completion: (([[Element]]) -> Void)? = nil) {
        threadSafeConcurrentQueue.async(flags: .barrier) {
            let elements = self.matrix
            self.matrix.removeAll()
            DispatchQueue.main.async { completion?(elements) }
        }
    }
}

extension ThreadSafeMatrix {

    func getNeighborsOfElement(at position: Position) -> [(element: Element, position: Position)] {
        guard matrix[safe: position.row]?[safe: position.column] != nil else {
            // Здесь следует выбрасывать ошибку, если элемент не существует по указанной позиции
            fatalError("Element at position \(position) does not exist")
        }
        let rows = matrix.count
        let columns = matrix[0].count
        var neighbors = [(Element, Position)]()

        let horizontalOffsets = [(0, 1), (0, -1)]
        let verticalOffsets = [(1, 0), (-1, 0)]
        let diagonalOffsets = [(1, 1), (-1, 1), (1, -1), (-1, -1)]

        for (rowOffset, columnOffset) in horizontalOffsets + verticalOffsets + diagonalOffsets {
            let neighborRow = position.row + rowOffset
            let neighborColumn = position.column + columnOffset

            // Проверка границ матрицы
            if neighborRow >= 0, neighborRow < rows, neighborColumn >= 0, neighborColumn < columns {
                // Проверка наличия элемента в матрице
                if let neighbor = matrix[safe: neighborRow]?[safe: neighborColumn] {
                    let neighborPosition = Position(row: neighborRow, column: neighborColumn)
                    neighbors.append((neighbor, neighborPosition))
                }
            }
        }
        return neighbors
    }
}
