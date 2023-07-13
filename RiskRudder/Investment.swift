//
//  Investment.swift
//  RiskRudder
//
//  Created by Sean Fitzgerald on 7/10/23.
//

import Foundation

// Enum to represent different categories of investments.
enum InvestmentCategory: String, Codable, CaseIterable {
    case stocks = "Stocks"
    case bonds = "Bonds"
    case realEstate = "Real Estate"
    case cash = "Cash"
}

// Struct to represent an investment.
struct Investment: Codable, Identifiable {
    // Unique identifier for each investment.
    var id = UUID()
    
    // Type of investment (e.g., stocks, bonds).
    var type: InvestmentCategory

    // Name of the investment.
    var name: String

    // The value at which the investment was purchased.
    var purchaseValue: Double

    // The date when the investment was made.
    var date: Date
    
    // Function to convert an Investment object into a Data object.
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    // Function to create an Investment object from a Data object.
    static func fromData(_ data: Data) -> Investment? {
        return try? JSONDecoder().decode(Investment.self, from: data)
    }
}
