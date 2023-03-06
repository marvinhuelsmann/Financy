//
//  ProductPlanner.swift
//  Financy
//
//  Created by Marvin Hülsmann on 29.11.22.
//

import SwiftUI
import CoreData

struct ProductPlanner: View {
    @Environment(\.colorScheme) var colorScheme
    
    var productID: UUID
    var productName: String
    var productAmount: Int
    var productIcon: String
    
    @StateObject var storeKit = StoreKitManager()
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    var groups: FetchedResults<Groups>
    @FetchRequest(sortDescriptors: [])
    var groupedProducts: FetchedResults<GroupedProducts>
    
    @State private var showInformationView = !SettingsView().productDetailScreen
    
    var body: some View {
        VStack {
            HStack {
                AllSpendAmountDetailView(darkMode: colorScheme == .dark ? true : false, productAmount: productAmount, productID: productID)
                    .padding(.leading, 20)
                Spacer()
                GetMoneyInformationDetailView(darkMode: colorScheme == .dark ? true : false, productAmount: productAmount, productID: productID)
                    .padding(.trailing, 20)
            }
            .padding(.top, 10)
            HStack {
                WeeklySpendDetailView(darkMode: colorScheme == .dark ? true : false, productAmount: productAmount, productID: productID)
                    .padding(.leading, 5)
                Spacer()
            }
            .padding(.top, 3)
            HStack {
                Text("Transaktionen")
                    .font(.title)
                    .bold()
                    .padding(.top, 5)
                    .padding(.bottom, -10)
                    .padding(.leading, 5)
                Spacer()
            }
            TransactionDetailView(productID: productID, darkMode: colorScheme == .dark ? true : false)
            Spacer()
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    NavigationLink(destination: CreateTransaction(productID: productID)) {
                        Text("Geld hinzufügen")
                        Image(systemName: "plus")
                    }
                    NavigationLink(destination: ChangeGroup(productUUID: productID, groupName: getGroupName()!)) {
                        Text("Gruppe bearbeiten")
                        Image(systemName: "square.on.square.squareshape.controlhandles")
                    }
                    NavigationLink(destination: EditProduct(productID: productID, productName: productName, productIcon: productIcon, productPrice: String(productAmount))) {
                        Text("Produkt bearbeiten")
                        Image(systemName: "pencil")
                    }
                    .disabled(!storeKit.hasFinancyPro())
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        })
        .sheet(isPresented: $showInformationView, content: {
            SplashScreenDetailProduct(productName: productName)
        }).onAppear(perform: {
            SettingsView().productDetailScreen = true
        })
        .navigationTitle(productName)
    }
    
    func getGroupName() -> Groups? {
        for groupedProduct in groupedProducts {
            if groupedProduct.productUUID == productID {
                let groupUUID = groupedProduct.groupUUID
                
                for group in groups {
                    if group.uuid == groupUUID {
                        return group
                    }
                }
            }
        }
        return nil
        
    }
}

struct ProductPlanner_Previews: PreviewProvider {
    static var previews: some View {
        ProductPlanner(productID: UUID(), productName: "Test", productAmount: 900, productIcon: "applewatch")
    }
}

struct TransactionDetailView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.date, order: .reverse)
    ])var transactions: FetchedResults<Transactions>
    var productID: UUID
    var darkMode: Bool
    
    @State private var path: [Transactions] = []
    
    var body: some View {
            if !isTransactionIsEmpty() {
                List {
                    ForEach(transactions, id: \.self) { transaction in
                        if transaction.productID == productID {
                            NavigationLink(destination: EditTransaction(productID: transaction.productID!, money: String(transaction.money), reason: transaction.reason!, date: transaction.date!)) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(transaction.reason!)
                                            .bold()
                                        Text("\(transaction.date! > Date() ? "Planmäßig" : "Hinzugefügt") am \((((transaction.date?.formatted(.dateTime.month().day()))!)))")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Text("\(transaction.money)€")
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteProduct)
                }
                .environment(\.locale, Locale.init(identifier: "de"))
                .cornerRadius(15)
                .padding(10)
            } else {
                Spacer()
                VStack {
                    Image(systemName: "nosign.app")
                        .font(.system(size: 80))
                    Text("Fehlende Daten")
                        .font(.largeTitle)
                        .bold()
                }.padding(.bottom, 40)
            }
    }
    
    func isTransactionIsEmpty() -> Bool {
        var i = 0
        for transaction in transactions {
            if transaction.productID == productID {
                i+=1
            }
        }
        
        return i == 0
    }
    
    func saveContext(viewContext: NSManagedObjectContext) {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
    
    func deleteProduct(at offsets: IndexSet) {
        withAnimation {
            offsets.map {
                transactions[$0]
            }.forEach(viewContext.delete)
            
            saveContext(viewContext: viewContext)
        }
    }
}

struct WeeklySpendDetailView: View {
    @FetchRequest(sortDescriptors: [])
    var transactions: FetchedResults<Transactions>
    
    var darkMode: Bool
    var productAmount: Int
    var productID: UUID
    
    @State private var XYBarMarkState = SettingsView().showXYBarMark
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(SettingsView().showXYBarMark ? "Wochen Aktivität" : "Insgesamte Aktivität")
                        .foregroundColor(!darkMode ? .black : .gray)
                        .font(.callout)
                        .fontWeight(.medium)
                    Spacer()
                }
                HStack {
                    TransactionsChart(productID: productID, productPrice: productAmount, showXYBarMark: XYBarMarkState)
                }
                if trendingStatus() != "" {
                    HStack {
                        Text(trendingStatus())
                            .font(.subheadline)
                            .foregroundColor(!darkMode ? .black : .gray)
                        
                        Spacer()
                    }
                }
            }
            .padding(.leading, 5)
            .padding(9)
        }
        .onTapGesture {
            withAnimation(.linear) {
                XYBarMarkState.toggle()
                SettingsView().showXYBarMark.toggle()
            }
        }
        .frame(height: 150)
        .multilineTextAlignment(.leading)
        .background(!darkMode ? Color(UIColor.systemGroupedBackground) : Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(10)
    }
    
    func trendingStatus() -> String {
        var i = 0
        for transaction in transactions {
            if transaction.productID == productID {
                i+=1
            }
        }
        if i == 0 {
            return ""
        } else {
            if i >= 8 {
                return "Hoher aufsteigender Trend"
            } else if i >= 5 {
                return "Wachsender Trend"
            } else if i >= 2 {
                return "Aufsteigender Trend"
            }
        }
        return ""
    }
}

