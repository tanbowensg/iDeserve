//
//  EditTaskPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI

struct EditTaskPage: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var initTask: Task?
    var tasksStore: TasksStore

    @State var name: String = ""
    @State var value: String = "0"
    @State var repeatFrequency: RepeatFrequency = RepeatFrequency.never
    @State var hasDdl: Bool = false
    @State var ddl: Date = Date()
    @State var desc = ""
    
    @State var isShowRepeatPicker = false
    @State var isShowDatePicker = false

    init (initTask: Task?, tasksStore: TasksStore) {
        self.initTask = initTask
        self.tasksStore = tasksStore
        if let existTask = initTask {
            _name = State(initialValue: existTask.name)
            _value = State(initialValue: String(existTask.value))
            _repeatFrequency = State(initialValue: existTask.repeatFrequency)
            _hasDdl = State(initialValue: existTask.ddl != nil)
            _desc = State(initialValue: existTask.desc)
            
            if let existDdl = existTask.ddl {
                _ddl = State(initialValue: existDdl)
            }
        }
    }

    var taskTitle: some View {
        Group {
            TextField("任务标题", text: $name)
                .font(.title)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 16.0)
            Divider()
        }
    }

    var taskValue: some View {
        Group {
            HStack() {
                Image(systemName: "dollarsign.circle")
                Text("分值")
                Spacer()
                TextField("0", text: $value)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
            }
                .padding(.horizontal, 16.0)
            Divider()
        }
    }

    var taskRepeat: some View {
        Group {
            Button(action: {
                isShowRepeatPicker.toggle()
            }) {
                HStack() {
                    Image(systemName: "repeat")
                    Text("重复")
                    Spacer()
                    Text(getRepeatFrequencyText(repeatFrequency))
                }
                    .padding(.horizontal, 16.0)
                    .foregroundColor(.g80)
            }
            Divider()
        }
    }

    var taskDdl: some View {
        Group {
            HStack() {
                Button(action: {
                    hasDdl = true
                    isShowDatePicker.toggle()
                }) {
                    Image(systemName: "calendar")
                    hasDdl ? Text("\(dateToString(ddl)) 截止") : Text("添加截止日期")
                    Spacer()
                }
                hasDdl ? cancelDdlBtn : nil
            }
            .padding(.horizontal, 16.0)
            .foregroundColor(.g80)
            Divider()
        }
    }
    
    var cancelDdlBtn: some View {
        Button(action: {
            hasDdl = false
            ddl = Date()
            isShowDatePicker.toggle()
        }) {
            Image(systemName: "xmark")
                .resizable()
                .foregroundColor(.g50)
                .padding(8.0)
                .frame(width: 24.0, height: 24.0)
        }
    }
    
//    重复频率选择器
    var repeatPicker: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Button(action: {
                isShowRepeatPicker.toggle()
            }) {
                Text("完成")
            }
                .padding(8)
            Picker("重复频率", selection: $repeatFrequency) {
                ForEach(RepeatFrequency.allCases, id: \.self) {repeatOption in
                    Text(getRepeatFrequencyText(repeatOption)).tag(repeatOption)
                }
                .labelsHidden()
            }
        }
            .background(Color.g10)
    }
    
//    日期选择器
    var datePicker: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Button(action: {
                isShowDatePicker.toggle()
            }) {
                Text("完成")
            }
                .padding(8)
            DatePicker(
                "日期选择",
                selection: $ddl,
                displayedComponents: .date
            )
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
        }
            .background(Color.g10)
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
    
    var saveBtn: some View {
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
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                backBtn
                taskTitle
                taskValue
                taskRepeat
                taskDdl
                Text("子任务")
                    .font(.headline)
                    .padding(.horizontal, 16.0)
                Divider()
                HStack() {
                    TextField("备注", text: $desc)
                        .padding(.horizontal, 16.0)
                }
                Spacer()
            }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
                .navigationBarHidden(true)
            Popup(isVisible: isShowRepeatPicker, content: repeatPicker)
            Popup(isVisible: isShowDatePicker, content: datePicker)
        }
    }
    
    func saveTask () {
        if name == "" {
            return
        }
        if let taskId = initTask?.id {
            tasksStore.updateTask(
                id: taskId,
                name: name,
                value: Int(value) ?? 0,
                repeatFrequency: repeatFrequency,
                ddl: hasDdl ? ddl : nil,
                desc: desc
            )
        } else {
            tasksStore.createTask(
                name: name,
                value: Int(value) ?? 0,
                repeatFrequency: repeatFrequency,
                ddl: hasDdl ? ddl : nil,
                desc: desc
            )
        }
    }
}

struct EditTaskPage_Previews: PreviewProvider {
    static var previews: some View {
        let tasksStore = TasksStore()
        EditTaskPage(initTask:tasksStore.tasks[0], tasksStore: tasksStore)
        EditTaskPage(initTask: nil, tasksStore: tasksStore)
    }
}
