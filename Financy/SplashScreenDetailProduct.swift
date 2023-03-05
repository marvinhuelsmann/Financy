//
//  SplashScreenDetailProduct.swift
//  Financy
//
//  Created by Marvin Hülsmann on 04.03.23.
//

import SwiftUI
import StoreKit

struct SplashScreenDetailProduct: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var productName: String
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
        
                TitleProductView()
                
                InformationProductContainerView()
                
                Spacer(minLength: 30)
                
                Button(action: {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    
                    mode.wrappedValue.dismiss()
                }) {
                    Text(productName + " ansehen")
                        .customButton()
                }
                .padding(.horizontal)
                
                Text("Manche Funktionen sind nur mit Financy Pro verfügbar*")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.leading)
                    .padding(.trailing)
                
            }
            .padding(.top, 100)
           

        }
    }
}


struct TitleProductView: View {
    var body: some View {
        VStack {
            Text("Hilfe zu den")
                .customTitleText()
            
            HStack {
                Text("Funktionen")
                    .customTitleText()
                    .foregroundColor(.mainColor)
            }
        }
    }
}


struct InformationProductContainerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            InformationDetailView(title: "Drücken", subTitle: "Drücke auf die Statistik, um weitere Details einzusehen.", imageName: "hand.point.up.left")
            
            InformationDetailView(title: "Änderungen", subTitle: "Auf den drei Punkten in der oberen rechten Ecke kannst du dein Produkt bearbeiten und Geld hinzufügen.", imageName: "plus.app")
            
            InformationDetailView(title: "Statistiken", subTitle: "Im unteren Bereich der Ansicht, siehst du deine Transaktionen, diese kannst du bearbeiten oder löschen.", imageName: "chart.pie")
        }
        .padding(.horizontal)
    }
}

struct SplashScreenDetailProduct_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenFinancyPro()
    }
}


