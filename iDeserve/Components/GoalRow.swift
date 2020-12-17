//
//  GoalRow.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/26.
//

import SwiftUI

struct GoalRow: View {
    @EnvironmentObject var gs: GlobalStore
    @ObservedObject var goal: Goal
    var forceCollapse: Bool?
    
//    仅表示组建内部的展开状态
    @State var isExpanded = true

//    这里主要是处理拖拽的情况。进入拖拽的时候会强制收起所有的goalrow。
    var shouldExpand: Bool {
        return isExpanded && forceCollapse != true
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
        .frame(height: GOAL_ROW_HEIGHT)
    }
    
    var taskList: some View {
        VStack {
            ForEach(tasks, id: \.id) { task in
                NavigationLink(destination: EditTaskPage(originTask: task)) {
                    TaskItem(
                        task: TaskState(task),
                        onCompleteTask: {
                            self.gs.taskStore.completeTask(task)
                            
                        },
                        onRemoveTask: {
                            withAnimation {
                                self.gs.taskStore.removeTask(task)
                            }
                        }
                    )
                }
            }
        }
        .frame(height: shouldExpand ? nil : 0)
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            self.goalRow
            shouldExpand && tasks.count > 0 ? self.taskList : nil
        }
        .frame(minHeight: shouldExpand ? nil : GOAL_ROW_HEIGHT)
        .background(Color.white)
    }
}
//
//struct GoalRow_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalRow()
//    }
//}
