//
//  ContentView.swift
//  RiskRudder
//
//  Created by Sean Fitzgerald on 7/9/23.
//

import SwiftUI

// Represents the dashboard view in the RiskRudder app.
struct DashboardView: View {
    // State variables to track whether the user is editing personal details or adding a new investment.
    @State private var isEditingPersonalDetails = false
    @State private var isAddingNewInvestment = false
    
    // Manager object to handle investment-related tasks.
    @EnvironmentObject var investmentManager: InvestmentManager

    // The environment object for managing retirement target information
    @EnvironmentObject var retirementManager: RetirementManager

    // Formatter to display the date of investment in a user-friendly format.
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    /// Format net retirement amount for the wealthometer gauge
    func formatTargetRetirement(_ amount:Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        if amount >= 1_000_000 {
            numberFormatter.maximumFractionDigits = 1
            if let formattedMillions = numberFormatter.string(from: NSNumber(value: amount / 1_000_000.0)) {
                return "$\(formattedMillions)M"
            }
        } else if amount >= 1_000 {
            numberFormatter.maximumFractionDigits = 0
            if let formattedThousands = numberFormatter.string(from: NSNumber(value: amount / 1_000)) {
                return "$\(formattedThousands)K"
            }
        }
        return "Ret."
    }
    
    /// Removes an investment from the list.
    /// - Parameter offsets: The positions of the investments to remove in the list.
    func removeInvestment(at offsets: IndexSet) {
        for index in offsets {
            let investment = investmentManager.investments[index]
            investmentManager.removeInvestments(with: investment.id)
        }
    }

    // Defines the structure and content of the view.
    var body: some View {
        // Each GaugeView represents a risk parameter.
        // The first represents risk level with "LOW" to "HIGH" range,
        // and the second represents financial level with range upto "$1M".
        // List below contains investments, each with name, type, purchase value, and purchase date.
        // "Add Investment" button presents a sheet for adding a new investment.
        // "Edit Retirement Goal" button presents a sheet for editing personal details.
        VStack {
            VStack {
                GaugeView(rightLabel: "HIGH",
                          leftLabel: "LOW",
                          value: 0.66,
                          targetRange: 0.6...0.7)
                    .padding()
                GaugeView(rightLabel: formatTargetRetirement(retirementManager.targetNetRetirement),
                          leftLabel: "",
                          value: retirementManager.targetNetRetirement == 0 ? 0 : investmentManager.netInvestmentPurchaseValue / retirementManager.targetNetRetirement,
                          targetRange: retirementManager.targetNetRetirement == 0 ? 0...1 : ((retirementManager.targetCurrentRetirementRange.lowerBound / retirementManager.targetNetRetirement)...(retirementManager.targetCurrentRetirementRange.upperBound / retirementManager.targetNetRetirement)),
                          degreesEnd: -180)
                    .padding()
            }
            .padding()
            List {
                ForEach(investmentManager.investments) { investment in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(investment.name)
                                .font(.headline)
                            Text(investment.type.rawValue)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("\(investment.purchaseValue, specifier: "$%.2f")")
                                .font(.subheadline)
                            Text("\(investment.date, formatter: dateFormatter)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: removeInvestment)
            }
            
            Button("Add Investment") {
                isAddingNewInvestment = true
            }
            .sheet(isPresented: $isAddingNewInvestment) {
                AddInvestmentView()
            }
            .padding()
            Button("Edit Retirement Goal") {
                isEditingPersonalDetails = true
            }
            .sheet(isPresented: $isEditingPersonalDetails) {
                PersonalDetailsView()
            }
            
        }
    }
}

// Provides a preview of DashboardView with some sample investments.
struct DashboardView_Previews: PreviewProvider {

    static var previews: some View {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()

        let manager = InvestmentManager()
        let retirementManager = RetirementManager()
        retirementManager.targetMonthlyRetirementPay = 5000
        retirementManager.retirementYear = 2052
        retirementManager.retirementMonth = 10
        retirementManager.monthlyInvestment = 800

        let testInvestments = [
            ("00000000-0000-0000-0000-000000000001", "Stocks", "Diversified Stocks", 200000.0),
            ("00000000-0000-0000-0000-000000000003", "Bonds", "Diversified Bonds", 100000.0),
            ("00000000-0000-0000-0000-000000000004", "Cash", "Brokerage Cash", 10000.0)
        ]

        // Add the test investments.
        testInvestments.forEach { tuple in
            manager.addInvestment(name: tuple.2, category: tuple.1, purchaseValue: tuple.3, date: Date(), id: UUID(uuidString: tuple.0)!)
        }

        return DashboardView()
            .environmentObject(manager)
            .environmentObject(retirementManager)
    }
}
