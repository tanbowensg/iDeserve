//
//  GoalItem.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/14.
//

import SwiftUI

struct GoalItemView: View {
    var goal: Goal
    var hideTasks: Bool?
    var onLeftSwipe: (() -> Void)?
    var onRightSwipe: (() -> Void)?
    
//    用来进入目标详情的
    @State var isTapped = false
//    @State var localHideTask = false
    
//    var shouldShowTask: Bool {
//        hideTasks != true && localHideTask
//    }
    
    var type: GoalType {
        GoalType(rawValue: goal.type!) ?? .hobby
    }
    
    var importance: Importance {
        Importance(rawValue: Int(goal.importance)) ?? .normal
    }
    
    var tasks: [TaskState] {
        (goal.tasks!.allObjects as! [Task]).map{ $0.ts }
    }
    
    var progress: Float {
        Float(goal.gotValue) / Float(goal.totalValue)
    }

    var goalName: some View {
        Text(goal.name!)
            .font(.bodyCustom)
            .foregroundColor(goal.color)
    }

    var importanceTag: some View {
        Text(ImportanceText[importance]!)
            .font(.captionCustom)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .foregroundColor(ImportanceColor[importance]!)
            .background(ImportanceColor[importance]!.opacity(0.3).cornerRadius(6))
    }
    
    var taskNumText: some View {
        Text("\(tasks.count) 个任务")
            .font(.captionCustom)
            .foregroundColor(.b1)
    }
    
//    var collapseButton: some View {
//        Image(systemName: "chevron.right")
//            .rotationEffect(.degrees(shouldShowTask ? 90 : 0))
//            .padding(20)
//            .font(Font.bodyCustom.weight(.bold))
//            .onTapGesture {
//                withAnimation {
//                    localHideTask.toggle()
//                }
//            }
//    }
    
    var mainView: some View {
        HStack(alignment: .center, spacing: 30.0) {
            TypeIcon(type: type.rawValue)
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    VStack(alignment: .leading, spacing: 8.0) {
                        goalName
                        
                        HStack(spacing: 12.0) {
                            importanceTag
                            taskNumText
                        }
                    }
                    Spacer()
                }
                goal.done ? nil : ProgressBar(value: progress, color: goal.color)
            }
        }
        .frame(height: GOAL_ROW_HEIGHT)
        .padding(.vertical, GOAL_ROW_PADDING)
        .padding(.horizontal, 20.0)
        .background(Color.transparent)
        .saturation(goal.done ? 0 : 1)
        .onTapGesture { isTapped.toggle() }
    }
    
//    var tasksList: some View {
//        VStack {
//            ForEach(tasks) { t in
//                TaskItem(task: t)
//            }
//        }
//    }

    var body: some View {
        VStack {
            NavigationLink(destination: EditGoalPage(initGoal: goal), isActive: $isTapped) {
                EmptyView()
            }
            SwipeWrapper(
                content: mainView,
                height: Int(GOAL_ROW_HEIGHT),
                onLeftSwipe: onLeftSwipe,
                onRightSwipe: onRightSwipe
            )
//            tasks.count > 0 && shouldShowTask ? tasksList : nil
        }
        .background(Color.transparent)
    }
}
