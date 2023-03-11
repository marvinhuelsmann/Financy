//
//  SplashScreen.swift
//  Financy
//
//  Created by Marvin Hülsmann on 07.01.23.
//

import SwiftUI

struct SplashScreen: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State private var notificationHandler = NotificationHandler()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
        
                TitleView()
                
                InformationContainerView()
                
                Spacer(minLength: 30)
                
                Button(action: {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    
                    mode.wrappedValue.dismiss()
                }) {
                    Text("splashscreen.start")
                        .customButton()
                }
                .padding(.horizontal)
                
                Text("splashscreen.footer")
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


struct InformationDetailView: View {
    var title: LocalizedStringKey = "title"
    var subTitle: LocalizedStringKey = "subTitle"
    var imageName: String = "car"
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: imageName)
                .font(.largeTitle)
                .foregroundColor(.mainColor)
                .padding()
                .accessibility(hidden: true)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .accessibility(addTraits: .isHeader)
                
                Text(subTitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.top)
    }
}

struct TitleView: View {
    var body: some View {
        VStack {
            Text("splashscreen.welcome")
                .customTitleText()
            
            Text("Financy")
                .customTitleText()
                .foregroundColor(.mainColor)
        }
    }
}

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.headline)
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(Color.mainColor))
            .padding(.bottom)
    }
}

extension View {
    func customButton() -> ModifiedContent<Self, ButtonModifier> {
        return modifier(ButtonModifier())
    }
}

extension Text {
    func customTitleText() -> Text {
        self
            .fontWeight(.black)
            .font(.system(size: 36))
    }
}

extension Color {
    static var mainColor = Color(UIColor.systemIndigo)
}

struct InformationContainerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            InformationDetailView(title: "splashscreen.info.plan.title", subTitle: "splashscreen.info.plan.subTitle", imageName: "list.bullet.rectangle")
            
            InformationDetailView(title: "splashscreen.info.notify.title", subTitle: "splashscreen.info.notify.subTitle", imageName: "bell")
            
            InformationDetailView(title: "splashscreen.info.privacy.title", subTitle: "splashscreen.info.privacy.subTitle", imageName: "lock")
        }
        .padding(.horizontal)
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}

