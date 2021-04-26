//
//  TaskItem.swift
//
//  Created by 谈博文 on 2020/8/24.
//  Copyright © 2020 瞬光工作室. All rights reserved.
//

import SwiftUI
import CoreData

struct TaskItem: View {
    var task: TaskState
    var disabled: Bool?
    var onCompleteTask: (() -> Void)?
    var onRemoveTask: (() -> Void)?
    var hideTag: Bool? = false

    var foregroundColor: Color {
         task.done ? Color.gray : Color.normalText
    }
    
    var shouldShowTaskInfo: Bool {
        (hideTag != true && task.goalName != "") ||
        task.repeatFrequency != RepeatFrequency.never ||
        task.hasDdl
    }

    var taskGoal: some View {
        Text(task.goalName)
            .font(.captionCustom)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .foregroundColor(task.goalColor ?? .b3)
            .background(Color.g1.cornerRadius(7))
            .layoutPriority(0.5)
    }

    var remainTimesText: some View {
        HStack(alignment: .center, spacing: 8.0) {
            Image(systemName: "repeat")
                .font(.captionCustom)
            Text("\(task.completeTimes)/\(task.repeatTimes)")
                .font(.captionCustom)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .foregroundColor(.b3)
        .background(Color.g1.cornerRadius(7))
        .layoutPriority(1)
    }
    
    var ddlText: some View {
        HStack(alignment: .center, spacing: 8.0) {
            Image(systemName: "calendar")
                .font(.captionCustom)
            Text(dateToString(task.ddl))
                .font(.captionCustom)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .foregroundColor(.b3)
        .background(Color.g1.cornerRadius(7))
        .layoutPriority(1)
    }

//    var nextRefreshTime: some View {
//        return Text("下次刷新: \(dateToString(task.nextRefreshTime!, dateFormat: "M.dd H:mm"))")
//            .foregroundColor(.caption)
//            .fontWeight(.bold)
//            .font(.captionCustom)
//            .frame(height: 16.0)
//    }


    var taskInfo: some View {
        return HStack(spacing: 8.0) {
            (hideTag != true && task.goalName != "") ? taskGoal : nil
//            task.starred ? Image(systemName: "sun.max") : nil
            task.repeatFrequency != RepeatFrequency.never ? remainTimesText : nil
//            task.nextRefreshTime != nil ? nextRefreshTime : nil
            task.hasDdl ? ddlText : nil
        }
        .lineLimit(1)
    }

    var leftPart: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(task.name)
                .font(.subheadCustom)
                .fontWeight(.bold)
                .foregroundColor(.b4)
            shouldShowTaskInfo ? taskInfo : nil
        }
    }
    
    var taskItem: some View {
        HStack(alignment: .center) {
            leftPart
            Spacer()
            NutIcon(value: task.value, hidePlus: true)
        }
            .padding(.horizontal, 25)
            .padding(.vertical, 20)
            .frame(height: TASK_ROW_HEIGHT)
            .foregroundColor(self.foregroundColor)
            .background(Color.white.opacity(0.001))
            .saturation(task.done ? 0 : 1)
            
    }

    var body: some View {
        SwipeWrapper(
            content: taskItem,
            height: Int(TASK_ROW_HEIGHT),
            onLeftSwipe: onCompleteTask,
            onRightSwipe: onRemoveTask
        )
    }
}

struct TaskItem_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataContainer.shared.context
        let tasks = genMockTasks(context)
        ScrollView {
            VStack(spacing: 16.0) {
                ForEach (tasks) {task in
                    TaskItem(task: TaskState(task), onCompleteTask: emptyFunc, onRemoveTask: emptyFunc)
                }
            }
        }
            .padding(.top, 20.0)
            .background(Color.bg)
            .environment(\.managedObjectContext, context)
    }
}
