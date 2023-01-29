//
//  SplashScreenFinacyPro.swift
//  Financy
//
//  Created by Marvin Hülsmann on 29.01.23.
//

import SwiftUI
import StoreKit

struct SplashScreenFinancyPro: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
        
                TitleFinancyView()
                
                InformationFinancyContainerView()
                
                Spacer(minLength: 30)
                
                Button(action: {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    
                    mode.wrappedValue.dismiss()
                }) {
                    Text("Durchstarten")
                        .customButton()
                }
                .padding(.horizontal)
                
                Text("Erhalte beim ersten Kauf von Financy Pro eine Probe Version von 3 Tagen.")
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


struct TitleFinancyView: View {
    var body: some View {
        VStack {
            Text("Durchstarten mit")
                .customTitleText()
            
            HStack {
                Text("Financy")
                    .customTitleText()
                    .foregroundColor(.mainColor)
                Text("Pro")
                    .fontWeight(.heavy)
                    .font(.system(size: 40))

                    .foregroundColor(.accentColor)
            }
        }
    }
}


struct InformationFinancyContainerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            InformationDetailView(title: "Bearbeiten", subTitle: "Bearbeite deine Produkte, um anpassungsfähig auf Produkt Veränderungen zu sein.", imageName: "pencil")
            
            InformationDetailView(title: "Teilen & Zusammenarbeit", subTitle: "Teile deine Produkte mit anderen oder spare mit Familienmitglieder zusammen.", imageName: "square.and.arrow.up")
            
            InformationDetailView(title: "Mehr Statistiken", subTitle: "Erhalte mehr Einsichten zu deinen Produkten und deine Transaktionen für dein neues Produkt.", imageName: "chart.bar.doc.horizontal.fill")
        }
        .padding(.horizontal)
    }
}

struct SplashScreenFinancyPro_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenFinancyPro()
    }
}

