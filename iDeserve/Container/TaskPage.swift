//
//  TaskPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI

struct TaskPage: View {
//    @EnvironmentObject private var tasksStore: TasksStore

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading) {
                TaskList(tasks: TasksStore().tasks)
                Spacer()
            }
            CreateButton()
                .offset(x: -32, y: -32)
        }
    }
}

struct TaskPage_Previews: PreviewProvider {
    static var previews: some View {
        TaskPage()
    }
}
