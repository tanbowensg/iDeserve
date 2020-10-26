//
//  TaskForm.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/26.
//

import SwiftUI

struct TaskForm: View {
    @Binding var taskState: TaskState
    
    @State var isShowRepeatPicker = false
    @State var isShowDatePicker = false

    var taskTitle: some View {
        Group {
            TextField("任务标题", text: $taskState.name)
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
                TextField("0", text: $taskState.value)
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
                    Text(getRepeatFrequencyText(taskState.repeatFrequency))
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
                    taskState.hasDdl = true
                    isShowDatePicker.toggle()
                }) {
                    Image(systemName: "calendar")
                    taskState.hasDdl ? Text("\(dateToString(taskState.ddl)) 截止") : Text("添加截止日期")
                    Spacer()
                }
                taskState.hasDdl ? cancelDdlBtn : nil
            }
                .padding(.horizontal, 16.0)
                .foregroundColor(.g80)
            Divider()
        }
    }
    
    var cancelDdlBtn: some View {
        Button(action: {
            taskState.hasDdl = false
            taskState.ddl = Date()
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
            Picker("重复频率", selection: $taskState.repeatFrequency) {
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
                selection: $taskState.ddl,
                displayedComponents: .date
            )
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
        }
            .background(Color.g10)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                taskTitle
                taskValue
                taskRepeat
                taskDdl
                Text("子任务")
                    .font(.headline)
                    .padding(.horizontal, 16.0)
                Divider()
                HStack() {
                    TextField("备注", text: $taskState.desc)
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
            Popup(isVisible: isShowRepeatPicker, content: repeatPicker)
            Popup(isVisible: isShowDatePicker, content: datePicker)
        }
    }
}

struct TaskFormPreviewWrapper: View {
    @State var taskState = TaskState(nil)

    var body: some View {
        TaskForm(taskState: $taskState)
    }
}

struct TaskForm_Previews: PreviewProvider {
    static var previews: some View {
        TaskFormPreviewWrapper()
    }
}
