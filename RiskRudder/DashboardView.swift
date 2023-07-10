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
    
    @ObservedObject var investmentManager = InvestmentManager()
    
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
            HStack {
                Text("Riskometer")
                    .padding()
                Spacer()
                Text("Wealthometer")
                    .padding()
            }
            .padding()
            List {
                ForEach(investmentManager.investments) { investment in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(investment.name)
                                .font(.headline)
                            Text(investment.type.rawValue.capitalized)
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
            
            Button("Edit Personal Details") {
                isEditingPersonalDetails = true
            }
            .sheet(isPresented: $isEditingPersonalDetails) {
                PersonalDetailsView()
            }
            
            Button("Add New Investment") {
                isAddingNewInvestment = true
            }.padding()
            .sheet(isPresented: $isAddingNewInvestment) {
                AddInvestmentView()
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = InvestmentManager()
        
        let testInvestments = [
            Investment(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, type: .stocks, name: "Apple", purchaseValue: 2000, date: Date()),
            Investment(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, type: .stocks, name: "Microsoft", purchaseValue: 1500, date: Date()),
            Investment(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, type: .bonds, name: "US Treasury", purchaseValue: 5000, date: Date())
        ]

        // before setting, clear any previous investments with these IDs
        testInvestments.forEach { manager.removeInvestments(with: $0.id) }
        
        // then add the test investments
        testInvestments.forEach { manager.addInvestment($0) }

        return DashboardView(investmentManager: manager)
    }
}
