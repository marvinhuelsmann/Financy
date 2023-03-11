//
//  EditGroupDetail.swift
//  Financy
//
//  Created by Marvin Hülsmann on 31.01.23.
//

import SwiftUI
import Combine

struct EditGroupDetail: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var viewContext
    
    @State var groupID: UUID
    @State var groupName: String
    @State var groupIcon: String
    @State var groupColor: String
    
    @State private var hasFillForm: Bool = true
    @State private var avaibleIcons = IconLibary().getAvaibleGroupedIcons().shuffled()
    @State private var avaibleColors = ColorLibary().getAvaibleColors().shuffled()
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("creategroup.icon")) {
                    Picker("Icon", selection: $groupIcon) {
                        ForEach(avaibleIcons, id: \.self) { icon in
                            Image(systemName: icon)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 100)
                }
                
                Section(header: Text("creategroup.color")) {
                    Picker("color", selection: $groupColor) {
                        ForEach(avaibleColors, id: \.key) { key, value in
                            Text(LocalizedStringKey(key))
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 100)
                }
                
                Section(header: Text("creategroup.name")) {
                    TextField("Watch", text: $groupName)
                }
                
                Section(footer: Text("creategroup.alert")) {
                    HStack(alignment: .center) {
                        Spacer()
                        Button("editgroup.navigationTitle") {
                            if groupName != "" {
                                editGroup()
                            } else {
                                hasFillForm = false
                            }
                        }
                        .foregroundColor(colorScheme == .light ? .black : .white)
                        Spacer()
                    }
                    .cornerRadius(5)
                }
                if !hasFillForm {
                    HStack {
                        Spacer()
                        Text("form.fillnotall")
                            .bold()
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    
                }
            }
        }
        .navigationTitle("editgroup.navigationTitle")
    }
    
    func editGroup() {
        GroupHandler().editGroup(id: groupID, name: groupName, icon: groupIcon, color: groupColor, viewContext: viewContext)
        mode.wrappedValue.dismiss()
    }
    
}


struct EEditGroupDetail_Previews: PreviewProvider {
    static var previews: some View {
        EditGroupDetail(groupID: UUID(), groupName: "Test", groupIcon: "applewatch", groupColor: "Rot")
    }
}

