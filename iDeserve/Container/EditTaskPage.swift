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
    
    var initTask: Task?

    @State var name: String = ""
    @State var value: String = "0"
    @State var repeatFrequency: RepeatFrequency = RepeatFrequency.never
    @State var hasDdl: Bool = false
    @State var ddl: Date = Date()
    @State var desc = ""
    
    @State var isShowRepeatPicker = false
    @State var isShowDatePicker = false

    init (initTask: Task?) {
        self.initTask = initTask
        if let existTask = initTask {
            _name = State(initialValue: existTask.name ?? "")
            _value = State(initialValue: String(existTask.value))
            _repeatFrequency = State(initialValue: RepeatFrequency(rawValue: Int(existTask.repeatFrequency)) ?? .never)
            _hasDdl = State(initialValue: existTask.ddl != nil)
            _desc = State(initialValue: existTask.desc ?? "")
            
            if let existDdl = existTask.ddl {
                _ddl = State(initialValue: existDdl)
            }
        }
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
            TaskForm(name: $name, value: $value, repeatFrequency: $repeatFrequency, hasDdl: $hasDdl, ddl: $ddl, desc: $desc)
                .navigationBarHidden(true)
        }
    }
    
    func saveTask () {
        if name == "" {
            return
        }

        if initTask?.id != nil {
            updateTask()
        } else {
            createTask()
        }
    }
    
    func updateTask () {
        let targetTask = initTask!
        targetTask.name = name
        targetTask.value = Int16(value) ?? 0
        targetTask.repeatFrequency = Int16(repeatFrequency.rawValue)
        targetTask.ddl = hasDdl ? ddl : nil
        targetTask.desc = desc

        do {
            try self.moc.save()
        } catch {
            fatalError("更新任务到 coredata中失败")
        }
    }
    
    func createTask () {
        let newTask = Task(context: self.moc)
        newTask.id = UUID()
        newTask.name = name
        newTask.value = Int16(value) ?? 0
        newTask.repeatFrequency = Int16(repeatFrequency.rawValue)
        newTask.ddl = hasDdl ? ddl : nil
        newTask.desc = desc
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
        EditTaskPage(initTask: nil)
            .environment(\.managedObjectContext, CoreDataContainer.shared.context)
    }
}
