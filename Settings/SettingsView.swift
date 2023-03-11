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
    @State private var showingAppRestartAlert = false
    
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
                    Picker("currency.name", selection: $currency) {
                        ForEach(aviableCurrencies, id: \.key) { key, value in
                            Text(LocalizedStringKey(key))
                        }
                    }
                    .onChange(of: currency) { _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showingAppRestartAlert.toggle()
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section(header: Text("settings.products.header"), footer: Text("settings.products.footer")) {
                    ForEach(storeKit.storeProducts) { product in
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
                
                Section(header: Text("settings.version.header \(Financy().getFinancyVersion())"), footer: Text("settings.version.footer")) {
                    
                }
                
            }
        }
        .alert(isPresented: $showingAppRestartAlert) {
            Alert(title: Text("settings.alert.title"), message: Text("settings.alert.message"), dismissButton: .default(Text("Ok!")))
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
