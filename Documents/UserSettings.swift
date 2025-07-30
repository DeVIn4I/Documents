//
//  UserSettings.swift
//  Documents
//
//  Created by Razumov Pavel on 30.07.2025.
//

import UIKit
import KeychainSwift

final class UserSettings {
    
    static let shared = UserSettings()
    
    private init() {
        userDefaults.register(defaults: [ascendingSortKey: true])
    }
    
    private let keychain = KeychainSwift()
    private let passwordKey = "password"
    
    private let userDefaults = UserDefaults.standard
    private let ascendingSortKey = "ascendingSort"
    
    func isAscendingSort() -> Bool {
        userDefaults.bool(forKey: ascendingSortKey)
    }
    
    func setAscendingSort(_ ascendingSort: Bool) {
        userDefaults.set(ascendingSort, forKey: ascendingSortKey)
    }
    
    func setPassword(_ password: String) {
        keychain.set(password, forKey: passwordKey)
    }
    
    func getPassword() -> String? {
        keychain.get(passwordKey)
    }
    
    func clearPassword() {
        keychain.delete(passwordKey)
    }
}
