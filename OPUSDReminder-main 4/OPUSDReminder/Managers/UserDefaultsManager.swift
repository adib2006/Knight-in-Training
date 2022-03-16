//
//  UserDefaultsManager.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 3/9/22.
//

import Foundation

/// Manages values saved in User Defaults.
///
/// Access this class's type properties to reference data stored in User Defaults.
///
/// - Note: Mutating these properties automatically updates User Defaults.
class UserDefaultsManager {
    
    // MARK: - Public
    
    static var hasViewedOnboardingScreen: Bool = get_hasViewedOnboardingScreen() {
        didSet {
            set_hasViewedOnboardingScreen(value: hasViewedOnboardingScreen)
        }
    }
    
    // MARK: - Private
    
    private static let hasViewedOnboardingScreen_key: String = "hasViewedOnboardingScreen_key"
    private static func get_hasViewedOnboardingScreen() -> Bool {
        return UserDefaults.standard.value(forKey: hasViewedOnboardingScreen_key) as? Bool ?? false
    }
    private static func set_hasViewedOnboardingScreen(value: Bool) {
        UserDefaults.standard.setValue(value, forKey: hasViewedOnboardingScreen_key)
    }
}
