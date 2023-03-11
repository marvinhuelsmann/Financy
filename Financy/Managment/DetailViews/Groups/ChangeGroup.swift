//
//  ChangeGroup.swift
//  Financy
//
//  Created by Marvin Hülsmann on 30.01.23.
//

import SwiftUI
import CoreData


struct ChangeGroup: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var productUUID: UUID
    @State var groupName: Groups?
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    var groups: FetchedResults<Groups>
    @State private var selected: Groups?
    
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("editgroup.groups")) {
                    Picker("editgroup.group", selection: $groupName) {
                        ForEach(groups, id: \.self) { (group: Groups) in
                            Text(group.name!).tag(Optional(group))
                        }
                    }
                }
                
                
                Section {
                    HStack(alignment: .center) {
                        Spacer()
                        Button("editgroup.changegroup") {
                            if selected?.name != "" {
                                createGroupedProduct()
                            }
                        }
                        .foregroundColor(colorScheme == .light ? .black : .white)
                        Spacer()
                    }
                    .cornerRadius(5)
                }
            }
            .navigationTitle("editgroup.navigationTitle")
        }
    }
    
    func createGroupedProduct() {
        let groupUUID: UUID = GroupHandler().getGroupByName(groupName: (groupName?.name!)!, viewContext: viewContext)
        GroupHandler().updateProductCategory(id: productUUID, newID: groupUUID, viewContext: viewContext)
        mode.wrappedValue.dismiss()
        mode.wrappedValue.dismiss()
    }
}

