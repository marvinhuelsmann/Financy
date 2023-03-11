//
//  CreateGroup.swift
//  Financy
//
//  Created by Marvin Hülsmann on 30.01.23.
//

import SwiftUI

struct CreateGroup: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    var products: FetchedResults<Products>
    
    /// form inputs
    @State private var name: String = ""
    
    @State private var iconName: String = "xmark"
    @State private var groupColor: String = "Rot"
    
    @State private var hasFillForm: Bool = true
    
    @State private var groupedProducts: Array = []
    
    @State private var avaibleIcons = IconLibary().getAvaibleGroupedIcons().shuffled()
    @State private var avaibleColors = ColorLibary().getAvaibleColors().shuffled()
    var body: some View {
        VStack {
            Form {
                Section(header: Text("creategroup.icon")) {
                    Picker("Icon", selection: $iconName) {
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
                    TextField("Watch", text: $name)
                }
                
                
                Section(footer: Text("creategroup.alert")) {
                    HStack(alignment: .center) {
                        Spacer()
                        Button("creategroup.add") {
                            if name != "" && iconName != "" {
                                makeProdukt()
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
        .navigationTitle("creategroup.navigationTitle")
    }
    
    func makeProdukt() {
        GroupHandler().createGroup(name: name, color: groupColor, icon: iconName, viewContext: viewContext)
        mode.wrappedValue.dismiss()
    }
}

struct CreateGroup_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroup()
    }
}
