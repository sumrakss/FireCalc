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
	
	var pickerComponents = [String]()    // Содержимое pickerview
	
	mutating func generatePickerData() {
		var value = 300.0
        if SettingsData.valueUnit {
            while value >= 100 {
                pickerComponents.append(String(Int(value)))
                value -= 5
            }
        }
		
		if !SettingsData.valueUnit {
			value = 30
			while value >= 10 {
				pickerComponents.append(String(value))
				value -= 0.5
			}
        }
	}
}


