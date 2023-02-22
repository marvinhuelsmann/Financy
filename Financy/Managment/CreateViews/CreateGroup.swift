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
                Section(header: Text("Gruppen Icon*")) {
                    Picker("Icon", selection: $iconName) {
                        ForEach(avaibleIcons, id: \.self) { icon in
                            Image(systemName: icon)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 100)
                }
                
                Section(header: Text("Gruppen Farbe*")) {
                    Picker("Farbe", selection: $groupColor) {
                        ForEach(avaibleColors, id: \.key) { key, value in
                            Text(key)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 100)
                }
                
                Section(header: Text("Gruppen Name*")) {
                    TextField("Möbel", text: $name)
                }
                
                
                Section(footer: Text("Hinweis: Um deine Gruppe zu sehen benötigt sie mindestens ein Produkt, du kannst die Produkt Gruppen in den Produkt Einstellung ändern!")) {
                    HStack(alignment: .center) {
                        Spacer()
                        Button("Gruppe hinzufügen") {
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
                        Text("Es wurden nicht alle benötigten Felder ausgefüllt!")
                            .bold()
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    
                }
            }
        }
        .navigationTitle("Neue Gruppe")
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
