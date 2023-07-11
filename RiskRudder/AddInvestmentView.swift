//
//  AddInvestmentView.swift
//  RiskRudder
//
//  Created by Sean Fitzgerald on 7/9/23.
//

import SwiftUI

struct AddInvestmentView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var investmentManager: InvestmentManager
    @State private var category = ""
    @State private var name = ""
    @State private var purchaseDate = Date()
    @State private var purchaseValue: Double = 0
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark").padding()
                }
                .padding(.horizontal)
            }
            Text("New Investment")
                .font(.title)
            Form {
                TextField("Name", text: $name)
                ZStack(alignment: .leading) {
                    Text("Purchased Value")
                    TextField("Purchased Value", value: $purchaseValue, formatter: currencyFormatter)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }
                Picker("Category", selection: $category) {
                    Text("").tag("")
                    ForEach(investmentManager.investmentCategories, id:\.self) {category in
                        Text(category).tag(category)
                    }
                }
                
                DatePicker("Purchase Date", selection: $purchaseDate, displayedComponents: [.date])
                Section {
                    HStack {
                        Spacer()
                        Button("Submit") {
                            if validateForm() {
                                investmentManager.addInvestment(name: name,
                                                                category: category,
                                                                purchaseValue: purchaseValue,
                                                                date: purchaseDate)
                            } else {
                                showingAlert = true
                            }
                            presentationMode.wrappedValue.dismiss()
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Form Validation Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
                        Spacer()
                    }
                }
            }
            Spacer()
        }
    }
    
    func validateForm() -> Bool {
        alertMessage = ""
        if name.isEmpty {
            alertMessage += "Please name this investment.\n"
        }
        if purchaseValue == 0 {
            alertMessage += "Please provide a purchase value.\n"
        }
        if category.isEmpty {
            alertMessage += "Please select an investment category.\n"
        }
        return alertMessage.isEmpty
    }
}
struct AddInvestmentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .sheet(isPresented: .constant(true)) {
                AddInvestmentView()
            }
            .environmentObject(InvestmentManager())
    }
}
