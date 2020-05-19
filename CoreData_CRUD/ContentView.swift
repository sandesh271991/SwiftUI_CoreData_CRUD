//
//  ContentView.swift
//  CoreData_CRUD
//
//  Created by Sandesh on 11/04/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var showOrderSheet = false
    @Environment(\.managedObjectContext) var managedObjectContext
    
    
    //FETCH
    @FetchRequest(
        entity: Order.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "status != %@", Status.completed.rawValue)
    )
    var orders: FetchedResults<Order>
    
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(orders){ order in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(order.pizzaType) - (\(order.numberOfSlices)) Slices")
                                .font(.headline)
                            Text("Table \(order.tableNumber)")
                                .font(.subheadline)
                        }
                        Spacer()
                        Button(action: {
                            self.updateOrder(order: order)
                            print("Update order")
                            
                        }) {
                            Text(order.orderStatus == .pending ? "Prepare" : "Complete")
                                .foregroundColor( order.orderStatus == .pending ? .red : .blue )
                        }
                    }
                }
                    //DELETE
                .onDelete { indexSet in
                    for index in indexSet {
                        self.managedObjectContext.delete(self.orders[index])
                    }
                }            }
                .navigationBarTitle("My Orders")
                .navigationBarItems(trailing: Button(action: {
                    print("Open order sheet")
                    self.showOrderSheet = true
                }, label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 32, height: 32, alignment: .center)
                }))
        }
        .sheet(isPresented: $showOrderSheet) {
            OrderSheet().environment(\.managedObjectContext, self.managedObjectContext)
        }
        
        
    }
    
    // UPDATE
    func updateOrder(order: Order) {
        let newStatus = order.orderStatus == .pending ? Status.preparing : Status.completed
        order.orderStatus = newStatus
        try? managedObjectContext.save()
        print("order updated")
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)        
    }
}
