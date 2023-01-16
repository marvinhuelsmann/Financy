//
//  SettingsView.swift
//  Financy
//
//  Created by Marvin Hülsmann on 07.01.23.
//

import SwiftUI
import AuthenticationServices

struct SettingsView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    var products: FetchedResults<Products>
    
    @AppStorage("firstAppOpen") var firstAppOpen = false
    
    @AppStorage("notifications") var allowNotifications = true
    @AppStorage("secureOnLogin") var requiredPasswordIdOnLogin = false
    
    @AppStorage("widgetProduct") var widgetProduct = 1
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Allgemein"), footer: Text("Aktiviere \(getBiometricTypeName()) um beim öffnen der App zu aktivieren. Achtung: Fallst du dich nicht mehr identifizieren kannst gehen die Daten verloren!")) {
                    Toggle(getBiometricTypeName(), isOn: $requiredPasswordIdOnLogin)
                }
                
                Section(header: Text("Ermutigungen"), footer: Text("Erhalte Erinnerungen wenn du dein Produkt Ziel fast erreicht hast.")) {
                    Toggle("Benachrichtigung", isOn: $allowNotifications)
                }
                
                Section(header: Text("Widget Produkt"), footer: Text("Das Produkt, dass in den Widgets angezeigt werden soll.")) {
                    Picker("Widget", selection: $widgetProduct) {
                        ForEach(products, id: \.self) { product in
                            HStack {
                                Image(systemName: product.icon!)
                                Text(product.name!)
                            }
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
            }
        }
        .navigationTitle("Einstellungen")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
