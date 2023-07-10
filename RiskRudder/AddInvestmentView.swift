//
//  AddInvestmentView.swift
//  RiskRudder
//
//  Created by Sean Fitzgerald on 7/9/23.
//

import SwiftUI

struct AddInvestmentView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark").padding()
                }
            }
            Spacer()
        }
    }
}
struct AddInvestmentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .sheet(isPresented: .constant(true)) {
                AddInvestmentView()
            }
    }
}
