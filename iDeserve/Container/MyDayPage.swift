//
//  MyDayPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/11/12.
//

import SwiftUI
import CoreData

struct MyDayPage: View {
    @FetchRequest(fetchRequest: taskRequest) var tasks: FetchedResults<Task>

    static var taskRequest: NSFetchRequest<Task> {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = []
        return request
   }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach (tasks, id: \.id) { task in
                    TaskRow(task: TaskState(task))
                }
            }
        }
    }
}

struct MyDayPage_Previews: PreviewProvider {
    static var previews: some View {
        let context = NSPersistentContainer(name: "iDeserve").viewContext
        let _ = genMockTasks(context)
        MyDayPage()
            .environment(\.managedObjectContext, context)
    }
}
