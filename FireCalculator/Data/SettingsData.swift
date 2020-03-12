//
//  SettingsData.swift
//  FireCalculator
//
//  Created by Алексей on 11.03.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import Foundation

struct SettingsData {
    
    static var cylinderVolume = 7.0 // Объем баллога
    
    static var airIndex = 1.1          // Коэффициент сжимаемости воздуха
    
    static var airRate = 40.0     // Средний расход воздуха
    
    static var airFlow = airIndex * airRate
    
    static var reductionStability = 10.0    // давление воздуха, необходимое для устойчивой работы редуктора

}
