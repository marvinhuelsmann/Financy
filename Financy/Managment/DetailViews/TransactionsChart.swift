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
    
    var body: some View {
        VStack {
            if !isTransactionIsEmpty() {
                Chart(transactions) { transaction in
                    if transaction.productID == productID {
                        BarMark(
                            x: .value("Date", (transaction.date?.formatted(.dateTime.weekday(.wide)))!),
                            y: .value("Price", transaction.money)
                        )
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.orange]), startPoint: .top, endPoint: .bottom))
                    }
                }
            } else {
                VStack {
                    Spacer()
                    Image(systemName: "eye.trianglebadge.exclamationmark")
                        .font(.system(size: 30))
                    Text("Keine Bilanz")
                        .bold()
                        .font(.title)
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
        
        return i == 0
    }
}

struct TransactionsChart_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsChart(productID: UUID())
    }
}
