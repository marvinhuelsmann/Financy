//
//  FinancyApp.swift
//  Financy
//
//  Created by Marvin Hülsmann on 29.11.22.
//

import SwiftUI
import LocalAuthentication

@main
struct FinancyApp: App {
    let persistenceContainer = PersistenceController.shared
    
    @State private var isUnlocked = false
    @State private var showInformationsView = !SettingsView().firstAppOpen
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .blur(radius: self.isUnlocked || !SettingsView().requiredPasswordIdOnLogin ? 0 : 17)
                .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
                .sheet(isPresented: $showInformationsView, content: {
                    SplashScreen()
                }).onAppear(perform: {
                    SettingsView().firstAppOpen = true
                })
                .onAppear(perform: authenticate)
        }
    }
    
    func authenticate() {
        if SettingsView().requiredPasswordIdOnLogin {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) || context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                let reason = "Um Zugriff auf deine Geldeingänge und Produkte zu haben."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    DispatchQueue.main.async {
                        if success {
                            isUnlocked = true
                        } else {
                            isUnlocked = false
                        }
                    }
                }
            } else {
                isUnlocked = false
            }
        }
    }
}
