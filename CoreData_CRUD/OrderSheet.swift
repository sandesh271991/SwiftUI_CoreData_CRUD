//
//  OrderSheet.swift
//  CoreData_CRUD
//
//  Created by Sandesh on 11/04/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation
import SwiftUI

struct OrderSheet: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode

    let pizzaTypes = ["Pizza Margherita", "Greek Pizza", "Pizza Supreme", "Pizza California", "New York Pizza"]

    @State var selectedPizzaIndex = 1
    @State var numberOfSlices = 1
    @State var tableNumber = ""
    
    var body: some View {
        
        NavigationView {
            Form {
                Section(header: Text("Pizza Details")){
                    Picker(selection: $selectedPizzaIndex, label: Text("Pizza Type")) {
                     
                        ForEach(0..<pizzaTypes.count){
                            Text(self.pizzaTypes[$0]).tag($0)
                        }
                    }
                    Stepper("\(numberOfSlices) Slices", value: $numberOfSlices, in: 1...12)
                }
                
                Section(header: Text("Table Number")){
                    TextField("Table Number", text: $tableNumber)
                        .keyboardType(.numberPad)
                }
                
                Button(action: {
                    
                    // CREATE
                    guard self.tableNumber != "" else { return}
                    let newOrder = Order(context: self.managedObjectContext)
                    newOrder.pizzaType = self.pizzaTypes[self.selectedPizzaIndex]
                    newOrder.numberOfSlices = Int16(self.numberOfSlices)
                    newOrder.tableNumber = self.tableNumber
                    newOrder.orderStatus = .pending
                    newOrder.id = UUID()
                    print("Add order")
                    
                    do {
                        try self.managedObjectContext.save()
                        print("Order Saved")
                        self.presentationMode.wrappedValue.dismiss()
                    } catch  {
                        print(error.localizedDescription)
                    }
                    
                }, label: {
                    Text("Add Order")
                })
            }.navigationBarTitle("Add Order")
        }
    }
}
