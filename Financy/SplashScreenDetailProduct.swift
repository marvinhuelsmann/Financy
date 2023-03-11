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
                    Text("splashscreen.product.start \(productName)")
                        .customButton()
                }
                .padding(.horizontal)
                
                Text("splashscreen.product.footer")
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
            Text("splashscreen.product.welcome.title")
                .customTitleText()
            
            HStack {
                Text("splashscreen.product.welcome.footer")
                    .customTitleText()
                    .foregroundColor(.mainColor)
            }
        }
    }
}


struct InformationProductContainerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            InformationDetailView(title: "splashscreen.product.info.touch.title", subTitle: "splashscreen.product.info.touch.subTitle", imageName: "hand.point.up.left")
            
            InformationDetailView(title: "splashscreen.product.info.edit.title", subTitle: "splashscreen.product.info.edit.subTitle", imageName: "plus.app")
            
            InformationDetailView(title: "splashscreen.product.info.statistics.title", subTitle: "splashscreen.product.info.statistics.subTitle", imageName: "chart.pie")
        }
        .padding(.horizontal)
    }
}

struct SplashScreenDetailProduct_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenFinancyPro()
    }
}


