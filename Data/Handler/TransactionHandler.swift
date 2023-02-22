//
//  TransactionHandler.swift
//  Financy
//
//  Created by Marvin Hülsmann on 30.11.22.
//

import SwiftUI
import CoreData

/// Details or modification of any product transaction
struct TransactionHandler {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    var transactions: FetchedResults<Transactions>
    
    /// Save the Context
    func saveContext(viewContext: NSManagedObjectContext) {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
    
    /// Create a product transaction where you can add money to the product target
    /// - Parameters:
    ///   - productID: is the uuid from the product
    ///   - money: is the amount, how much you spend
    ///   - date: is the current date of the transaction
    func createTransaction(productID: UUID, reason: String, money: Int, date: Date, viewContext: NSManagedObjectContext) {
        let newTransaction = Transactions(context: viewContext)
        newTransaction.uuid = UUID()
        newTransaction.reason = reason
        newTransaction.productID = productID
        newTransaction.money = Int64(money)
        newTransaction.date = date
        
        saveContext(viewContext: viewContext)
    }
}
