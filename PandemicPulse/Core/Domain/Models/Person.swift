//
//  Person.swift
//  PandemicPulse
//
//  Created by Юрий Степанчук on 24.03.2024.
//

import Foundation

struct Person: Hashable {
    let id = UUID()
    var isInfected: Bool = false
}
