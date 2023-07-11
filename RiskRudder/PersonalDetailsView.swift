//
//  PersonalDetailsView.swift
//  RiskRudder
//
//  Created by Sean Fitzgerald on 7/9/23.
//

import SwiftUI

struct PersonalDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("retirementYear") private var retirementYear: Int = 0
    @AppStorage("retirementMonth") private var retirementMonth: Int = 0
    @AppStorage("monthlyInvestment") private var monthlyInvestment: Int = 0
    @AppStorage("monthlyRetirementPay") private var monthlyRetirementPay: Int = 0
    
    var body: some View {
        VStack {
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
            Text("Your retirement goals and planned investments help you target risk and measure readiness.")
                .padding()
                .font(.body)
            Form {
                Section("Retirement Date") {
                    Picker("Year", selection: $retirementYear) {
                        Text("").tag(0)
                        ForEach(2023..<2100) { year in
                            Text("\(String(format: "%d", year))")
                        }
                    }
                    Picker("Month", selection: $retirementMonth) {
                        Text("").tag(0)
                        ForEach(1..<13) { monthIndex in
                            Text("\(DateFormatter().monthSymbols[monthIndex-1])").tag(monthIndex)
                        }
                    }
                    Text("(Hint: Many people retire in their 60s.)")
                        .foregroundColor(.secondary)
                }
                Section("Retirement Target") {
                    Picker("Target Monthly Income", selection: $monthlyRetirementPay) {
                        Text("").tag(0)
                        ForEach(Array(stride(from: 1000, through: 10000, by: 500)), id: \.self) { income in
                            Text("$\(income)").tag(income)
                        }
                    }
                    Text("(Hint: Many people go with 60% of what they need to live comfortably. Social Security can usually handle the rest.)")
                        .foregroundColor(.secondary)
                }
                Section("Planned Investments") {
                    Picker("Monthly Investment", selection: $monthlyInvestment) {
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
        DashboardView()
            .sheet(isPresented: .constant(true)) {
                PersonalDetailsView()
            }
            .environmentObject(InvestmentManager())
    }
}
