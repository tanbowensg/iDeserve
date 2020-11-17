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
    var onLongPress: ((_ task: Task) -> Void)?

    @GestureState var isDetectingLongPress = false
    @State var completedLongPress = false

    var dateText: String? {
        return dateToString(task.ddl)
    }

    var foregroundColor: Color {
         task.done ? Color.gray : Color.normalText
    }

    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 0.8)
            .updating($isDetectingLongPress) { currentstate, gestureState,
                    transaction in
                gestureState = currentstate
                transaction.animation = Animation.easeIn(duration: 0.8)
            }
            .onEnded { finished in
                print("长按结束了")
                self.completedLongPress = finished
                self.onLongPress?(task.originTask!)
            }
    }
    
    var taskGoal: some View {
        Text("考出CPA证书")
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
        Text("\(dateText!)截止")
            .font(.system(size: 10))
            .fontWeight(.bold)
            .foregroundColor(Color.warning)
            .frame(height: 16.0)
    }

    var taskInfo: some View {
        return HStack {
            task.starred ? Image(systemName: "star.fill") : nil
            task.repeatFrequency != RepeatFrequency.never ? Image(systemName: "repeat") : nil
            task.hasDdl ? ddlText : nil
        }
    }

    var leftPart: some View {
        VStack(alignment: .leading, spacing: 5) {
            taskGoal
            Text(task.name)
                .font(.system(size: 14))
                .fontWeight(.bold)
                .frame(height: 24.0)
            taskInfo
        }
    }
    
    var taskValue: some View {
        Text("+\(String(task.value))")
            .font(.system(size: 14))
            .fontWeight(.black)
            .foregroundColor(Color.goldColor)
    }

    var body: some View {
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
            .gesture(longPress)
    }
}

struct TaskItem_Previews: PreviewProvider {
    static var previews: some View {
        let context = NSPersistentContainer(name: "iDeserve").viewContext
        let tasks = genMockTasks(context)
        ScrollView {
            VStack(spacing: 16.0) {
                ForEach (tasks) {task in
                    TaskItem(task: TaskState(task))
                }
            }
        }
            .padding(.top, 20.0)
            .background(Color.bg)
            .environment(\.managedObjectContext, context)
    }
}