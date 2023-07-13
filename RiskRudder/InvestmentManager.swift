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
    let investmentCategories = InvestmentCategory.allCases.map({ $0.rawValue })
    
    // Sum of all investment purchaseValues
    var netInvestmentPurchaseValue: Double {
        get {
            return investments.map{ $0.purchaseValue }.reduce(0, +)
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
    
    /// Removes an investment from the list.
    /// - Parameter id: The unique identifier for the investment to remove.
    func removeInvestments(with id: UUID) {
        investments = investments.filter({ $0.id != id})
    }
}
