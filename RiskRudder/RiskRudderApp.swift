//
//  RiskRudderApp.swift
//  RiskRudder
//
//  Created by Sean Fitzgerald on 7/9/23.
//

import SwiftUI

@main
struct RiskRudderApp: App {
    var investmentManager = InvestmentManager()
    var retirementManager = RetirementManager()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environmentObject(investmentManager)
                .environmentObject(retirementManager)
        }
    }
}
