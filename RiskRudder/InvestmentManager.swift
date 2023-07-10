//
//  InvestmentManager.swift
//  RiskRudder
//
//  Created by Sean Fitzgerald on 7/10/23.
//

import Foundation

class InvestmentManager: ObservableObject {
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
    
    func addInvestment(_ investment: Investment) {
        investments.append(investment)
    }
    
    func removeInvestments(with id: UUID) {
        investments = investments.filter({ $0.id != id})
    }
}
