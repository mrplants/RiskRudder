//
//  Investment.swift
//  RiskRudder
//
//  Created by Sean Fitzgerald on 7/10/23.
//

import Foundation

enum InvestmentCategory: String, Codable, CaseIterable {
    case stocks = "Stocks"
    case bonds = "Bonds"
    case realEstate = "Real Estate"
    case cash = "Cash"
}

struct Investment: Codable, Identifiable {
    var id = UUID()
    
    var type: InvestmentCategory
    var name: String
    var purchaseValue: Double
    var date: Date
    
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    static func fromData(_ data: Data) -> Investment? {
        return try? JSONDecoder().decode(Investment.self, from: data)
    }
}
