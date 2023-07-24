//
//  InvestmentManager.swift
//  RiskRudder
//
//  Created by Sean Fitzgerald on 7/10/23.
//

import Foundation

// Manages investment-related tasks in the RiskRudder app.
class InvestmentManager: ObservableObject {
    // Array containing all available investment categories.
    static let investmentCategories = InvestmentCategory.allCases.map({ $0.rawValue })
    
    // Sum of all investment purchaseValues
    var netInvestmentPurchaseValue: Double {
        get {
            return investments.map{ $0.purchaseValue }.reduce(0, +)
        }
    }
    
    // Calculate investment summary
    var investmentSummary: (Double, Double, Double, Double) {
        get {
            var portfolio = (0.0, 0.0, 0.0, 0.0)
            for investment in investments {
                switch investment.type {
                case .cash:
                    portfolio.0 += investment.purchaseValue
                case .bonds:
                    portfolio.1 += investment.purchaseValue
                case .realEstate:
                    portfolio.2 += investment.purchaseValue
                case .stocks:
                    portfolio.3 += investment.purchaseValue
                }
            }
            let sum = (portfolio.0 + portfolio.1 + portfolio.2 + portfolio.3)
            portfolio.0 = portfolio.0 / sum
            portfolio.1 = portfolio.1 / sum
            portfolio.2 = portfolio.2 / sum
            portfolio.3 = portfolio.3 / sum
            
            return portfolio
        }
    }
    
    // Published property to hold all investments. Saving to User Defaults when it's updated.
    @Published var investments = [Investment]() {
        didSet {
            let data = try? JSONEncoder().encode(investments)
            UserDefaults.standard.set(data, forKey: "investments")
        }
    }
    
    /// Initializer fetches investments from User Defaults.
    init() {
        fetchInvestments()
    }
    
    /// Fetches investment data from User Defaults and decodes it into 'Investment' instances.
    private func fetchInvestments() {
        let data = UserDefaults.standard.data(forKey: "investments")
        let investments = try? JSONDecoder().decode([Investment].self, from: data ?? Data())
        self.investments = investments ?? []
    }
    
    /// Adds an investment to the list.
    /// - Parameters:
    ///   - name: The name of the investment.
    ///   - category: The category of the investment.
    ///   - purchaseValue: The purchase value of the investment.
    ///   - date: The date of the investment.
    ///   - id: The unique identifier for the investment. If not provided, a new UUID is generated.
    func addInvestment(name:String, category: String, purchaseValue: Double, date: Date, id:UUID? = nil) {
        let newId = id ?? UUID()
        let investment = Investment(id: newId, type: InvestmentCategory(rawValue: category)!, name: name, purchaseValue: purchaseValue, date: date)
        investments.append(investment)
    }

    func EditInvestment(name:String, category: String, purchaseValue: Double, date: Date, id:UUID) {
        let changedInvestment = Investment(id: id, type: InvestmentCategory(rawValue: category)!, name: name, purchaseValue: purchaseValue, date: date)
        if let index = self.investments.firstIndex(where: {investment in
            investment.id == id
        }) {
            investments[index] = changedInvestment
        }
    }

    /// Removes an investment from the list.
    /// - Parameter id: The unique identifier for the investment to remove.
    func removeInvestments(with id: UUID) {
        investments = investments.filter({ $0.id != id})
    }
}
