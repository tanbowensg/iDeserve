//
//  TaskRow.swift
//
//  Created by 谈博文 on 2020/8/24.
//  Copyright © 2020 瞬光工作室. All rights reserved.
//

import SwiftUI

struct TaskRow: View {
//    @EnvironmentObject private var tasksStore: TasksStore
    var task: Task

    var foregroundColor: Color {
         task.done ? Color.gray : Color.black
    }

//    func toggleTask (id: String) {
//        print(id)
//        tasksStore.toggleTaskDone(id: id)
//    }
    
    var taskInfo: some View {
        HStack {
            task.starred ? Image(systemName: "star.fill") : nil
            task.repeatable ? Image(systemName: "repeat") : nil
            task.ddl != nil ? Text("\(task.ddl!)截止") : nil
        }
    }

    var leftPart: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(task.name)
            taskInfo
        }
    }

    var body: some View {
        HStack {
            leftPart
            Spacer()
            Text(String(task.value))
                .foregroundColor(Color.red)
        }
            .padding()
            .foregroundColor(self.foregroundColor)
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        TaskRow(task: TasksStore().tasks[0])
            .previewLayout(.fixed(width: 414, height: 64))
        TaskRow(task: TasksStore().tasks[1])
            .previewLayout(.fixed(width: 414, height: 64))
        TaskRow(task: TasksStore().tasks[2])
            .previewLayout(.fixed(width: 414, height: 64))
        TaskRow(task: TasksStore().tasks[3])
            .previewLayout(.fixed(width: 414, height: 64))
//            .environmentObject(TasksStore())
    }
}
