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
    var onTap: (() -> Void)?
    var hideTag: Bool? = false

    var dateText: String? {
        return dateToString(task.ddl)
    }

    var foregroundColor: Color {
         task.done ? Color.gray : Color.normalText
    }
//    剩余的重复次数
    var remainTimes: Int {
        if let repeatTimes = Int(task.repeatTimes) {
            return repeatTimes - task.completeTimes
        }
        return 0
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
        Text("到\(dateText!)截止")
            .font(.hiraginoSansGb9)
            .fontWeight(.bold)
            .foregroundColor(.remainTextColor)
            .frame(height: 16.0)
    }
    
    var remainTimesText: some View {
        print(remainTimes)
        return Text("还要做 \(remainTimes) 次")
            .foregroundColor(.remainTextColor)
            .fontWeight(.bold)
            .font(.hiraginoSansGb9)
            .frame(height: 16.0)
    }

    var taskInfo: some View {
        return HStack {
            task.starred ? Image(systemName: "sun.max") : nil
            remainTimes > 0 ? remainTimesText : nil
            task.hasDdl ? ddlText : nil
        }
    }

    var leftPart: some View {
        VStack(alignment: .leading, spacing: 5) {
            (hideTag == true || task.goalName == "") ? nil : taskGoal
            Text(task.name)
                .font(.hiraginoSansGb12)
                .fontWeight(.bold)
                .frame(height: 24.0)
            taskInfo
        }
    }
    
    var taskValue: some View {
        HStack(alignment: .center, spacing: 3.0) {
            Text("+\(String(task.value))")
                .font(.system(size: 14))
                .fontWeight(.black)
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
                    .shadow(color: .shadow, radius: 6, x: 0, y: 3)
            )
            .onTapGesture {
                if onTap != nil {
                    onTap!()
                }
            }
    }

    var body: some View {
        SwipeWrapper(
            content: taskItem,
            height: 82,
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
