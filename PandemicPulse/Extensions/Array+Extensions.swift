//
//  Array+Extensions.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 24.03.2024.
//

import Foundation

extension Array {
    func getRandomElements(limit: Int) -> [Element] {
        guard limit > 0 else {
            return []
        }

        let count = Int.random(in: 0 ... limit)
        let shuffledArray = shuffled()

        return Array(shuffledArray.prefix(count))
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array {
    /// Преобразует одномерный массив в приближенную к квадратной матрице или с количеством элементов в подмассивах равным лимиту
    /// - NOTE: Количество элементов в последнем ряду может быть меньше, чем в остальных рядах.
    func splitToSquareMatrixWith(maxElementsInRow limit: Int) -> [[Element]] {
        let calculatedLength = integerPartOfSquareRootRoundedUp()
        let number = calculatedLength <= limit ? calculatedLength : limit
        return split(by: number)
    }

    /// Преобразует одномерный массив в квадратную (или приближенную к квадратной) матрицу.
    /// - NOTE: Количество элементов в последнем ряду может быть меньше, чем в остальных рядах.
    func splitToSquareMatrix() -> [[Element]] {
        let number = integerPartOfSquareRootRoundedUp()
        return split(by: number)
    }

    /// Преобразует одномерный массив в двумерный с заданной длиной подмассива.
    /// - Parameter number: Количество элементов во вложенных подмассивах.
    /// - NOTE: Количество элементов в последнем подмассиве может быть меньше.
    func split(by number: Int) -> [[Element]] {
        guard number > 0 else { return [[Element]]() }

        var result: [[Element]] = []

        for index in stride(from: 0, to: count, by: number) {
            let endIndex = Swift.min(index + number, count)
            let subArray = Array(self[index ..< endIndex])
            result.append(subArray)
        }

        return result
    }

    /// Возвращает округленное в большую сторону значение квадратного корня из размера массива.
    /// - Returns: Округленное в большую сторону значение квадратного корня.
    private func integerPartOfSquareRootRoundedUp() -> Int {
        let squareRoot = sqrt(Double(count))
        return Int(ceil(squareRoot))
    }
}
