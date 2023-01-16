//
//  Lockscreen_Widgets.swift
//  Lockscreen Widgets
//
//  Created by Marvin Hülsmann on 16.01.23.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

struct Provider: IntentTimelineProvider {
    @FetchRequest(sortDescriptors: [])
    var products: FetchedResults<Products>
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), product: nil)
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        createTimelineEntry(date: Date(), configuation: configuration, completion: completion)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        createTimeline(date: Date(), configuation: configuration, completion: completion)
    }
    
    func createTimelineEntry(date: Date, configuation: ConfigurationIntent, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: date, configuration: configuation, product: Product(uuid: UUID(), name: "Apple Watch", icon: "applewatch", price: 99, date: Date()))
        completion(entry)
    }
    
    func createTimeline(date: Date, configuation: ConfigurationIntent, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entry = SimpleEntry(date: date, configuration: configuation, product: Product(uuid: UUID(), name: "Apple Watch", icon: "applewatch", price: 99, date: Date()))
        let timeline = Timeline(entries: [entry], policy: .never)
        
        for product in products {
            print(product)
        }
        
        completion(timeline)
    }
    
    func getWidgetProduct() -> Product {
        let product = products.randomElement()
        return Product(uuid: (product?.uuid)!, name: (product?.name)!, icon: (product?.icon)!, price: product!.price, date: (product?.date)!)
    }
    
    var managedObjectContext : NSManagedObjectContext
        init(context : NSManagedObjectContext) {
            self.managedObjectContext = context
        }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let product: Product?
  /*  let productPrice: Int
    let alreadyPaid: Int */
}

struct Lockscreen_WidgetsEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry
 
    var body: some View {
        switch widgetFamily {
        case .accessoryInline:
            Text(entry.product!.name)
        case .accessoryCircular:
            Gauge(value: Float(entry.product!.price), in: Float(entry.product!.price - 10)...Float(entry.product!.price + 10)) {
                Image(systemName: entry.product!.icon)
                    .padding(2)
                   } currentValueLabel: {
                       Image(systemName: entry.product!.icon)
                   } minimumValueLabel: {
                       Text("\(Int(entry.product!.price))€")
                   } maximumValueLabel: {
                       Text("")
                   }
                   .gaugeStyle(.accessoryCircular)
        default:
            Text("Not Implemented")
        }
    }
}

struct Lockscreen_Widgets: Widget {
    let kind: String = "Lockscreen_Widgets"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(context: persistentContainer.viewContext)) { entry in
            Lockscreen_WidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Produkte")
        .description("Sehe Informationen über deine Zukunftigen Produkte!")
        .supportedFamilies([.accessoryInline, .accessoryCircular])
    }
    
    
    // MARK: - Core Data stack
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Financy")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    //    container.persistentStoreDescriptions = [storeDescription]
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return container
    }()
}

struct Lockscreen_Widgets_Previews: PreviewProvider {
    static var previews: some View {
        Lockscreen_WidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), product: Product(uuid: UUID(), name: "Test", icon: "applewatch", price: 14, date: Date())))
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
            .previewDisplayName("Inline")
        
        Lockscreen_WidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), product: Product(uuid: UUID(), name: "Test", icon: "applewatch", price: 99, date: Date())))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            .previewDisplayName("Rectangle")
    }
}
