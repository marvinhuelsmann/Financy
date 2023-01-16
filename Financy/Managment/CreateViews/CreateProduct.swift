//
//  CreateProduct.swift
//  Financy
//
//  Created by Marvin Hülsmann on 29.11.22.
//

import SwiftUI
import Combine

struct CreateProduct: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var viewContext
    
    /// form inputs
    @State private var name: String = ""
    @State private var price: String = ""
    
    @State private var iconName: String = ""
    
    @State private var hasFillForm: Bool = true
    
    @State private var avaibleIcons = IconLibary().getAvaibleIcons().shuffled()
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Produkt Icon*")) {
                    Picker("Icon", selection: $iconName) {
                        ForEach(avaibleIcons, id: \.self) { icon in
                            Image(systemName: icon)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 100)
                }
                
                Section(header: Text("Produkt Name*")) {
                    TextField("iPhone 14 Pro", text: $name)
                }
                
                Section(header: Text("Preis")) {
                    TextField("1299", text: $price)
                        .keyboardType(.numberPad)
                        .onReceive(Just(price)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.price = filtered
                            }
                        }
                }
                
                Section {
                    HStack(alignment: .center) {
                        Spacer()
                        Button("Produkt hinzufügen") {
                            if name != "" {
                                makeProdukt()
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
                        Text("Es wurden nicht alle benötigten Felder ausgefüllt!")
                            .bold()
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    
                }
            }
        }
        .navigationTitle("Neues Produkt")
    }
    
    func makeProdukt() {
        ProductHandler().createProduct(name: name, price: Int16(price)!, icon: iconName, viewContext: viewContext)
        mode.wrappedValue.dismiss()
    }
}

struct CreateProduct_Previews: PreviewProvider {
    static var previews: some View {
        CreateProduct()
    }
}
