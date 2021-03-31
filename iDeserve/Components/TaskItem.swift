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
    
    var height: Int {
//        TODO: 这里的magicnumber都是写死的，等视觉确定了，再改
        var base = 58
        if task.repeatFrequency != RepeatFrequency.never || task.hasDdl || task.starred {
            base += 16
        }
        if hideTag != true {
            base += 24
        }
        return base
    }

    var foregroundColor: Color {
         task.done ? Color.gray : Color.normalText
    }

    var taskGoal: some View {
        Text(task.goalName)
            .font(.system(size: 10))
            .fontWeight(.bold)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .foregroundColor(Color.tagColor)
            .background(Color.tagBg)
            .frame(height: 18.0)
            .cornerRadius(9)
    }
    
    var ddlText: some View {
        Text("到\(dateToString(task.ddl))截止")
            .font(.captionCustom)
            .fontWeight(.bold)
            .foregroundColor(.remainTextColor)
            .frame(height: 16.0)
    }
    
    var remainTimesText: some View {
        return Text("\(task.completeTimes)/\(task.repeatTimes)次")
            .foregroundColor(.remainTextColor)
            .fontWeight(.bold)
            .font(.captionCustom)
            .frame(height: 16.0)
    }
    
    var nextRefreshTime: some View {
        return Text("下次刷新: \(dateToString(task.nextRefreshTime!, dateFormat: "M.dd H:mm"))")
            .foregroundColor(.remainTextColor)
            .fontWeight(.bold)
            .font(.captionCustom)
            .frame(height: 16.0)
    }


    var taskInfo: some View {
        return HStack {
            task.starred ? Image(systemName: "sun.max") : nil
            task.repeatFrequency != RepeatFrequency.never ? remainTimesText : nil
            task.nextRefreshTime != nil ? nextRefreshTime : nil
            task.hasDdl ? ddlText : nil
        }
    }

    var leftPart: some View {
        VStack(alignment: .leading, spacing: 5) {
            (hideTag == true || task.goalName == "") ? nil : taskGoal
            Text(task.name)
                .font(.footnoteCustom)
                .fontWeight(.bold)
                .frame(height: 24.0)
            taskInfo
        }
    }
    
    var taskValue: some View {
        HStack(alignment: .center, spacing: 3.0) {
            Text(String(task.value))
                .font(.system(size: 14))
                .fontWeight(.bold)
                .foregroundColor(Color.rewardColor)
            Image("NutIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 16.0, height: 16.0)
                .padding(.all, 2.0)
        }
    }
    
    var taskItem: some View {
        HStack {
            leftPart
            Spacer()
            taskValue
        }
            .padding(.horizontal, 30.0)
            .padding(.vertical, 15.0)
            .foregroundColor(self.foregroundColor)
            .background(
                Color.g0
                    .shadow(color: .lightShadow, radius: 6, x: 0, y: 3)
            )
    }

    var body: some View {
        SwipeWrapper(
            content: taskItem,
            height: height,
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
