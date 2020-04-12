//
//  UserSettings.swift
//  FireCalculator
//
//  Created by Алексей on 12.04.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import Foundation

final class UserSettings {
	static var ballon: Double! {
		get {
			return UserDefaults.standard.double(forKey: "ballon")
		}
		
		set {
			let defaults = UserDefaults.standard
			if let bal = newValue {
				defaults.set(bal, forKey: "ballon")
			}
		}
	}
}
