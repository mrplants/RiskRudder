//
//  InvestmentForm.swift
//  RiskRudder
//
//  Created by Sean Fitzgerald on 7/14/23.
//

import SwiftUI

struct InvestmentForm: View {

    // Variables for handling alert in case of form validation failure
    @State private var showingAlert = false
    @State private var alertMessage = ""

    // The state variables for the investment's details.
    @State var category:String = ""
    @State var name:String = ""
    @State var purchaseDate:Date = Date()
    @State var purchaseValue:Double = 0
    var onSubmit: (String, String, Date, Double) -> Void = {_,_,_,_ in}
    
    // A number formatter for currency input.
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

    // Validates the form and returns a boolean representing its validity. If invalid, sets the alert message accordingly.
    func validateForm() -> Bool {
        alertMessage = ""
        if purchaseValue == 0 {
            alertMessage += "Please provide a purchase value.\n"
        }
        if category.isEmpty {
            alertMessage += "Please select an investment category.\n"
        }
        return alertMessage.isEmpty
    }

    var body: some View {
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
                ForEach(InvestmentManager.investmentCategories, id:\.self) {category in
                    Text(category).tag(category)
                }
            }
            
            DatePicker("Purchase Date", selection: $purchaseDate, displayedComponents: [.date])
            Section {
                HStack {
                    Spacer()
                    Button("Submit") {
                        // Validate form and runs onSubmit closure
                        if validateForm() {
                            onSubmit(category, name, purchaseDate, purchaseValue)
                        } else {
                            showingAlert = true
                        }
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Invalid Investment"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    Spacer()
                }
            }
        }
    }
}

struct InvestmentForm_Previews: PreviewProvider {
    static var previews: some View {
        InvestmentForm()
            .previewLayout(.fixed(width: 400, height: 300))
    }
}
