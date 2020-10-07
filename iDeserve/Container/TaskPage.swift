//
//  TaskPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI

struct TaskPage: View {
    @ObservedObject var tasksStore = TasksStore()
    
    func removeTask (index: IndexSet) {
        let taskId = tasksStore.tasks[index.first!].id
        tasksStore.deleteTask(id: taskId)
    }

    var body: some View {
        NavigationView() {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach (tasksStore.tasks) { task in
                        NavigationLink(destination: EditTaskPage(initTask: task, tasksStore: tasksStore)) {
                            TaskRow(task: task)
                        }
                    }
                    .onDelete(perform: removeTask)
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: EditTaskPage(initTask: nil, tasksStore: tasksStore)) {
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
    }
}
