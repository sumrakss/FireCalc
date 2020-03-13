//
//  SettingsData.swift
//  FireCalculator
//
//  Created by Алексей on 11.03.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import Foundation

struct SettingsData {
    
    static var air = true   //  Тип СИЗОД. По-умолчанию ДАСВ
    
    static var valueUnit = true     // Единицы измерения
    
    static var cylinderVolume = 6.8 // Объем баллога
    
    static var airIndex = 1.1          // Коэффициент сжимаемости воздуха
    
    static var airRate = 40.0     // Средний расход воздуха
        
    static var reductionStability = 10.0    // давление воздуха, необходимое для устойчивой работы редуктора
    
    static var airFlow = airIndex * airRate
}


enum UnitType: String {
    case air = "ДАСВ"
    case oxygen = "ДАСК"
}

enum UnitValue: String {
    case kgc = "кгс/см\u{00B2}"
    case mpa = "МПа"
}