struct GetMoneyInformationDetailView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    private var transactions: FetchedResults<Transactions>
    
    var darkMode: Bool
    var productAmount: Int
    var productID: UUID
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("In 30 Tagen kaufen?")
                        .foregroundColor(!darkMode ? .white : .black)
                        .font(.callout)
                        .fontWeight(.medium)
                    Spacer()
                }
                HStack {
                    Text(isReadyFor30Days() ? "Bereit!" : "Nein!")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(isReadyFor30Days() ? .green : .red)
                    Spacer()
                }
                HStack {
                    Text("+\(amountOfMoneyIn30Days())€ in 30 Tagen.")
                        .font(.subheadline)
                        .foregroundColor(Color(UIColor.lightGray))
                    Spacer()
                }
            }
            .padding(.leading, 5)
            .padding(6)
        }
        .frame(width: 175)
        .multilineTextAlignment(.leading)
        .background(!darkMode ? .black : .white.opacity(0.9))
        .cornerRadius(10)
        .shadow(radius: 4)
    }
    
    func getAlreadySpendAmount() -> Int {
        var i = 0
        
        for transaction in transactions {
            if transaction.productID == productID {
                if transaction.date! <= Date() {
                    i = i + Int(transaction.money)
                }
            }
        }
        
        return i
    }
    
    func amountOfMoneyIn30Days() -> Int {
        var i = 0
        for transaction in transactions {
            if transaction.productID == productID {
                let today = Date()
                let thirtyDaysFromToday = Calendar.current.date(byAdding: .day, value: 30, to: today)!
                
                if transaction.date! >= today && transaction.date! <= thirtyDaysFromToday {
                    i = i + Int(transaction.money)
                }
            }
        }
        return i
    }
    
    func isReadyFor30Days() -> Bool {
        var i = 0
        for transaction in transactions {
            if transaction.productID == productID {
                let today = Date()
                let thirtyDaysFromToday = Calendar.current.date(byAdding: .day, value: 30, to: today)!
                
                if transaction.date! >= today && transaction.date! <= thirtyDaysFromToday {
                    i = i + Int(transaction.money)
                }
            }
        }
        
        if getAlreadySpendAmount() + i >= productAmount {
            return true
        } else {
            return false
        }
    }
}

struct AllSpendAmountDetailView: View {
    @FetchRequest(sortDescriptors: [])
    var transactions: FetchedResults<Transactions>
    
    var darkMode: Bool
    var productAmount: Int
    var productID: UUID
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Aktuelle Bilanz")
                        .foregroundColor(!darkMode ? .white : .black)
                        .font(.callout)
                        .fontWeight(.medium)
                    Spacer()
                }
                HStack {
                    Text("\(getAlreadySpendAmount())€")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(!isPriceReached() ? (isNearOnTheReachedPrice() ? .yellow : !darkMode ? .white : .black) : .green)
                    Spacer()
                }
                HStack {
                    Text("Dein Ziel:")
                        .font(.subheadline)
                        .foregroundColor(Color(UIColor.lightGray))
                    Text("\(productAmount)€" )
                        .foregroundColor(Color(UIColor.lightGray))
                        .font(.subheadline)
                        .bold()
                        .padding(.leading, -2)
                    Spacer()
                }
            }
            .padding(.leading, 5)
            .padding(6)
        }
        .frame(width: 200)
        .multilineTextAlignment(.leading)
        .background(!darkMode ? .black : .white.opacity(0.9))
        .cornerRadius(10)
        .shadow(radius: 4)
    }
    
    func getAlreadySpendAmount() -> Int {
        var i = 0
        
        for transaction in transactions {
            if transaction.productID == productID {
                if transaction.date! <= Date() {
                    i = i + Int(transaction.money)
                }
            }
        }
        
        return i
    }
    
    func isNearOnTheReachedPrice() -> Bool {
        let alreadySpendAmount = getAlreadySpendAmount()
        
        if productAmount >= 150 {
            if alreadySpendAmount + 55 >= productAmount {
                return true
            } else { return false }
        } else { return false }
    }
    
    func isPriceReached() -> Bool {
        let alreadySpendAmount = getAlreadySpendAmount()
        
        if alreadySpendAmount >= productAmount {
            return true
        } else { return false }
    }
}
