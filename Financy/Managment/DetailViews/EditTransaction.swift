//
//  EditTransaction.swift
//  Financy
//
//  Created by Marvin Hülsmann on 22.02.23.
//

import SwiftUI
import Combine

struct EditTransaction: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var viewContext
    
    /// form inputs
    @State var productID: UUID
    @State var money: String
    @State var reason: String
    @State var date: Date
    
    @State private var hasFillForm: Bool = true
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("createtransaction.money")) {
                    TextField("10€", text: $money)
                        .keyboardType(.numberPad)
                        .onReceive(Just(money)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.money = filtered
                            }
                        }
                }
                
                Section(header: Text("createtransaction.info")) {
                    TextField("createtransaction.info.detail", text: $reason)
                }
                
                Section(header: Text("createtransaction.time")) {
                    DatePicker(selection: $date, displayedComponents: .date, label: {
                        VStack {
                            Text("createtransaction.time.detail")
                        }
                    })
                }
                
                
                Section {
                    HStack(alignment: .center) {
                        Spacer()
                        Button("edittransaction.edit") {
                            if money != "" && reason != "" {
                                makeTransaction()
                            } else {
                                hasFillForm = false
                            }
                        }
                        .foregroundColor(colorScheme == .light ? .black : .white)
                        Spacer()
                    }
                    .cornerRadius(5)
                }
                if !hasFillForm {
                    HStack {
                        Spacer()
                        Text("form.fillnotall")
                            .bold()
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    
                }
            }
        }
        .navigationTitle("edittransaction.navigationTitle")
    }
    
    func makeTransaction() {
        TransactionHandler().editTransaction(productID: productID, reason: reason, money: Int(money)!, date: date, viewContext: viewContext)
        mode.wrappedValue.dismiss()
    }
}

struct EditTransaction_Previews: PreviewProvider {
    static var previews: some View {
        EditTransaction(productID: UUID(),money: "100", reason: "Test", date: Date())
    }
}
