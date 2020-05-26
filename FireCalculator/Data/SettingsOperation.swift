//
//  SettingsOperation.swift
//  FireCalculator
//
//  Created by Алексей on 20.05.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import Foundation

struct SettingsOperations {
	
	private let defaults = UserDefaults.standard
	
	func saveSettings() {
		defaults.set(SettingsData.deviceType.rawValue, forKey: "deviceType")
		defaults.set(SettingsData.measureType.rawValue, forKey: "measureType")
		defaults.set(SettingsData.cylinderVolume, forKey: "cylinderVolume")
		defaults.set(SettingsData.airRate, forKey: "airRate")
		defaults.set(SettingsData.airIndex, forKey: "airIndex")
		defaults.set(SettingsData.reductionStability, forKey: "reductionStability")
		defaults.set(SettingsData.handInputMode, forKey: "handInputMode")
		defaults.set(SettingsData.airSignal, forKey: "airSignal")
		defaults.set(SettingsData.airSignalMode, forKey: "airSignalMode")
		defaults.set(SettingsData.simpleSolution, forKey: "simpleSolution")
		defaults.set(SettingsData.fontSize, forKey: "fontSize")
		defaults.synchronize()
	}
	
	func loadSettings() {
		if let deviceType = DeviceType(rawValue: defaults.string(forKey: "deviceType") ?? "") {
			SettingsData.deviceType = deviceType
		}
		if let measureType = MeasureType(rawValue: defaults.string(forKey: "measureType") ?? "") {
			SettingsData.measureType = measureType
		}
		
		if UserDefaults.standard.object(forKey: "cylinderVolume") != nil {
			SettingsData.cylinderVolume = defaults.double(forKey: "cylinderVolume")
		}
		
		if UserDefaults.standard.object(forKey: "airRate") != nil {
			SettingsData.airRate = defaults.double(forKey: "airRate")
		}
		
		if UserDefaults.standard.object(forKey: "airIndex") != nil {
			SettingsData.airIndex = defaults.double(forKey: "airIndex")
		}
		
		if UserDefaults.standard.object(forKey: "reductionStability") != nil {
			SettingsData.reductionStability = defaults.double(forKey: "reductionStability")
		}
		
		if UserDefaults.standard.object(forKey: "handInputMode") != nil {
			SettingsData.handInputMode = defaults.bool(forKey: "handInputMode")
		}
		
		if UserDefaults.standard.object(forKey: "airSignal") != nil {
			SettingsData.airSignal = defaults.double(forKey: "airSignal")
		}
		
		if UserDefaults.standard.object(forKey: "airSignalMode") != nil {
			SettingsData.airSignalMode = defaults.bool(forKey: "airSignalMode")
		}
		
		if UserDefaults.standard.object(forKey: "simpleSolution") != nil {
			SettingsData.simpleSolution = defaults.bool(forKey: "simpleSolution")
		}
		
		if UserDefaults.standard.object(forKey: "fontSize") != nil {
			SettingsData.fontSize = defaults.double(forKey: "fontSize")
		}
		defaults.synchronize()
	}
	
	
	func resetUserSettings () {
		let dictionary = defaults.dictionaryRepresentation()
		
		dictionary.keys.forEach { key in
			defaults.removeObject(forKey: key)
		}
		defaults.synchronize()
		
		SettingsData.deviceType = DeviceType.air
		SettingsData.measureType = MeasureType.kgc
		SettingsData.cylinderVolume = 6.8
		SettingsData.airIndex = 1.1
		SettingsData.airRate = 40.0
		SettingsData.reductionStability = 10.0
		SettingsData.airSignal = 63
		SettingsData.handInputMode = false
		SettingsData.airSignalMode = true
		SettingsData.simpleSolution = false
		SettingsData.airSignal = 60
	}
}
