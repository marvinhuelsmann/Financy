//
//  CoreDataStack.swift
//  Financy
//
//  Created by Marvin Hülsmann on 17.01.23.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    private init() {}

    private let persistentContainer: NSPersistentContainer = {
        let storeURL = FileManager.appGroupContainerURL.appendingPathComponent("Financy.sqlite")
        let container = NSPersistentContainer(name: "Financy")
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        })
        return container
    }()
}

// MARK: - Main context
extension CoreDataStack {
    var managedObjectContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        managedObjectContext.performAndWait {
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Working context
extension CoreDataStack {
    var workingContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = managedObjectContext
        return context
    }

    func saveWorkingContext(context: NSManagedObjectContext) {
        do {
            try context.save()
            saveContext()
        } catch {
            print(error.localizedDescription)
        }
    }
}

/// See: https://stackoverflow.com/a/60266079/8697793
extension NSManagedObjectContext {
    /// Executes the given `NSBatchDeleteRequest` and directly merges the changes to bring the given managed object context up to date.
    ///
    /// - Parameter batchDeleteRequest: The `NSBatchDeleteRequest` to execute.
    /// - Throws: An error if anything went wrong executing the batch deletion.
    public func executeAndMergeChanges(_ batchDeleteRequest: NSBatchDeleteRequest) throws {
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
    }
}
