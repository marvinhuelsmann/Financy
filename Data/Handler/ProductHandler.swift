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
    func deleteProduct(offsets: IndexSet, viewContext: NSManagedObjectContext) {
        offsets.map {
            products[$0]
        }.forEach(viewContext.delete)
        
        saveContext(viewContext: viewContext)
        
        if products.isEmpty {
            GroupHandler().removeNoCategoryGroup(viewContext: viewContext)
        }
    }
    
    func editProduct(id: UUID, name: String, price: Int16, icon: String, viewContext: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Products>
        fetchRequest = Products.fetchRequest()

        fetchRequest.predicate = NSPredicate(
            format: "uuid == %@", id as CVarArg
        )
        
        let context = viewContext

        // Perform the fetch request to get the objects
        // matching the predicate
        do {
            let objects = try context.fetch(fetchRequest).first
            
            objects?.setValue(name, forKey: "name")
            objects?.setValue(price, forKey: "price")
            objects?.setValue(icon, forKey: "icon")
            
            saveContext(viewContext: viewContext)
        } catch {
            print("Found Error!")
        }
    }
}
