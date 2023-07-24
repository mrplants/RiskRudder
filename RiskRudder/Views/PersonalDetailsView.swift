//
//  PersonalDetailsView.swift
//  RiskRudder
//
//  Created by Sean Fitzgerald on 7/9/23.
//

import SwiftUI

// A view for editing personal details including retirement goals and planned investments.
struct PersonalDetailsView: View {
    // Allows the view to dismiss itself.
    @Environment(\.presentationMode) var presentationMode
    
    // The environment object for managing retirement target information
    @EnvironmentObject var retirementManager: RetirementManager
    
    var body: some View {
        VStack {
            ZStack {
                // Close button
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done").padding()
                    }
                }
                Text("Edit Retirement Goal")
                    .font(.title)
                    .padding()
            }
            Text("Your retirement goals and planned investments help you target risk and measure readiness.")
                .padding()
                .font(.body)
            // Form for inputting retirement and investment details
            Form {
                Section("Retirement Date") {
                    // Retirement Year Picker
                    Picker("Year", selection: $retirementManager.retirementYear) {
                        Text("").tag(0)
                        ForEach(2023..<2100) { year in
                            Text("\(String(format: "%d", year))").tag(year)
                        }
                    }

                    // Retirement Month Picker
                    Picker("Month", selection: $retirementManager.retirementMonth) {
                        Text("").tag(0)
                        ForEach(1..<13) { monthIndex in
                            Text("\(DateFormatter().monthSymbols[monthIndex-1])").tag(monthIndex)
                        }
                    }
                    Text("(Hint: Many people retire in their 60s.)")
                        .foregroundColor(.secondary)
                }
                Section("Retirement Target") {
                    // Retirement Monthly Income Picker
                    Picker("Target Monthly Income", selection: $retirementManager.targetMonthlyRetirementPay) {
                        Text("").tag(0)
                        ForEach(Array(stride(from: 1000, through: 10000, by: 500)), id: \.self) { income in
                            Text("$\(income)").tag(income)
                        }
                    }
                    Text("(Hint: Many people go with 60% of what they need to live comfortably. Social Security can usually handle the rest.)")
                        .foregroundColor(.secondary)
                }
                Section("Planned Investments") {
                    // Monthly Investment Picker
                    Picker("Monthly Investment", selection: $retirementManager.monthlyInvestment) {
                        Text("").tag(0)
                        ForEach(Array(stride(from: 50, through: 2000, by: 50)), id: \.self) { income in
                            Text("$\(income)")
                        }
                    }
                    Text("(Hint: Pick something achievable. Many people aim for 10-15% of their income.)")
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
    }
}

struct PersonalDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let retirementManager = RetirementManager()
        retirementManager.targetMonthlyRetirementPay = 10000
        retirementManager.retirementYear = 2052
        retirementManager.retirementMonth = 10
        retirementManager.monthlyInvestment = 1000
        return DashboardView()
            .sheet(isPresented: .constant(true)) {
                PersonalDetailsView()
            }
            .environmentObject(InvestmentManager())
            .environmentObject(retirementManager)
    }
}
