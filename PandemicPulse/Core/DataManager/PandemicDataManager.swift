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
        healthyElementsCount -= 1
        onCompletion?()
    }

    func spreadInfectionInGroup() {
        let infectedPeoplePositions = generatePositionsOfRandomlyInfectedElements()

        for position in infectedPeoplePositions {
            riskGroup[position.row, position.column].isInfected = true
            healthyElementsCount -= 1
        }
        onCompletion?()
    }

    private func generatePositionsOfRandomlyInfectedElements() -> Set<Position> {
        var infectedElementsPositions: Set<Position> = []
        for (rowNumber, row) in riskGroup.enumerated() {
            for (columnNumber, element) in row.enumerated() where element.isInfected {
                let elementPosition = Position(row: rowNumber, column: columnNumber)
                let elementNeighbors = riskGroup.getNeighborsOfElement(at: elementPosition)
                let healthyNeighbors = elementNeighbors.filter { !$0.element.isInfected }
                let neighborsBeingInfected = healthyNeighbors.getRandomElements(limit: infectionFactor)
                let positionsOfInfectedNeighbors = neighborsBeingInfected.map { $0.position }
                infectedElementsPositions = infectedElementsPositions.union(Set(positionsOfInfectedNeighbors))
            }
        }
        return infectedElementsPositions
    }
}
