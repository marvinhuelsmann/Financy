//
//  CurrencyHandler.swift
//  Financy
//
//  Created by Marvin Hülsmann on 10.03.23.
//

import Foundation

struct CurrencyLibary {
    
    var avaibleCurrencies: [String: String] = [
        "currency.euro" : "€", "currency.pounds" : "£", "currency.dollar" : "$"
    ]
    
    func getAvaibleCurrencies() -> [String: String] {
        return avaibleCurrencies
    }
    
    func getSpecificIcon() -> String {
        return getCurrencyIcon(name: SettingsView().currency)
    }
    
    /// Return the currency icon from the currency translation name
    /// - Parameter name: TranslationKey to return the currency icon
    /// - Returns: Currency Icon
    func getCurrencyIcon(name: String) -> String {
        for currency in avaibleCurrencies {
            if currency.key == name {
                return currency.value
            }
        }
        return "€"
    }
    
}
