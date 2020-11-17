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
         task.done ? Color.gray : Color.black
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

    var taskInfo: some View {
        return HStack {
            task.starred ? Image(systemName: "star.fill") : nil
            task.repeatFrequency != RepeatFrequency.never ? Image(systemName: "repeat") : nil
            task.hasDdl ? Text("\(dateText!)截止") : nil
        }
    }

    var leftPart: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(task.name)
            taskInfo
        }
    }

    var body: some View {
        HStack {
            leftPart
            Spacer()
            Text(String(task.value))
                .foregroundColor(Color.red)
        }
            .padding()
            .background(self.isDetectingLongPress && !task.done ? Color.green : Color.g0)
            .foregroundColor(self.foregroundColor)
            .gesture(longPress)
    }
}

struct TaskItem_Previews: PreviewProvider {
    static var previews: some View {
        let context = NSPersistentContainer(name: "iDeserve").viewContext
        let tasks = genMockTasks(context)
        VStack(spacing: 16.0) {
            ForEach (tasks) {task in
                TaskItem(task: TaskState(task))
            }
        }
            .environment(\.managedObjectContext, context)
    }
}
