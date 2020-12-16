//
//  MyDayCreateTaskSheet.swift.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/12/15.
//

import SwiftUI

struct MyDayCreateTaskSheet: View {
    @EnvironmentObject var gs: GlobalStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var newTaskState = TaskState(nil)
    
    func saveTask () {
        if newTaskState.name == "" {
            return
        }

        let _ = gs.taskStore.createTask(taskState: newTaskState)
    }

    var backBtn: some View {
        Button(action: {
            self.saveTask()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .padding(.leading, 16.0)
                    
                Text("返回")
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            backBtn
            TaskForm(taskState: $newTaskState, showGoal: true)
        }
    }
}

//struct GoalTasksSheetPreviewWrapper: View {
//    @State var taskState = TaskState(nil)
//
//    var body: some View {
//        GoalTasksSheet(taskState: $taskState)
//    }
//}
//
//struct GoalTasksSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalTasksSheetPreviewWrapper()
//    }
//}
