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
                    Text("splashscreen.financy.start")
                        .customButton()
                }
                .padding(.horizontal)
                
                Text("splashscreen.financy.footer")
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
            Text("splashscreen.financy.welcome")
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
            InformationDetailView(title: "splashscreen.financy.info.edit.title", subTitle: "splashscreen.financy.info.edit.subTitle", imageName: "pencil")
            
            InformationDetailView(title: "splashscreen.financy.info.share.title", subTitle: "splashscreen.financy.info.share.subTitle", imageName: "square.and.arrow.up")
            
            InformationDetailView(title: "splashscreen.financy.info.products.title", subTitle: "splashscreen.financy.info.products.subTitle", imageName: "chart.bar.doc.horizontal.fill")
        }
        .padding(.horizontal)
    }
}

struct SplashScreenFinancyPro_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenFinancyPro()
    }
}

