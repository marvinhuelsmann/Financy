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
    @FetchRequest(sortDescriptors: [])
    var groups: FetchedResults<Groups>
    @FetchRequest(sortDescriptors: [])
    var groupedProducts: FetchedResults<GroupedProducts>
    
    @State private var path: [Products] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if !products.isEmpty {
                    List {
                        ForEach(groups, id: \.self) { group in
                            if hasGroupMember(groupUUID: group.uuid!) {
                                Section(header: Text(group.name!).bold()) {
                                    ForEach(groupedProducts, id: \.self) { groupedProducts in
                                        if groupedProducts.groupUUID == group.uuid {
                                            DetailGroupView(groupedProductUUID: groupedProducts.productUUID!, groupColor: group.color!)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .navigationDestination(for: Products.self) { product in
                        ProductPlanner(productID: product.uuid!, productName: product.name!, productAmount: Int(product.price), productIcon: product.icon!)
                    }
                } else {
                    VStack {
                        Spacer()
                        VStack {
                            Image(systemName: "backpack")
                                .font(.system(size: 60))
                            Text("products.empty")
                                .bold()
                                .font(.largeTitle)
                        }.padding(.bottom, 50)
                        Spacer()
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        NavigationLink(destination: CreateProduct()) {
                            HStack {
                                Text("products.new")
                                Image(systemName: "plus")
                            }
                        }
                        NavigationLink(destination: EditGroup()) {
                            Text("products.editgroup")
                            Image(systemName: "rectangle.3.group")
                        }
                        .disabled(products.isEmpty)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: SettingsView()) {
                        HStack {
                            Text("settings.navigationTitle")
                        }
                    }
                }
            })
            .onAppear {
                viewContext.refreshAllObjects()
            }
            .navigationTitle("products.navigationTitle")
        }
    }
    
    func hasGroupMember(groupUUID: UUID) -> Bool {
        var i = 0
        for groupedProduct in groupedProducts {
            if groupedProduct.groupUUID == groupUUID {
                i += 1
            }
        }
        
        return i > 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct DetailGroupView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    var products: FetchedResults<Products>
    @FetchRequest(sortDescriptors: [])
    var groups: FetchedResults<Groups>
    @FetchRequest(sortDescriptors: [])
    var groupedProducts: FetchedResults<GroupedProducts>
    
    var groupedProductUUID: UUID
    var groupColor: String
    
    @State private var currencyLibary = CurrencyLibary()
    var body: some View {
        ForEach(products, id: \.self) { product in
            if groupedProductUUID == product.uuid {
                NavigationLink(value: product) {
                    HStack {
                        VStack {
                            Image(systemName: product.icon!)
                                .frame(width: 16, height: 16)
                                .foregroundColor(.white)
                                .padding(15)
                                .background(ColorLibary().getColor(name: groupColor))
                                .clipShape(Circle())
                        }
                        VStack(alignment: .leading) {
                            Text(product.name!)
                            Text("products.detail.added \(product.date!.formatted(.dateTime.month().day()))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text("\(product.price)" + currencyLibary.getSpecificIcon())
                            .bold()
                    }
                }
            }
        }
        .onDelete(perform: deleteProduct)
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
            
            if products.isEmpty {
                removeNoCategoryGroup(viewContext: viewContext)
            }
        }
        deleteLinkedGroupedProductEntry()
        
    }
    
    func deleteLinkedGroupedProductEntry() {
        var groupedProductUUIDList = Array<UUID>()
        var productUUIDList = Array<UUID>()
        
        var deletableGroupedUUIDs = Array<UUID>()
        
        for groupedProduct in groupedProducts {
            groupedProductUUIDList.append(groupedProduct.productUUID!)
        }
        
        for product in products {
            productUUIDList.append(product.uuid!)
        }
        
        for groupedProduct in groupedProductUUIDList {
            if !productUUIDList.contains(groupedProduct) {
                deletableGroupedUUIDs.append(groupedProduct)
            }
        }
        
        for groupedProduct in groupedProducts {
            if deletableGroupedUUIDs.contains(groupedProduct.productUUID!) {
                viewContext.delete(groupedProduct)
            }
        }
        
        saveContext(viewContext: viewContext)
        
    }
    
    func removeNoCategoryGroup(viewContext: NSManagedObjectContext) {
        
        // Delete multiple objects
        for group in groups {
            viewContext.delete(group)
        }
        saveContext(viewContext: viewContext)
        
        for groupedProduct in groupedProducts {
            viewContext.delete(groupedProduct)
        }
        
        saveContext(viewContext: viewContext)
    }
}
