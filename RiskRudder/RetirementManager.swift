//
//  RetirementManager.swift
//  RiskRudder
//
//  Created by Sean Fitzgerald on 7/12/23.
//

import Foundation

class RetirementManager: ObservableObject {
    // User defaults for the user's retirement and investment details.
    @Published var retirementYear: Int = 0 {
        didSet {
            UserDefaults.standard.set(retirementYear, forKey: "retirementYear")
        }
    }
    @Published var retirementMonth: Int = 0 {
        didSet {
            UserDefaults.standard.set(retirementYear, forKey: "retirementMonth")
        }
    }
    @Published var monthlyInvestment: Int = 0 {
        didSet {
            UserDefaults.standard.set(retirementYear, forKey: "monthlyInvestment")
        }
    }
    @Published var targetMonthlyRetirementPay: Int = 0 {
        didSet {
            UserDefaults.standard.set(retirementYear, forKey: "targetMonthlyRetirementPay")
        }
    }
    
    // Calculated value of the user's required retirement sum using the 4% rule
    var targetNetRetirement: Double {
        get {
            return Double(targetMonthlyRetirementPay) * 12 / 0.04
        }
    }

    /// Initializer fetches retirement details from User Defaults.
    init() {
        retirementYear = UserDefaults.standard.value(forKey: "retirementYear") as? Int ?? retirementYear
        retirementMonth = UserDefaults.standard.value(forKey: "retirementMonth") as? Int ?? retirementMonth
        monthlyInvestment = UserDefaults.standard.value(forKey: "monthlyInvestment") as? Int ?? monthlyInvestment
        targetMonthlyRetirementPay = UserDefaults.standard.value(forKey: "targetMonthlyRetirementPay") as? Int ?? targetMonthlyRetirementPay
    }
}
