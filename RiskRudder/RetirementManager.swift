//
//  RetirementManager.swift
//  RiskRudder
//
//  Created by Sean Fitzgerald on 7/12/23.
//

import Foundation

enum RetirementError: Error {
    case invalidTargetDate
    case cannotCalculateDifference
    case negativeDifference
}

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
    
    /// Calculated value of the user's required retirement sum using the 4% rule
    var targetNetRetirement: Double {
        get {
            return Double(targetMonthlyRetirementPay) * 12 / 0.04
        }
    }
    
    /// Calculated value of the user's target range right now to meet the future TargetNetRetirement
    var targetCurrentRetirementRange: ClosedRange<Double> {
        get {
            
            let lowerBound = (try? calculateTargetValue(for: 0.045)) ?? 0
            let upperBound = (try? calculateTargetValue(for: 0.035)) ?? targetNetRetirement
            return lowerBound...upperBound
        }
    }
    
    func calculateTargetValue(for interestRate: Double) throws -> Double {
        let currentDate = Date()
        let calendar = Calendar.current
        var targetDateComponents = DateComponents()
        targetDateComponents.year = retirementYear
        targetDateComponents.month = retirementMonth
        guard let targetDate = calendar.date(from: targetDateComponents) else {
            print("Could not create target date from components")
            throw RetirementError.invalidTargetDate
        }
        
        // Calculate the difference in months
        let differenceComponents = calendar.dateComponents([.month],
                                                           from: currentDate,
                                                           to: targetDate)
        guard let differenceInMonths = differenceComponents.month else {
            print("Could not calculate difference in months.")
            throw RetirementError.cannotCalculateDifference
        }
        
        if differenceInMonths < 0 {
            throw RetirementError.negativeDifference
        }
        
        let monthlyRate = Double(pow((1 + interestRate), 1/12))
        let monthlyInvestmentFutureValue = Array(0..<differenceInMonths).map({Double(monthlyInvestment) * Double(pow(monthlyRate, Double($0))) }).reduce(0, +)
        return (targetNetRetirement - monthlyInvestmentFutureValue) / Double(pow(monthlyRate, Double(differenceInMonths)))
    }

    /// Initializer fetches retirement details from User Defaults.
    init() {
        retirementYear = UserDefaults.standard.value(forKey: "retirementYear") as? Int ?? retirementYear
        retirementMonth = UserDefaults.standard.value(forKey: "retirementMonth") as? Int ?? retirementMonth
        monthlyInvestment = UserDefaults.standard.value(forKey: "monthlyInvestment") as? Int ?? monthlyInvestment
        targetMonthlyRetirementPay = UserDefaults.standard.value(forKey: "targetMonthlyRetirementPay") as? Int ?? targetMonthlyRetirementPay
    }
}
