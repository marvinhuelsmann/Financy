//
//  GroupHandle.swift
//  Financy
//
//  Created by Marvin Hülsmann on 30.01.23.
//

import SwiftUI
import CoreData

struct GroupHandler {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    var groups: FetchedResults<Groups>
    @FetchRequest(sortDescriptors: [])
    var groupedProducts: FetchedResults<GroupedProducts>
    
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
    func deleteGroup(offsets: IndexSet) {
        offsets.map {
            groups[$0]
        }.forEach(viewContext.delete)
        
        saveContext(viewContext: viewContext)
    }
    
    func getGroupByName(groupName: String, viewContext: NSManagedObjectContext) -> UUID {
        let fetchRequest: NSFetchRequest<Groups>
        fetchRequest = Groups.fetchRequest()

        fetchRequest.predicate = NSPredicate(
            format: "name == %@", groupName as CVarArg
        )
        
        let context = viewContext

        // Perform the fetch request to get the objects
        // matching the predicate
        do {
            let objects = try context.fetch(fetchRequest).first
            
            return (objects?.uuid)!
            
        } catch {
            print("Found Error!")
        }
        return UUID()
    }
    
    func isExistGroupByName(groupName: String, viewContext: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<Groups>
        fetchRequest = Groups.fetchRequest()

        fetchRequest.predicate = NSPredicate(
            format: "name == %@", groupName as CVarArg
        )
        
        let context = viewContext

        // Perform the fetch request to get the objects
        // matching the predicate
        do {
            let objects = try context.fetch(fetchRequest).first
            
            return ((objects?.uuid!) != nil)
            
        } catch {
            print("Found Error!")
        }
        return false
    }
    
    func updateProductCategory(id: UUID, newID: UUID, viewContext: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<GroupedProducts>
        fetchRequest = GroupedProducts.fetchRequest()

        fetchRequest.predicate = NSPredicate(
            format: "productUUID == %@", id as CVarArg
        )
        
        let context = viewContext

        // Perform the fetch request to get the objects
        // matching the predicate
        do {
            let objects = try context.fetch(fetchRequest).first
            
            objects?.setValue(newID, forKey: "groupUUID")
            
            saveContext(viewContext: viewContext)
        } catch {
            print("Found Error!")
        }
    }
    
    
    func createNoCategoryGroup(productUUID: UUID, viewContext: NSManagedObjectContext) {
            let newGroup = Groups(context: viewContext)
            newGroup.uuid = UUID(uuidString: "c758ec2a-a0de-11ed-a8fc-0242ac120002")!
            newGroup.name = String(localized: "group.notgrouped")
            newGroup.date = Date()
            newGroup.icon = "moon.fill"
            newGroup.color = "Grau"
            
        addProductToGroup(productUUID: productUUID, groupUUID: UUID(uuidString: "c758ec2a-a0de-11ed-a8fc-0242ac120002")!, viewContext: viewContext)
            saveContext(viewContext: viewContext)
    }
    
    func removeNoCategoryGroup(viewContext: NSManagedObjectContext) {

            // Get a reference to a managed object context
            let context = viewContext
            
            // Delete multiple objects
            for group in groups {
                context.delete(group)
            }
            saveContext(viewContext: viewContext)
            
            for groupedProduct in groupedProducts {
                context.delete(groupedProduct)
            }
            
            saveContext(viewContext: viewContext)
    
    }
    
    func addProductToGroup(productUUID: UUID, groupUUID: UUID, viewContext: NSManagedObjectContext) {
        let newGroupedProduct = GroupedProducts(context: viewContext)
        newGroupedProduct.uuid = UUID()
        newGroupedProduct.productUUID = productUUID
        newGroupedProduct.groupUUID = groupUUID
        newGroupedProduct.date = Date()
        
        saveContext(viewContext: viewContext)
    }
    
    func createGroup(name: String, color: String, icon: String, viewContext: NSManagedObjectContext) {
        let newGroup = Groups(context: viewContext)
        newGroup.uuid = UUID()
        newGroup.name = name
        newGroup.date = Date()
        newGroup.color = color
        newGroup.icon = icon
        
        saveContext(viewContext: viewContext)
    }
    
    func editGroup(id: UUID, name: String, icon: String, color: String, viewContext: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Groups>
        fetchRequest = Groups.fetchRequest()

        fetchRequest.predicate = NSPredicate(
            format: "uuid == %@", id as CVarArg
        )
        
        let context = viewContext

        // Perform the fetch request to get the objects
        // matching the predicate
        do {
            let objects = try context.fetch(fetchRequest).first
            
            objects?.setValue(name, forKey: "name")
            objects?.setValue(icon, forKey: "icon")
            objects?.setValue(color, forKey: "color")
            
            saveContext(viewContext: viewContext)
        } catch {
            print("Found Error!")
        }
    }
}
