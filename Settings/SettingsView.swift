//
//  SettingsView.swift
//  Financy
//
//  Created by Marvin Hülsmann on 07.01.23.
//

import SwiftUI
import AuthenticationServices
import StoreKit

struct SettingsView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    var products: FetchedResults<Products>
    
    @AppStorage("firstAppOpen") var firstAppOpen = false
    
    @AppStorage("notifications") var allowNotifications = true
    @AppStorage("secureOnLogin") var requiredPasswordIdOnLogin = false
    
    @StateObject var storeKit = StoreKitManager()
    
    @State private var showFinancyProInformation = false
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Allgemein"), footer: Text("Aktiviere \(getBiometricTypeName()) um beim öffnen der App zu aktivieren. Achtung: Fallst du dich nicht mehr identifizieren kannst gehen die Daten verloren!")) {
                    Toggle(getBiometricTypeName(), isOn: $requiredPasswordIdOnLogin)
                }
                
                Section(header: Text("Ermutigungen"), footer: Text("Erhalte Erinnerungen wenn du dein Produkt Ziel fast erreicht hast.")) {
                    Toggle("Benachrichtigung", isOn: $allowNotifications)
                }
                
                Section(header: Text("Abonnements"), footer: Text("Mit dem Kauf eines Abonnements unterstützt du Financy und seinen Entwickler.")) {
                    ForEach(storeKit.storeProducts) {product in
                        HStack {
                            Text(product.displayName)
                                .bold()
                            Spacer()
                            Button(action: {
                                // purchase this product
                                Task { try await storeKit.purchase(product)
                                }
                            }) {
                                CourseItem(storeKit: storeKit, product: product)
                            }
                        }
                    }
                }
                
                
                Button("Vorteile von Financy Pro", action: {
                    showFinancyProInformation.toggle()
                })
                
                Button("Abonnement wiederherstellen", action: {
                    Task {
                        //This call displays a system prompt that asks users to authenticate with their App Store credentials.
                        //Call this function only in response to an explicit user action, such as tapping a button.
                        try? await AppStore.sync()
                    }
                })
                
            }
        }
        .navigationTitle("Einstellungen")
        .sheet(isPresented: $showFinancyProInformation, content: {
            SplashScreenFinancyPro()
        })
    }
}

struct CourseItem: View {
    @ObservedObject var storeKit : StoreKitManager
    @State var isPurchased: Bool = false
    var product: Product
    
    var body: some View {
        VStack {
            if isPurchased {
                Text(Image(systemName: "checkmark"))
                    .bold()
                    .padding(10)
            } else {
                Text(product.displayPrice)
                    .padding(10)
            }
        }
        .onChange(of: storeKit.purchasedCourses) { course in
            Task {
                isPurchased = (try? await storeKit.isPurchased(product)) ?? false
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
