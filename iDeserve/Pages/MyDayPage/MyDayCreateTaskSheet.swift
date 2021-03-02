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

    @State var newTaskState: TaskState
    
    init(task: Task?) {
        print("init")
//        从我的一天创建的任务默认添加到我的一天
        var taskState = TaskState(task ?? nil)
        if task == nil {
            taskState.starred = true
        }
        _newTaskState = State(initialValue: taskState)
    }
    
    func saveTask () {
        if newTaskState.name == "" {
            return
        }
        
        if let originTask = newTaskState.originTask {
            let _ = gs.taskStore.updateTask(targetTask: originTask, taskState: newTaskState)
        } else {
            let _ = gs.taskStore.createTask(taskState: newTaskState)
        }
    }

    var backBtn: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("返回")
                    .frame(height: 30)
            }
        }
    }
    
    var saveBtn: some View {
        Button(action: {
            self.saveTask()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("保存")
                .frame(height: 30)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            HStack {
                backBtn
                Spacer()
                saveBtn
            }
            .padding(.horizontal, 16.0)
            TaskForm(taskState: $newTaskState, showGoal: true).id(newTaskState.id)
        }
    }
}
