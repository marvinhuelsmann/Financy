//
//  EditGroup.swift
//  Financy
//
//  Created by Marvin Hülsmann on 31.01.23.
//

import SwiftUI
import CoreData

struct EditGroup: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @FetchRequest(sortDescriptors: [])
    var products: FetchedResults<Products>
    @FetchRequest(sortDescriptors: [])
    var groups: FetchedResults<Groups>
    @FetchRequest(sortDescriptors: [])
    var groupedProducts: FetchedResults<GroupedProducts>
    
    
    var body: some View {
            VStack {
                if !isGroupEmpty() {
                    List {
                        ForEach(groups, id: \.self) { group in
                            if group.uuid != UUID(uuidString: "c758ec2a-a0de-11ed-a8fc-0242ac120002")! {
                                NavigationLink(destination: EditGroupDetail(groupID: group.uuid!, groupName: group.name!, groupIcon: group.icon!, groupColor: group.color!)) {
                                    HStack {
                                        VStack {
                                            Image(systemName: group.icon!)
                                                .frame(width: 16, height: 16)
                                                .foregroundColor(.white)
                                                .padding(15)
                                                .background(ColorLibary().getColor(name: group.color!))
                                                .clipShape(Circle())
                                        }
                                        VStack(alignment: .leading) {
                                            Text(group.name!)
                                            Text("Hinzugefügt am " +  group.date!.formatted(.dateTime.month().day()))
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteGroup)
                    }
                    
                } else {
                    VStack {
                        Spacer()
                        VStack {
                            Image(systemName: "rectangle.3.group")
                                .font(.system(size: 60))
                            Text("Keine Gruppen")
                                .bold()
                                .font(.largeTitle)
                        }.padding(.bottom, 50)
                        Spacer()
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: CreateGroup()) {
                            HStack {
                                Image(systemName: "plus")
                            }
                        }
                        .disabled(products.isEmpty)
                }
            })
            .navigationTitle("Deine Gruppen")
    }
    
    func isGroupEmpty() -> Bool {
        if groups.count == 1 {
            for group in groups {
                if group.uuid == UUID(uuidString: "c758ec2a-a0de-11ed-a8fc-0242ac120002") {
                    return true
                } else {
                    return false
                }
            }
        }
        return false
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
    
    func deleteGroup(at offsets: IndexSet) {
        withAnimation {
            offsets.map {
                groups[$0]
            }.forEach(viewContext.delete)
            
            saveContext(viewContext: viewContext)
            
        }
    }
    
}


struct EditGroup_Previews: PreviewProvider {
    static var previews: some View {
        EditGroup()
    }
}

