//
//  ProductHandler.swift
//  Financy
//
//  Created by Marvin Hülsmann on 29.11.22.
//

import SwiftUI
import CoreData

struct ProductHandler {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    var products: FetchedResults<Products>
    
    /// Save the Context
    func saveContext(viewContext: NSManagedObjectContext) {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
    
    
    /// To delete one HomeWork
    /// - Parameter offsets: To get the current HomeWork
    func deleteProduct(offsets: IndexSet) {
        offsets.map {
            products[$0]
        }.forEach(viewContext.delete)
        
        saveContext(viewContext: viewContext)
    }
    
    func createProduct(name: String, price: Int16, icon: String, viewContext: NSManagedObjectContext) {
        let newProduct = Products(context: viewContext)
        newProduct.uuid = UUID()
        newProduct.name = name
        newProduct.price = price
        newProduct.date = Date()
        
        newProduct.icon = icon
        
        saveContext(viewContext: viewContext)
    }
}
