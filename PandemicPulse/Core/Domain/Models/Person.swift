//
//  Person.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 24.03.2024.
//

import Foundation

protocol Infectable {
    var isInfected: Bool { get set }
}

struct Person: Infectable {
    var isInfected: Bool = false
}
