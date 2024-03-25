//
//  PandemicDataManager.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 24.03.2024.
//

import Foundation

protocol AppDataManager {
    func getCurrentRiskGroupState() -> ThreadSafeMatrix<Infectable>
    func infectElement(atRow: Int, column: Int)
    func spreadInfectionInGroup()
}

class PandemicDataManager: AppDataManager {

    private let riskGroup: ThreadSafeMatrix<Infectable>
    private let infectionFactor: Int

    var onCompletion: (() -> Void)?

    init(riskGroup: ThreadSafeMatrix<Infectable>, infectionFactor: Int) {
        self.riskGroup = riskGroup
        self.infectionFactor = infectionFactor
    }

    func getCurrentRiskGroupState() -> ThreadSafeMatrix<Infectable> {
        return riskGroup
    }

    func infectElement(atRow row: Int, column: Int) {
        riskGroup[row, column].isInfected = true
        onCompletion?()
    }

    func spreadInfectionInGroup() {
        let infectedPeoplePositions = generatePositionsOfRandomlyInfectedElements()

        infectedPeoplePositions.forEach { position in
            riskGroup[position.row, position.column].isInfected = true
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
