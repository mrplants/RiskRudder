//
//  AddInvestmentView.swift
//  RiskRudder
//
//  Created by Sean Fitzgerald on 7/9/23.
//

import SwiftUI

// A view for adding a new investment.
struct AddInvestmentView: View {
    // Allows the view to dismiss itself.
    @Environment(\.presentationMode) var presentationMode

    // The environment object for managing investments.
    @EnvironmentObject var investmentManager: InvestmentManager

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Spacer()
                    // Close button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark").padding()
                    }
                    .padding(.horizontal)
                }
                Text("New Investment")
                    .font(.title)
                    .padding()
            }
            InvestmentForm() {category, name, purchaseDate, purchaseValue in
                investmentManager.addInvestment(name: name,
                                                category: category,
                                                purchaseValue: purchaseValue,
                                                date: purchaseDate)
                presentationMode.wrappedValue.dismiss()
            }
            Spacer()
        }
    }
}
struct AddInvestmentView_Previews: PreviewProvider {
    static var previews: some View {
        let retirementManager = RetirementManager()
        retirementManager.targetMonthlyRetirementPay = 10000
        retirementManager.retirementYear = 2052
        retirementManager.retirementMonth = 10
        retirementManager.monthlyInvestment = 1000
        return DashboardView()
            .sheet(isPresented: .constant(true)) {
                AddInvestmentView()
            }
            .environmentObject(InvestmentManager())
            .environmentObject(retirementManager)
    }
}
