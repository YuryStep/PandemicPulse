//
//  MonitorViewController.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 24.03.2024.
//

import UIKit

protocol MonitorViewProtocol: AnyObject {}

final class MonitorViewController: UIViewController {
    var presenter: MonitorPresenterProtocol!

    lazy var groupOfPeople = {
        var group = [Infectable]()
        for _ in 0...100_000 {
            group.append(Person())
        }
        return ThreadSafeMatrix(group)
    }()

    lazy var dataManager = PandemicDataManager(riskGroup: groupOfPeople, infectionFactor: 8)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        dataManager.infectPerson(at: 2, column: 2)
        dataManager.infectPerson(at: 0, column: 0)
        dataManager.infectPerson(at: 3, column: 4)
        dataManager.infectPerson(at: 4, column: 2)
        dataManager.infectPerson(at: 5, column: 0)
        dataManager.infectPerson(at: 6, column: 4)
        dataManager.infectPerson(at: 7, column: 2)
        dataManager.infectPerson(at: 8, column: 0)
        dataManager.infectPerson(at: 9, column: 4)
        dataManager.infectPerson(at: 10, column: 2)
        dataManager.infectPerson(at: 3, column: 7)
        dataManager.infectPerson(at: 3, column: 4)

        dataManager.spreadInfectionInGroup()
    }
}

extension MonitorViewController: MonitorViewProtocol {}
