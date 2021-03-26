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

    var body: some View {
        TaskForm(
            taskState: $newTaskState,
            showGoal: true,
            onTapClose: { self.presentationMode.wrappedValue.dismiss() },
            onTapSave: {
                saveTask()
                self.presentationMode.wrappedValue.dismiss()
            }
        ).id(newTaskState.id)
    }
}
