//
//  TaskRow.swift
//
//  Created by 谈博文 on 2020/8/24.
//  Copyright © 2020 瞬光工作室. All rights reserved.
//

import SwiftUI

struct TaskRow: View {
    @ObservedObject var task: Task
    var onLongPress: ((_ task: Task) -> Void)?

    @GestureState var isDetectingLongPress = false
    @State var completedLongPress = false

    var dateText: String? {
        if let ddl = task.ddl {
            return dateToString(ddl)
        }
        return nil
    }

    var foregroundColor: Color {
         task.done ? Color.gray : Color.black
    }

    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 3)
            .updating($isDetectingLongPress) { currentstate, gestureState,
                    transaction in
                gestureState = currentstate
                transaction.animation = Animation.easeIn(duration: 1.0)
            }
            .onEnded { finished in
                print("长按结束了")
                self.completedLongPress = finished
                self.onLongPress?(task)
            }
    }

    var taskInfo: some View {
        return HStack {
            task.starred ? Image(systemName: "star.fill") : nil
            task.repeatFrequency != RepeatFrequency.never.rawValue ? Image(systemName: "repeat") : nil
            dateText != nil ? Text("\(dateText!)截止") : nil
        }
    }

    var leftPart: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(task.name!)
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

//struct TaskRow_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskRow(task: TasksStore().tasks[0])
//            .previewLayout(.fixed(width: 414, height: 64))
//        TaskRow(task: TasksStore().tasks[1])
//            .previewLayout(.fixed(width: 414, height: 64))
//        TaskRow(task: TasksStore().tasks[2])
//            .previewLayout(.fixed(width: 414, height: 64))
//        TaskRow(task: TasksStore().tasks[3])
//            .previewLayout(.fixed(width: 414, height: 64))
////            .environmentObject(TasksStore())
//    }
//}
