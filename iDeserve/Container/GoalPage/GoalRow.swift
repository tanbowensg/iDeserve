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

    @State private var refreshing = false
    var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    
//    仅表示组建内部的展开状态
    @State var isExpanded = true

//    这里主要是处理拖拽的情况。进入拖拽的时候会强制收起所有的goalrow。
    var shouldExpand: Bool {
        return isExpanded && forceCollapse != true
    }
    
    var tasks: [Task] {
        return self.goal.tasks?.allObjects as! [Task]
    }
    
    var value: Int {
        getImportanceValue(Importance(rawValue: Int(goal.importance)) ?? Importance.normal)
    }
    
    var expandArrow: some View {
        return Button(action: {
            isExpanded.toggle()
        }) {
            Image(systemName: shouldExpand ? "chevron.down" : "chevron.right")
        }
    }
    
    var goalValue: some View {
        HStack(alignment: .center, spacing: 3.0) {
            Text("+\(String(value))")
                .font(.system(size: 14))
                .fontWeight(.black)
                .foregroundColor(Color.goldColor)
            Image("NutIcon")
                .resizable()
                .frame(width: 16.0, height: 16.0)
                .padding(/*@START_MENU_TOKEN@*/.all, 2.0/*@END_MENU_TOKEN@*/)
        }
        .padding(.trailing, 30.0)
    }
    
    var goalRow: some View {
        HStack {
            self.expandArrow
            Text(goal.name ?? "")
            Spacer()
            goalValue
        }
        .background(Color.white)
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
//                .buttonStyle(PlainButtonStyle())
            }
            //无用，纯粹为了在任务更新时刷新目标，否则 TaskItem 的 task 不会更新
            Text(self.refreshing ? "" : "")
        }
            .frame(height: shouldExpand ? nil : 0)
            .onReceive(self.didSave) { _ in
                self.refreshing.toggle()
            }
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            NavigationLink(destination: EditGoalPage(initGoal: goal)) {
                SwipeWrapper(
                    content: goalRow,
                    height: Int(GOAL_ROW_HEIGHT),
                    onLeftSwipe: onCompleteGoal,
                    onRightSwipe: onRemoveGoal
                )
            }
            shouldExpand && tasks.count > 0 ? self.taskList : nil
        }
        .frame(minHeight: shouldExpand ? nil : GOAL_ROW_HEIGHT)
        .background(Color.white)
    }
    
    func onCompleteGoal () {
        gs.goalStore.completeGoal(goal)
    }
    
    func onRemoveGoal () {
        gs.goalStore.removeGoal(goal)
    }
}
