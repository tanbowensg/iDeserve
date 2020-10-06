//
//  EditTaskPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI

struct EditTaskPage: View {
//    var initTask: Task?
    @State var name: String = ""
    @State var value: String = "0"
    @State var repeatFrequency: RepeatFrequency = RepeatFrequency.never
    
    @State var isShowRepeatPicker = false
    
    init (initTask: Task?) {
        if let existTask = initTask {
            _name = State(initialValue: existTask.name)
            _value = State(initialValue: String(existTask.value))
            _repeatFrequency = State(initialValue: existTask.repeatFrequency)
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
            }
            Divider()
        }
    }

    var taskDdl: some View {
        Group {
            HStack() {
                Image(systemName: "calendar")
                Text("添加截止日期")
            }
                .padding(.horizontal, 16.0)
            Divider()
        }
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
                    Text("备注")
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
                .navigationTitle("编辑任务")
//          重复频率选择器
            if isShowRepeatPicker {
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
                    }
                }
                    .background(Color.g10)
            }
        }
    }
}

struct EditTaskPage_Previews: PreviewProvider {
    static var previews: some View {
        EditTaskPage(initTask: TasksStore().tasks[0])
        EditTaskPage(initTask: nil)
    }
}
