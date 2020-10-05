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
        VStack(alignment: .leading) {
            TaskList(tasks: TasksStore().tasks)
            Spacer()
        }
    }
}

struct TaskPage_Previews: PreviewProvider {
    static var previews: some View {
        TaskPage()
    }
}
