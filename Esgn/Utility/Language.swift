//
//  Language.swift
//  iOTalkEGG
//
//  Created by Somjintana K. on 13/01/2016.
//  Copyright © 2016 Appsynth. All rights reserved.
//

import UIKit

enum LanguageType: Int {
    case th,en
}

class Language: NSObject {
    
    static let current: Language = Language()
    
    var language: LanguageType = .th
    
    func saveLanguage() {
        
        UserDefaults.standard.set(language.rawValue, forKey: "language")
        UserDefaults.standard.synchronize()
    }
    
    func loadLanguage() {
        
        if let lang: Int = UserDefaults.standard.object(forKey: "language") as? Int {
            language = LanguageType(rawValue: lang)!
        }
    }
}

class Localized: NSObject {
    
    static func forKey(_ key: String) -> String {
        
        if Language.current.language == .th {
            return Bundle.main.localizedString(forKey: key, value: nil, table: "th_Localizable")
        }
        
        return NSLocalizedString(key, comment: "Localizable")
    }
}
