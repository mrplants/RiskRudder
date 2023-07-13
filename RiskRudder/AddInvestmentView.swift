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

    // The state variables for the investment's details.
    @State private var category = ""
    @State private var name = ""
    @State private var purchaseDate = Date()
    @State private var purchaseValue: Double = 0

    // Variables for handling alert in case of form validation failure
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    // A number formatter for currency input.
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

    var body: some View {
        VStack {
            // Close button
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

            // Form for inputting investment details
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
                            // Validate form and either add investment or show alert
                            if validateForm() {
                                investmentManager.addInvestment(name: name,
                                                                category: category,
                                                                purchaseValue: purchaseValue,
                                                                date: purchaseDate)
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                showingAlert = true
                            }
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
    
    // Validates the form and returns a boolean representing its validity. If invalid, sets the alert message accordingly.
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
