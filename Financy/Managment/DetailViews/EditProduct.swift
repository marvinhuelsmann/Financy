//
//  EditProduct.swift
//  Financy
//
//  Created by Marvin Hülsmann on 29.01.23.
//

import SwiftUI
import Combine

struct EditProduct: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var viewContext
    
    @State var productID: UUID
    @State var productName: String
    @State var productIcon: String
    @State var productPrice: String
    
    @State private var hasFillForm: Bool = true
    @State private var avaibleIcons = IconLibary().getAvaibleProductIcons().shuffled()
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Produkt Icon*")) {
                    Picker("Icon", selection: $productIcon) {
                        ForEach(avaibleIcons, id: \.self) { icon in
                            Image(systemName: icon)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 100)
                }
                
                Section(header: Text("Produkt Name*")) {
                    TextField("iPhone 14 Pro", text: $productName)
                }
                
                Section(header: Text("Preis")) {
                    TextField("1299", text: $productPrice)
                        .keyboardType(.numberPad)
                        .onReceive(Just(productPrice)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.productPrice = filtered
                            }
                        }
                }
                
                Section {
                    HStack(alignment: .center) {
                        Spacer()
                        Button("Produkt bearbeiten") {
                            if productName != "" {
                                editProduct()
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
        .navigationTitle("Produkt speichern")
    }
    
    func editProduct() {
        ProductHandler().editProduct(id: productID, name: productName, price: Int16(productPrice)!, icon: productIcon, viewContext: viewContext)
        mode.wrappedValue.dismiss()
    }
    
}


struct EditProduct_Previews: PreviewProvider {
    static var previews: some View {
        EditProduct(productID: UUID(), productName: "Test", productIcon: "applewatch", productPrice: "14")
    }
}
