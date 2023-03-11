//
//  CreateProduct.swift
//  Financy
//
//  Created by Marvin Hülsmann on 29.11.22.
//

import SwiftUI
import Combine
import CoreData

struct CreateProduct: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    var products: FetchedResults<Products>
    
    /// form inputs
    @State private var name: String = ""
    @State private var price: String = ""
    
    @State private var iconName: String = "xmark"
    
    @State private var hasFillForm: Bool = true
    @State private var enoughProducts: Bool = false
    
    @State private var avaibleIcons = IconLibary().getAvaibleProductIcons().shuffled()
    
    @StateObject var storeKit = StoreKitManager()
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("newproduct.icon")) {
                    Picker("Icon", selection: $iconName) {
                        ForEach(avaibleIcons, id: \.self) { icon in
                            Image(systemName: icon)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 100)
                }
                
                Section(header: Text("newproduct.name")) {
                    TextField("iPhone 14 Pro", text: $name)
                }
                
                Section(header: Text("newproduct.price")) {
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
                        Button("newproduct.addproduct") {
                            if name != "" && iconName != "" {
                                makeProdukt(iconName: iconName)
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
                if enoughProducts {
                    HStack {
                        Spacer()
                        Text("newproduct.limit")
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    
                }
            }
        }
        .navigationTitle("newproduct.navigationTitle")
    }
    
    func canCreateMoreProducts() -> Bool {
        if !storeKit.hasFinancyPro() {
            if products.count <= 4 {
                return true
            } else {
                enoughProducts.toggle()
                return false
            }
        } else {
            return true
        }
    }
    
    func makeProdukt(iconName: String) {
        if canCreateMoreProducts() {
            createProduct(name: name, price: Int64(price)!, icon: iconName, viewContext: viewContext)
            mode.wrappedValue.dismiss()
        } else {
            enoughProducts = true
        }
    }
    
    func createProduct(name: String, price: Int64, icon: String, viewContext: NSManagedObjectContext) {
        let uuid = UUID()
        
        if products.isEmpty {
            GroupHandler().createNoCategoryGroup(productUUID: uuid, viewContext: viewContext)
        } else {
            GroupHandler().addProductToGroup(productUUID: uuid, groupUUID: UUID(uuidString: "c758ec2a-a0de-11ed-a8fc-0242ac120002")!, viewContext: viewContext)
        }
        
        let newProduct = Products(context: viewContext)
        newProduct.uuid = uuid
        newProduct.name = name
        newProduct.price = price
        newProduct.date = Date()
        
        newProduct.icon = icon
        
        saveContext(viewContext: viewContext)
        
        NotificationHandler().sendNotificationRaw(title: "newproduct.notify.title \(newProduct.name!)", body: "newproduct.notify.body \(newProduct.price.formatted())", launchIn: (60 * 6) * Int.random(in: 3..<20))
        
    }
    
    /// Save the Context
    func saveContext(viewContext: NSManagedObjectContext) {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
}

struct CreateProduct_Previews: PreviewProvider {
    static var previews: some View {
        CreateProduct()
    }
}
