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
    
    // cash, bonds, real estate, stocks
    func calculateTargetPortfolio(investmentDurationMonths:Int) -> (Double, Double, Double, Double) {
        let investmentDurationYears = Double(investmentDurationMonths) / 12.0
        switch investmentDurationYears {
        case 25...:
            return (0.05, 0.15, 0.10, 0.70)
        case 15..<25:
            return (0.05, 0.20, 0.10, 0.65)
        case 5..<15:
            return (0.05, 0.275, 0.125, 0.55)
        case ..<5:
            return (0.10, 0.35, 0.15, 0.40)
        default:
            return (0.10, 0.35, 0.15, 0.40)
        }
    }
    
    // Calculate rick metric given a portfolio
    func calculateTargetRiskMetric(portfolio:(Double, Double, Double, Double)) -> Double {
        let (_, _, _, stocks) = portfolio
        return (stocks - 0.35) / (0.4)
    }
    
    // Calculate the risk metric for the current portfolio
    func calculateRiskMetric(portfolio:(Double, Double, Double, Double)) -> Double {
        let targetMetric = calculateTargetRiskMetric(portfolio: calculateTargetPortfolio(investmentDurationMonths: remainingInvestmentMonths() ?? 0))

        let targetPortfolio = calculateTargetPortfolio(investmentDurationMonths: remainingInvestmentMonths() ?? 0)
        let cashDiff = portfolio.0 - targetPortfolio.0
        let bondsDiff = targetPortfolio.1 - portfolio.1
        let realEstateDiff = targetPortfolio.2 - portfolio.2
        let stocksDiff = targetPortfolio.3 - portfolio.3
        let diff = sqrt(pow(cashDiff, 2) + pow(bondsDiff, 2) + pow(realEstateDiff, 2) + pow(stocksDiff, 2))
        if cashDiff + bondsDiff + realEstateDiff + stocksDiff < 0 {
            // too risky
            return min(targetMetric + diff/0.5, 1)
        } else {
            // not risky enough
            return max(targetMetric - diff/0.5, 0)
        }
    }
    
    // Calculated metric for correct investment portfolio diversification
    var targetDiversificationRange: ClosedRange<Double> {
        get {
            let target = calculateTargetRiskMetric(portfolio: calculateTargetPortfolio(investmentDurationMonths: remainingInvestmentMonths() ?? 0))
            return (target - 0.04)...(target+0.04)
        }
    }

    // This is optional because the retirement personal information may not be setup
    func remainingInvestmentMonths() -> Int? {
        let currentDate = Date()
        let calendar = Calendar.current
        var targetDateComponents = DateComponents()
        targetDateComponents.year = retirementYear
        targetDateComponents.month = retirementMonth
        guard let targetDate = calendar.date(from: targetDateComponents) else {
            return nil
        }
        
        // Calculate the difference in months
        let differenceComponents = calendar.dateComponents([.month],
                                                           from: currentDate,
                                                           to: targetDate)
        guard let differenceInMonths = differenceComponents.month else {
            return nil
        }
        return differenceInMonths
    }
    
    /// Calculated value of the user's target range right now to meet the future TargetNetRetirement
    var targetCurrentRetirementRange: ClosedRange<Double> {
        get {
            
            let lowerBound = (calculateTargetValue(for: 0.05)) ?? 0
            let upperBound = (calculateTargetValue(for: 0.03)) ?? targetNetRetirement
            return lowerBound...upperBound
        }
    }
    
    func calculateTargetValue(for interestRate: Double) -> Double? {
        
        guard let differenceInMonths = remainingInvestmentMonths() else {
            return nil
        }
        
        if differenceInMonths < 0 {
            return nil
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
