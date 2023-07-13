//
//  ContentView.swift
//  RiskRudder
//
//  Created by Sean Fitzgerald on 7/9/23.
//

import SwiftUI

struct DashboardView: View {
    @State private var isEditingPersonalDetails = false
    @State private var isAddingNewInvestment = false
    
    @EnvironmentObject var investmentManager: InvestmentManager
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    func removeInvestment(at offsets: IndexSet) {
        for index in offsets {
            let investment = investmentManager.investments[index]
            investmentManager.removeInvestments(with: investment.id)
        }
    }

    var body: some View {
        VStack {
            VStack {
                GaugeView(rightLabel: "HIGH",
                          leftLabel: "LOW",
                          value: .constant(0.66),
                          targetRange: .constant(0.6...0.7))
                    .padding()
                Spacer()
                GaugeView(rightLabel: "$1M",
                          leftLabel: "",
                          value: .constant(0.29),
                          targetRange: .constant(0.2...0.3),
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
                            Text("Purchased: \(investment.purchaseValue, specifier: "$%.2f")")
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

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = InvestmentManager()
        
        let testInvestments = [
            ("00000000-0000-0000-0000-000000000001", "Stocks", "Apple", 2000.0),
            ("00000000-0000-0000-0000-000000000002", "Stocks", "Microsoft", 1500.0),
            ("00000000-0000-0000-0000-000000000003", "Bonds", "US Treasury", 5000.0)
        ]

        // before setting, clear any previous investments with these IDs
        testInvestments.forEach { manager.removeInvestments(with: UUID(uuidString: $0.0)!) }

        // then add the test investments
        testInvestments.forEach { tuple in
            manager.addInvestment(name: tuple.2, category: tuple.1, purchaseValue: tuple.3, date: Date(), id: UUID(uuidString: tuple.0)!)
        }

        return DashboardView().environmentObject(manager)
    }
}
