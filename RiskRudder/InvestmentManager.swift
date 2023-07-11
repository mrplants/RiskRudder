//
//  InvestmentManager.swift
//  RiskRudder
//
//  Created by Sean Fitzgerald on 7/10/23.
//

import Foundation

class InvestmentManager: ObservableObject {
    let investmentCategories = InvestmentCategory.allCases.map({ $0.rawValue })

    @Published var investments = [Investment]() {
        didSet {
            let data = try? JSONEncoder().encode(investments)
            UserDefaults.standard.set(data, forKey: "investments")
        }
    }
    
    init() {
        fetchInvestments()
    }
    
    private func fetchInvestments() {
        let data = UserDefaults.standard.data(forKey: "investments")
        let investments = try? JSONDecoder().decode([Investment].self, from: data ?? Data())
        self.investments = investments ?? []
    }
    
    func addInvestment(name:String, category: String, purchaseValue: Double, date: Date, id:UUID? = nil) {
        let newId = id ?? UUID()
        let investment = Investment(id: newId, type: InvestmentCategory(rawValue: category)!, name: name, purchaseValue: purchaseValue, date: date)
        investments.append(investment)
    }
    
    func removeInvestments(with id: UUID) {
        investments = investments.filter({ $0.id != id})
    }
}
