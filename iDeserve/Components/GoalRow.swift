//
//  GoalRow.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/26.
//

import SwiftUI

struct GoalRow: View {
    @ObservedObject var goal: Goal
    
    @State var isExpanded = true
    
//    var taskStates: [TaskState] {
//        let tasks = self.goal.tasks?.allObjects as! [Task]
//        let states =  tasks.map {task in
//            return TaskState(task)
//        }
//        print("任务名称: \(goal.name)")
//        print(states)
//        return states
//    }
    
    var tasks: [Task] {
        print(self.goal.tasks?.allObjects)
        return self.goal.tasks?.allObjects as! [Task]
    }
    
    var expandArrow: some View {
        return Button(action: {
            isExpanded.toggle()
        }) {
            Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
        }
    }
    
    var goalRow: some View {
        HStack {
            self.expandArrow
            Text(goal.name ?? "")
            Spacer()
        }
    }
    
    var taskList: some View {
        ForEach(tasks, id: \.id) { task in
            NavigationLink(destination: EditTaskPage(originTask: task)) {
                TaskRow(task: TaskState(task))
            }
        }
        .onDelete(perform: { indexSet in
            print(indexSet)
        })
    }

    var body: some View {
        VStack(alignment: .leading) {
            self.goalRow
            isExpanded ? self.taskList : nil
        }
    }
}

//struct GoalRow_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalRow()
//    }
//}
