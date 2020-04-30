//
//  SettingsData.swift
//  FireCalculator
//
//  Created by Алексей on 11.03.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import Foundation


// Типы дыхательного аппарата
enum DeviceType: String {
	case air
	case oxigen
}


// Единицы измерения расчетов
enum MeasureType: String {
	case kgc
	case mpa
}


class SettingsData {
	
    //  Тип СИЗОД. По-умолчанию ДАСВ
	static var deviceType = DeviceType.air
    // Единицы измерения.
	static var measureType = MeasureType.kgc
    // Объем баллога
	static var cylinderVolume = 6.8
    // Коэффициент сжимаемости воздуха
    static var airIndex = 1.1
    // Средний расход воздуха
    static var airRate = 40.0
	// давление воздуха, необходимое для устойчивой работы редуктора
    static var reductionStability = 10.0
	// Ручной ввод давления (иначе испльзутся picker)
	static var handInputMode = false
    
	static var airFlow: Double {
		get {
			switch deviceType {
				case .air:
					return airIndex * airRate
				case .oxigen:
					return SettingsData.measureType == .kgc ? 2.0 : 0.2
			}
		}
	}
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

	func generatePickerData() {
		var value = 300.0
		switch SettingsData.measureType {
			case .kgc:
				while value >= 100 {
					pickerComponents.append(String(Int(value)))
					value -= 5
				}
			case .mpa:
				value = 30
				while value >= 10 {
					pickerComponents.append(String(value))
					value -= 0.5
				}
		}
	}
	
//	func encode(with coder: NSCoder) {
//		coder.encode(SettingsData.deviceType, forKey: "deviceType")
//	}
//	
//	required init?(coder: NSCoder) {
//		SettingsData.deviceType = DeviceType(rawValue: coder.decodeObject(forKey: "deviceType") as! String) ?? DeviceType.air
//	}
}
