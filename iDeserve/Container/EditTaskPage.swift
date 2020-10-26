//
//  EditTaskPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI
import CoreData

struct EditTaskPage: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var originTask: Task?
    @State var taskState: TaskState

//    @State var name: String = ""
//    @State var value: String = "0"
//    @State var repeatFrequency: RepeatFrequency = RepeatFrequency.never
//    @State var hasDdl: Bool = false
//    @State var ddl: Date = Date()
//    @State var desc = ""
    
    @State var isShowRepeatPicker = false
    @State var isShowDatePicker = false

    init (originTask: Task?) {
        self.originTask = originTask
        _taskState = State(initialValue: TaskState(originTask))
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
            TaskForm(taskState: $taskState)
                .navigationBarHidden(true)
        }
    }
    
    func saveTask () {
        if taskState.name == "" {
            return
        }

        if originTask?.id != nil {
            updateTask()
        } else {
            createTask()
        }
    }
    
    func updateTask () {
        let targetTask = originTask!
        targetTask.name = taskState.name
        targetTask.value = Int16(taskState.value) ?? 0
        targetTask.repeatFrequency = Int16(taskState.repeatFrequency.rawValue)
        targetTask.ddl = taskState.hasDdl ? taskState.ddl : nil
        targetTask.desc = taskState.desc

        do {
            try self.moc.save()
        } catch {
            fatalError("更新任务到 coredata中失败")
        }
    }
    
    func createTask () {
        let newTask = Task(context: self.moc)
        newTask.id = UUID()
        newTask.name = taskState.name
        newTask.value = Int16(taskState.value) ?? 0
        newTask.repeatFrequency = Int16(taskState.repeatFrequency.rawValue)
        newTask.ddl = taskState.hasDdl ? taskState.ddl : nil
        newTask.desc = taskState.desc
        newTask.done = false
        newTask.starred = false

        do {
            try self.moc.save()
        } catch {
            fatalError("创建任务到 coredata中失败")
        }
    }
}

struct EditTaskPage_Previews: PreviewProvider {
    static var previews: some View {
//        EditTaskPage(initTask:tasksStore.tasks[0])
//            .environment(\.managedObjectContext, CoreDataContainer.shared.context)
        EditTaskPage(originTask: nil)
            .environment(\.managedObjectContext, CoreDataContainer.shared.context)
    }
}
