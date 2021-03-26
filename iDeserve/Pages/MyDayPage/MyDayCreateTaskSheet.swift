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
            Image(systemName: "xmark")
                .foregroundColor(.subtitle)
        }
    }
    
    var saveBtn: some View {
        Button(action: {
            self.saveTask()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("保存")
                .font(.subheadCustom)
                .foregroundColor(.hospitalGreen)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            HStack {
                backBtn
                Spacer()
                Text("创建任务").font(.headlineCustom).foregroundColor(.body)
                Spacer()
                saveBtn
            }
            .padding(.vertical, 30.0)
            .padding(.horizontal, 25.0)
            ExDivider()
            TaskForm(taskState: $newTaskState, showGoal: true).id(newTaskState.id)
        }
    }
}
