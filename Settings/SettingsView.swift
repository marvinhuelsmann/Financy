//
//  SettingsView.swift
//  Financy
//
//  Created by Marvin Hülsmann on 07.01.23.
//

import SwiftUI
import AuthenticationServices
import StoreKit
import LocalAuthentication

struct SettingsView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    var products: FetchedResults<Products>
    
    @AppStorage("firstAppOpen") var firstAppOpen = false
    
    @AppStorage("notifications") var allowNotifications = true
    @AppStorage("secureOnLogin") var requiredPasswordIdOnLogin = false
    
    @AppStorage("XYBarMark") var showXYBarMark = false
    @AppStorage("productDetailInformation") var productDetailScreen = false
    
    @AppStorage("currency") var currency = "currency.euro"
    
    @StateObject var storeKit = StoreKitManager()
    @State private var aviableCurrencies = CurrencyLibary().getAvaibleCurrencies().shuffled()
    
    @State private var showFinancyProInformation = false
    @State private var isInAuth = false
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("settings.auth.header"), footer: Text("settings.auth.footer \(getBiometricTypeName())")) {
                    Toggle(getBiometricTypeName(), isOn: $requiredPasswordIdOnLogin)
                        .onTapGesture {
                            authenticate()
                        }
                }
                
                Section(header: Text("settings.notify.header"), footer: Text("settings.notify.footer")) {
                    Toggle("settings.notify.button", isOn: $allowNotifications)
                }
                
                Section(header: Text("currency.name"), footer: Text("settings.currency.footer")) {
                    Picker("Icon", selection: $currency) {
                        ForEach(aviableCurrencies, id: \.key) { key, value in
                            Text(LocalizedStringKey(key))
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                
                Button("settings.financypro.button", action: {
                    showFinancyProInformation.toggle()
                })
                
                Button("settings.products.reestablished", action: {
                    Task {
                        //This call displays a system prompt that asks users to authenticate with their App Store credentials.
                        //Call this function only in response to an explicit user action, such as tapping a button.
                        try? await AppStore.sync()
                    }
                })
                
                Section(header: Text("settings.version.header \(Financy().getFinancyVersion() + " (" + Financy().getBuildNumber() + ")")"), footer: Text("settings.version.footer")) {
                    
                }
                
            }
        }
        .navigationTitle("settings.navigationTitle")
        .sheet(isPresented: $showFinancyProInformation, content: {
            SplashScreenFinancyPro()
        })
        .blur(radius: !self.isInAuth ? 0 : 2)
    }
    
    func authenticate() {
        isInAuth = true
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) || context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Um Zugriff auf deine Geldeingänge und Produkte zu haben."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        isInAuth = false
                    } else {
                        isInAuth = false
                        requiredPasswordIdOnLogin.toggle()
                    }
                }
            }
        } else {
            isInAuth = false
            requiredPasswordIdOnLogin.toggle()
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
