//
//  AppData.swift
//  FireCalculator
//
//  Created by Алексей on 11.03.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import Foundation


struct AppData {
    // Очаг найден true/false
    var firePlace = false
    // Сложные условия true/false
    var hardWork = false
    // Время включения
    var enterTime = Date()
    // Время у очага
    var fireTime = Date()
    // Давление при включении
    var enterData = [Double]()
    // Давление у очага
    var hearthData = [Double]()
    // Падение давления в звене
    var fallPressure = [Double]()
}


