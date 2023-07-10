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
            }.padding()
            Spacer()
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
