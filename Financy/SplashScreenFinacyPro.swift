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
    @StateObject var storeKit = StoreKitManager()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
        
                TitleFinancyView()
                
                InformationFinancyContainerView()
                
                Spacer(minLength: 30)
                
                
                ForEach(storeKit.storeProducts) { product in
                    HStack {
                        Spacer()
                        Button(action: {
                            // purchase this product
                            Task { try await storeKit.purchase(product)
                            }
                        }) {
                            SubscriptionView(storeKit: storeKit, product: product)
                        }
                    }
                }
                
                Text("splashscreen.financy.footer \(CurrencyLibary().getSpecificIcon())")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.leading)
                    .padding(.trailing)
                
                Spacer()
                
                HStack {
                    Link("Terms of Service",
                         destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                    Spacer()
                    Link("Privacy Policy",
                         destination: URL(string: "https://marvhuelsmann.com/financy-tracking")!)
                }
                .padding(.top, 20)
                .padding(.trailing, 40)
                .padding(.leading, 40)
                
            }
            .padding(.top, 110)
           

        }
    }
}

struct SubscriptionView: View {
    @ObservedObject var storeKit : StoreKitManager
    @State var isPurchased: Bool = false
    var product: Product
    
    var body: some View {
        VStack {
            if isPurchased {
                HStack {
                    Spacer()
                    Text(Image(systemName: "checkmark"))
                        .font(.title)
                        .bold()
                        .padding(10)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            } else {
                Button(action: {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    
                    Task { try await storeKit.purchase(product) }

                }) {
                    Text("splashscreen.financy.start \(String(product.price.formatted() + CurrencyLibary().getSpecificIcon()))")
                        .customButton()
                }
                .padding(.horizontal)
            }
        }
        .onChange(of: storeKit.purchasedCourses) { course in
            Task {
                isPurchased = (try? await storeKit.isPurchased(product)) ?? false
            }
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
            
          //  InformationDetailView(title: "splashscreen.financy.info.share.title", subTitle: "splashscreen.financy.info.share.subTitle", imageName: "square.and.arrow.up")
            
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

