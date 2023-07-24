//
//  InvestmentView.swift
//  RiskRudder
//
//  Created by Sean Fitzgerald on 7/23/23.
//

import SwiftUI

struct InvestmentView: View {
    // Allows the view to dismiss itself.
    @Environment(\.presentationMode) var presentationMode

    // The environment object for managing investments.
    @EnvironmentObject var investmentManager: InvestmentManager

    // The investment's details.
    var name:String
    var category:String
    var purchaseDate:Date
    var purchaseValue:Double
    var id:UUID

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
                Text("Review Investment")
                    .font(.title)
                    .padding()
            }
            InvestmentForm(name: name,
                           category: category,
                           purchaseDate: purchaseDate) {name, category, purchaseDate, purchaseValue in
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

struct InvestmentView_Previews: PreviewProvider {
    static var previews: some View {
        let retirementManager = RetirementManager()
        retirementManager.targetMonthlyRetirementPay = 10000
        retirementManager.retirementYear = 2052
        retirementManager.retirementMonth = 10
        retirementManager.monthlyInvestment = 1000
        return DashboardView()
            .sheet(isPresented: .constant(true)) {
                InvestmentView(name: "US Stocks",
                               category: "Stocks",
                               purchaseDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                               purchaseValue: 16275.51,
                               id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!)
            }
            .environmentObject(InvestmentManager())
            .environmentObject(retirementManager)
    }
}
