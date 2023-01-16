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
                NavigationLink(destination: CreateTransaction(productID: productID)) {
                    Text("Geld hinzufügen")
                }
            }
        })
        .navigationTitle(productName)
    }
}

struct ProductPlanner_Previews: PreviewProvider {
    static var previews: some View {
        ProductPlanner(productID: UUID(), productName: "Test", productAmount: 900)
    }
}

struct TransactionDetailView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.date, order: .reverse)
    ])var transactions: FetchedResults<Transactions>
    var productID: UUID
    var darkMode: Bool
    
    var body: some View {
        if !isTransactionIsEmpty() {
            List {
                ForEach(transactions, id: \.self) { transaction in
                    if transaction.productID == productID {
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
                .onDelete(perform: deleteProduct)
            }.refreshable {
                
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
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Wochen Aktivität")
                        .foregroundColor(!darkMode ? .black : .white)
                        .font(.callout)
                        .fontWeight(.medium)
                    Spacer()
                }
                HStack {
                    TransactionsChart(productID: productID)
                    
                }
                HStack {
                    Text(trendingStatus())
                        .font(.subheadline)
                        .foregroundColor(!darkMode ? .black : .white)
                    
                    Spacer()
                }
            }
            .padding(.leading, 5)
            .padding(9)
        }
        .frame(height: 150)
        .multilineTextAlignment(.leading)
        .background(!darkMode ? Color(UIColor.systemGroupedBackground) : Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(10)
    }
    
    func trendingStatus() -> String {
        if transactions.isEmpty {
            return "Kein Trend"
        } else {
            if transactions.count >= 8 {
                return "Hoher aufsteigender Trend"
            } else if transactions.count >= 4 {
                return "Aufsteigender Trend"
            } else if transactions.count >= 2 {
                return "Langsamer Trend"
            }
        }
        return "Kein Trend"
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
                        .foregroundColor(isReadyFor30Days() ? .green : .yellow)
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
        .background(!darkMode ? .black : .white)
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
                    Text(String(getAlreadySpendAmount()) + "€")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(!isPriceReached() ? (isNearOnTheReachedPrice() ? .yellow : !darkMode ? .white : .black) : .green)
                    Spacer()
                }
                HStack {
                    Text("Dein Ziel:")
                        .font(.subheadline)
                        .foregroundColor(Color(UIColor.lightGray))
                    Text(String(productAmount) + "€" )
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
        .background(!darkMode ? .black : .white)
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
