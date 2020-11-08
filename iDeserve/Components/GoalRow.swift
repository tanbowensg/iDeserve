//
//  GoalRow.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/26.
//

import SwiftUI

struct GoalRow: View {
    @ObservedObject var goal: Goal
    var onRemoveTask: (_ task: Task) -> Void
    
    @State var isExpanded = true
    
    var tasks: [Task] {
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
            NavigationLink(destination: EditGoalPage(initGoal: goal)) {
                Text(goal.name ?? "")
                Spacer()
            }
        }
    }
    
    var taskList: some View {
        List {
            ForEach(tasks, id: \.id) { task in
                NavigationLink(destination: EditTaskPage(originTask: task)) {
                    TaskRow(task: TaskState(task))
                }
            }
            .onDelete(perform: { indexSet in
                for index in indexSet {
                    let task = tasks[index]
                    onRemoveTask(task)
                }
            })
        }
        .frame(height: CGFloat(tasks.count * 64))
    }

    var body: some View {
        VStack(alignment: .leading) {
            self.goalRow
            isExpanded ? self.taskList : nil
            Spacer()
        }
    }
}
//
//struct GoalRow_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalRow()
//    }
//}
