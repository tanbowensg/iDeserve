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
    
    init (initTask: Task?) {
        if let existTask = initTask {
            _name = State(initialValue: existTask.name)
            print("init了")
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
                Text("50")
            }
                .padding(.horizontal, 16.0)
            Divider()
        }
    }
    
    var taskRepeat: some View {
        Group {
            HStack() {
                Image(systemName: "repeat")
                Text("重复")
                Spacer()
                Text("不重复")
            }
                .padding(.horizontal, 16.0)
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
    }
}

struct EditTaskPage_Previews: PreviewProvider {
    static var previews: some View {
        EditTaskPage(initTask: TasksStore().tasks[0])
        EditTaskPage(initTask: nil)
    }
}
