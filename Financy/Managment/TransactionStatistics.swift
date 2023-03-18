//
//  TransactionStatistics.swift
//  Financy
//
//  Created by Marvin Hülsmann on 18.03.23.
//

import SwiftUI
import Charts

struct TransactionStatistics: View {
    @Environment(\.colorScheme) var colorScheme
    
    @FetchRequest(sortDescriptors: [])
    private var transactions: FetchedResults<Transactions>
    
    @FetchRequest(sortDescriptors: [])
    private var products: FetchedResults<Products>
    
    var body: some View {
        VStack {
            
            VStack {
                HStack {
                    Text("\(allTimeTransactionAmount().formatted() + CurrencyLibary().getSpecificIcon())")
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.cyan]), startPoint: .top, endPoint: .bottom))
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding(.bottom, -8)
                    Spacer()
                }
                VStack {
                    VStack {
                        HStack {
                            StatisticTransactionView()
                        }
                    }
                    .padding(.leading, 5)
                    .padding(9)
                }
                .frame(height: 95)
                .background(colorScheme != .dark ? Color(UIColor.systemGroupedBackground) : Color(uiColor: .secondarySystemGroupedBackground))
                .cornerRadius(10)
                HStack {
                    Text("statistics.alltime \(allTimeTransactionAmount().formatted() + CurrencyLibary().getSpecificIcon())")
                        .foregroundColor(colorScheme != .dark ? Color(UIColor.darkGray) : .gray)
                        .font(.body)
                        .padding(.top, 1)
                    Spacer()
                }
            }
            .multilineTextAlignment(.leading)
            .padding(13)
            
            VStack {
                HStack {
                    Text("\(allTimeProductsPrice().formatted() + CurrencyLibary().getSpecificIcon())")
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.red]), startPoint: .top, endPoint: .bottom))
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding(.bottom, -8)
                    Spacer()
                }
                VStack {
                    VStack {
                        HStack {
                            StatisticProductsView()
                        }
                    }
                    .padding(.leading, 5)
                    .padding(9)
                }
                .frame(height: 95)
                .background(colorScheme != .dark ? Color(UIColor.systemGroupedBackground) : Color(uiColor: .secondarySystemGroupedBackground))
                .cornerRadius(10)
                HStack {
                    Text("statistics.products \(allTimeProductsPrice().formatted() + CurrencyLibary().getSpecificIcon())")
                        .foregroundColor(colorScheme != .dark ? Color(UIColor.darkGray) : .gray)
                        .font(.body)
                        .padding(.top, 1)
                    Spacer()
                }
            }
            .multilineTextAlignment(.leading)
            .padding(13)
        
            Spacer()
        }
        .navigationTitle("products.statistics")
    }
    
    func allTimeTransactionAmount() -> Int {
        var amount: Int = 0
        for transaction in transactions {
            amount = amount + Int(transaction.money)
        }
        
        return amount
    }
    
    func allTimeProductsPrice() -> Int {
        var amount: Int = 0
        for product in products {
            amount = amount + Int(product.price)
        }
        
        return amount
    }
}

struct StatisticTransactionView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    private var transactions: FetchedResults<Transactions>
    
    var body: some View {
        VStack {
            if !isTransactionIsEmpty() {
                    Chart(transactions) { transaction in
                        BarMark(
                            x: .value("Price", transaction.money)
                        )
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.cyan]), startPoint: .top, endPoint: .bottom))
                    }
                    .chartXScale(domain: 0...allTimeTransactionAmount() * Int(2.5))
            } else {
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "eye.trianglebadge.exclamationmark")
                            .font(.system(size: 30))
                        Text("transaction.noinfo")
                            .bold()
                            .font(.title)
                        Text("transaction.nodata")
                            .fontWeight(.regular)
                            .font(.footnote)
                    }
                    Spacer()
                }
            }
        }
    }
    
    func allTimeTransactionAmount() -> Int {
        var amount: Int = 0
        for transaction in transactions {
            amount = amount + Int(transaction.money)
        }
        
        return amount
    }
    
    func isTransactionIsEmpty() -> Bool {
        var i = 0
        for _ in transactions {
            i+=1
        }
        
        return i == 0
    }
}

struct StatisticProductsView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    private var products: FetchedResults<Products>
    
    var body: some View {
        VStack {
            if !isProductEmpty() {
                    Chart(products) { product in
                        BarMark(
                            x: .value("Price", product.price)
                        )
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.red]), startPoint: .top, endPoint: .bottom))
                    }
                    .chartXScale(domain: 0...allTimeProductsPrice() * Int(3))
            } else {
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "eye.trianglebadge.exclamationmark")
                            .font(.system(size: 30))
                        Text("transaction.noinfo")
                            .bold()
                            .font(.title)
                        Text("transaction.nodata")
                            .fontWeight(.regular)
                            .font(.footnote)
                    }
                    Spacer()
                }
            }
        }
    }
    
    func allTimeProductsPrice() -> Int {
        var amount: Int = 0
        for product in products {
            amount = amount + Int(product.price)
        }
        
        return amount
    }
    
    func isProductEmpty() -> Bool {
        var i = 0
        for _ in products {
            i+=1
        }
        
        return i == 0
    }
}

struct TransactionStatistics_Previews: PreviewProvider {
    static var previews: some View {
        TransactionStatistics()
    }
}
