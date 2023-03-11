//
//  CreateTransaction.swift
//  Financy
//
//  Created by Marvin Hülsmann on 30.11.22.
//

import SwiftUI
import Combine

struct CreateTransaction: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var viewContext
    var productID: UUID
    
    /// form inputs
    @State private var date: Date = Date()
    @State private var money: String = ""
    
    @State private var reason: String = ""
    
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
                        Button("createtransaction.add") {
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
        .navigationTitle("createtransaction.navigationTitle")
    }
    
    func makeTransaction() {
        TransactionHandler().createTransaction(productID: productID, reason: reason, money: Int(money)!, date: date, viewContext: viewContext)
        mode.wrappedValue.dismiss()
    }
}

struct CreateTransaction_Previews: PreviewProvider {
    static var previews: some View {
        CreateTransaction(productID: UUID())
    }
}

