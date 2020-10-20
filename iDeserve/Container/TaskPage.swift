//
//  TaskPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI
import CoreData

struct TaskPage: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var pointsStore = PointsStore()

    @FetchRequest(fetchRequest: taskRequest) var tasks: FetchedResults<Task>

    static var taskRequest: NSFetchRequest<Task> {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = []
        return request
   }

    func removeTask (at offsets: IndexSet) {
        for index in offsets {
            let task = tasks[index]
            moc.delete(task)
        }
    }
//
//    func completeTask (_ task: Task) {
//        pointsStore.minus(task.value)
//    }

    var body: some View {
        NavigationView() {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach (tasks, id: \.id) { task in
                        NavigationLink(destination: EditTaskPage(initTask: task)) {
                            TaskRow(task: task)
                        }
                    }
                    .onDelete(perform: removeTask)
//                    .id(refreshingID)
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: EditTaskPage(initTask: nil)) {
                            CreateButton()
                        }
                    }
                    .padding(.trailing, 16)
                }
                .padding(.bottom, 16)
            }
                .navigationBarHidden(true)
        }
    }
}

struct TaskPage_Previews: PreviewProvider {
    static var previews: some View {
        TaskPage()
            .environment(\.managedObjectContext, CoreDataContainer.shared.context)
    }
}
