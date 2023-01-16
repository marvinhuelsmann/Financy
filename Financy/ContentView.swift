//
//  ContentView.swift
//  Financy
//
//  Created by Marvin Hülsmann on 29.11.22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    var products: FetchedResults<Products>
    
    @State private var path: [Products] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if !products.isEmpty {
                    List {
                        ForEach(products, id: \.self) { product in
                            NavigationLink(value: product) {
                                HStack {
                                    VStack {
                                    Image(systemName: product.icon!)
                                            .frame(width: 16, height: 16)
                                            .foregroundColor(.white)
                                            .padding(15)
                                            .background(Color(UIColor.lightGray))
                                            .clipShape(Circle())
                                    }
                                    VStack(alignment: .leading) {
                                        Text(product.name!)
                                        Text("Hinzugefügt am " +  product.date!.formatted(.dateTime.month().day()))
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Text("\(product.price)€")
                                        .bold()
                                }
                            }
                        }
                        .onDelete(perform: deleteProduct)
                    }
                    .navigationDestination(for: Products.self) { product in
                        ProductPlanner(productID: product.uuid!, productName: product.name!, productAmount: Int(product.price))
                    }
                } else {
                    VStack {
                        Spacer()
                        VStack {
                            Image(systemName: "backpack")
                                .font(.system(size: 60))
                            Text("Keine Produkte")
                                .bold()
                                .font(.largeTitle)
                        }.padding(.bottom, 50)
                        Spacer()
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CreateProduct()) {
                        HStack {
                            Text("Neues Produkt")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: SettingsView()) {
                        HStack {
                            Text("Einstellungen")
                        }
                    }
                }
            })
            .navigationTitle("Deine Produkte")
        }
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
    
    func deleteProduct(at offsets: IndexSet) {
        withAnimation {
            offsets.map {
                products[$0]
            }.forEach(viewContext.delete)
            
            saveContext(viewContext: viewContext)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
