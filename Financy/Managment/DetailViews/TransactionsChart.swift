//
//  TransactionsChart.swift
//  Financy
//
//  Created by Marvin Hülsmann on 30.11.22.
//

import SwiftUI
import Charts

struct TransactionsChart: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    private var transactions: FetchedResults<Transactions>
    var productID: UUID
    var productPrice: Int
    
    var showXYBarMark: Bool
    
    var body: some View {
        VStack {
            if !isTransactionIsEmpty() {
                if showXYBarMark {
                    Chart(transactions) { transaction in
                        if transaction.productID == productID {
                            BarMark(
                                x: .value("Date", (transaction.date?.formatted(.dateTime.weekday(.wide)))!),
                                y: .value("Price", transaction.money)
                            )
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.orange, Color.purple]), startPoint: .top, endPoint: .bottom))
                        }
                    }
                } else {
                    Chart(transactions) { transaction in
                        if transaction.productID == productID {
                            BarMark(
                                x: .value("Price", transaction.money)
                            )
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .top, endPoint: .bottom))
                        }
                    }
                    .chartXScale(domain: 0...productPrice)
                }
            
            
            } else {
                VStack {
                    Spacer()
                    Image(systemName: "eye.trianglebadge.exclamationmark")
                        .font(.system(size: 30))
                    Text("Keine Bilanz")
                        .bold()
                        .font(.title)
                    Text("Zu wenig Daten gesammelt.")
                        .fontWeight(.regular)
                        .font(.footnote)
                    Spacer()
                }
            }
        }
    }
    
    func isTransactionIsEmpty() -> Bool {
        var i = 0
        for transaction in transactions {
            if transaction.productID == productID {
                i+=1
            }
        }
        
        if !showXYBarMark {
            return i == 0
        } else {
            return i < 2
        }
    }
}

struct TransactionsChart_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsChart(productID: UUID(), productPrice: 900, showXYBarMark: false)
    }
}
