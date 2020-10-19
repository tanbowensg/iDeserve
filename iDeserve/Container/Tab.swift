//
//  Nav.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI
//import CoreData

struct Tab: View {
//    @ObservedObject var pointsStore = PointsStore()
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
      // 2.
      entity: Point.entity(),
      // 3.
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Point.value, ascending: true)
      ]
      //,predicate: NSPredicate(format: "genre contains 'Action'")
      // 4.
    ) var points: FetchedResults<Point>

//    var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "SampleApp")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()

    func TabIcon (text: String, icon: String) -> some View {
        VStack() {
            Image(systemName: icon)
                .frame(width: 32, height: 32)
            Text(text)
                .font(.system(size: 12))
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(String(points.count))
                Button(action: {
                    addPoints()
                }) {
                    /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                }
            }
            TabView {
                TaskPage().tabItem { TabIcon(text: "任务", icon: "list.dash") }
                RewardPage().tabItem { TabIcon(text: "奖励", icon: "dollarsign.circle") }
                TaskPage().tabItem { TabIcon(text: "任务", icon: "list.dash") }
                TaskPage().tabItem { TabIcon(text: "任务", icon: "list.dash") }
            }
            .edgesIgnoringSafeArea(.top)
        }
    }

    func addPoints() {
        // 1
        let newPoint = Point(context: managedObjectContext)

        // 2
        newPoint.value = 100
        
        // 3
        saveContext(context: managedObjectContext)
    }
}

struct Tab_Previews: PreviewProvider {
    static var previews: some View {
        VStack() {
            Tab()
        }
    }
}
