//
//  PandemicDataManager.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 24.03.2024.
//

import Foundation

protocol AppDataManager {
    var onCompletion: (() -> Void)? { get set }

    func getCurrentRiskGroup() -> ThreadSafeMatrix<Infectable>
    func getCurrentHealthyElementsCount() -> Int
    func infectElement(at: Position)
    func spreadInfectionInGroup()
}

final class PandemicDataManager: AppDataManager {
    private let riskGroup: ThreadSafeMatrix<Infectable>
    private let infectionFactor: Int

    private var healthyElementsCount: Int
    private var potentialInfectionSpreadersPositions: Set<Position> = []

    var onCompletion: (() -> Void)?

    init(riskGroup: ThreadSafeMatrix<Infectable>, infectionFactor: Int) {
        self.riskGroup = riskGroup
        self.infectionFactor = infectionFactor
        healthyElementsCount = riskGroup.countElements
    }

    func getCurrentRiskGroup() -> ThreadSafeMatrix<Infectable> {
        return riskGroup
    }

    func getCurrentHealthyElementsCount() -> Int {
        return healthyElementsCount
    }

    func infectElement(at position: Position) {
        riskGroup[position.row, position.column].isInfected = true
        potentialInfectionSpreadersPositions.insert(position)
        healthyElementsCount -= 1
        onCompletion?()
    }

    func spreadInfectionInGroup() {
        let justInfectedPeoplePositions = generatePositionsOfRandomlyInfectedElements()

        for position in justInfectedPeoplePositions {
            // Точечно "инфицируем" полученный элемент
            riskGroup[position.row, position.column].isInfected = true
            // Уменьшаем счетчик здоровых элементов
            healthyElementsCount -= 1
        }
        // Добавляем позиции только что зараженных элементов в множество потенциальных распространителей инфекции
        potentialInfectionSpreadersPositions = potentialInfectionSpreadersPositions.union(justInfectedPeoplePositions)
        onCompletion?()
    }

    /// Генерирует рандомное множество  элементов из здоровых элементов, соседствующих с инфицированными.
    /// Удаляет из множества потенциальных распростарнителей инфекции - тех, у кого не здоровых соседей.
    private func generatePositionsOfRandomlyInfectedElements() -> Set<Position> {
        var newInfectionSpreaders: Set<Position> = []

        for position in potentialInfectionSpreadersPositions {
            // Находим всех здоровых соседей этой позиции
            let elementNeighbors = riskGroup.getNeighborsOfElement(at: position)
            // Получаем всех здоровых соседей
            let healthyNeighbors = elementNeighbors.filter { !$0.element.isInfected }
            // Если здоровых соседей (котрых потенциально можно заразить) нет - удалить элемент из множества
            if healthyNeighbors.isEmpty {
                potentialInfectionSpreadersPositions.remove(position)
                // Если здоровые соседи есть
            } else {
                // Рандомно выбираем тех из них, кто будет заражен (не превышая установленный infectionFactor)
                let neighborsBeingInfected = healthyNeighbors.getRandomElements(limit: infectionFactor)
                // Получаем массив позиций тех, кто будет заражен
                let positionsOfInfectedNeighbors = neighborsBeingInfected.map { $0.position }
                // Сохраняем позиции тех, кто будет заражен во временный контейнер (множество сразу удалит дубликаты)
                newInfectionSpreaders = newInfectionSpreaders.union(Set(positionsOfInfectedNeighbors))
            }
        }
        return newInfectionSpreaders
    }
}
