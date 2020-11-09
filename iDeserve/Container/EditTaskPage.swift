//
//  EditTaskPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI
import CoreData

struct EditTaskPage: View {
    @EnvironmentObject var gs: GlobalStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var originTask: Task?
    var goal: Goal?
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
            let _ = gs.taskStore.updateTask(targetTask: originTask!, taskState: taskState)
        } else {
            let _ = gs.taskStore.createTask(taskState: taskState, goal: goal)
        }
    }
}

struct EditTaskPage_Previews: PreviewProvider {
    static var previews: some View {
        EditTaskPage(originTask: nil)
            .environment(\.managedObjectContext, CoreDataContainer.shared.context)
    }
}
