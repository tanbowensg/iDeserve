//
//  SwiftUIView.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/4.
//

import SwiftUI

struct TaskList: View {
    var tasks: [Task]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(tasks) {task in
                TaskRow(task: task)
                Divider()
            }
        }
    }
}

struct TaskList_Previews: PreviewProvider {
    static var previews: some View {
        TaskList(tasks: TasksStore().tasks)
    }
}
