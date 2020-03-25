//
//  SettingsData.swift
//  FireCalculator
//
//  Created by Алексей on 11.03.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import Foundation

struct SettingsData {
    //  Тип СИЗОД. По-умолчанию ДАСВ
    static var air = true
    // Единицы измерения. По-умолчанию кгс/см2
    static var valueUnit = true
    // Объем баллога
    static var cylinderVolume = 6.8
    // Коэффициент сжимаемости воздуха
    static var airIndex = 1.1
    // Средний расход воздуха
    static var airRate = 40.0
	// давление воздуха, необходимое для устойчивой работы редуктора
    static var reductionStability = 10.0
    
    static var airFlow = airIndex * airRate
}


//enum UnitType: String {
//    case air = "ДАСВ"
//    case oxygen = "ДАСК"
//}
//
//enum UnitValue: String {
//    case kgc = "кгс/см\u{00B2}"
//    case mpa = "МПа"
//}
