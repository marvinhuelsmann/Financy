//
//  Persistence.swift
//  Financy
//
//  Created by Marvin Hülsmann on 29.11.22.
//

import CoreData

/// Read the Data from the CoreData
struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Financy")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(String(describing: error))")
            }
        }
    }
}
