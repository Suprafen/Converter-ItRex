//
//  Model.swift
//  CurrencyConverter
//
//  Created by Ivan Pryhara on 9.02.22.
//

import Foundation

enum CountryCode: String, CaseIterable {
    case BYN = "🇧🇾 BYN"
    case EUR = "🇪🇺 EUR"
    case USD = "🇺🇸 USD"
    case HUF = "🇭🇺 HUF"
}

struct Currency{
    
    let code: CountryCode
    var exchangeRate: [CountryCode : Double]
    
    static let availableCurrencies: [Currency] = [
        Currency(code: .BYN, exchangeRate: [.BYN : 1.0, .USD : 0.39, .EUR : 0.34, .HUF : 120.31]),
        Currency(code: .USD, exchangeRate: [.USD : 1.0, .BYN : 2.7, .EUR : 0.88, .HUF : 309.63]),
        Currency(code: .EUR, exchangeRate: [.EUR : 1.0, .USD : 1.14, .BYN : 2.94, .HUF : 353.36]),
        Currency(code: .HUF, exchangeRate: [.HUF : 1.0, .USD : 0.0032, .EUR : 0.0028, .BYN: 0.0083])
    ]
}

extension Currency: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
    
    static func ==(rhs: Currency, lhs: Currency) -> Bool {
        rhs.code == lhs.code
    }
}
