//
//  GoalRow.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/26.
//

import SwiftUI

struct GoalRow: View {
    @ObservedObject var goal: Goal
    var forceCollapse: Bool?
    var isBeingDragged: Bool?
    var onCompleteTask: (_ task: Task) -> Void
    var onRemoveTask: (_ task: Task) -> Void
    
//    仅表示组建内部的展开状态
    @State var isExpanded = true

//    这里主要是处理拖拽的情况。进入拖拽的时候会强制收起所有的goalrow。
//    但如果当前goalrow正在被拖拽，那就免受强制收起影响
    var shouldExpand: Bool {
        return isExpanded && (forceCollapse != true || isBeingDragged == true)
    }
    
    var tasks: [Task] {
        return self.goal.tasks?.allObjects as! [Task]
    }
    
    var expandArrow: some View {
        return Button(action: {
            isExpanded.toggle()
        }) {
            Image(systemName: shouldExpand ? "chevron.down" : "chevron.right")
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
                    TaskRow(task: TaskState(task), onLongPress: onCompleteTask)
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
        VStack(alignment: .center) {
            self.goalRow
            shouldExpand ? self.taskList : nil
        }
        .frame(minHeight: shouldExpand ? nil : GOAL_ROW_HEIGHT)
        .background(Color.red)
    }
}
//
//struct GoalRow_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalRow()
//    }
//}
