//
//  TaskForm.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/26.
//

import SwiftUI
import Sliders
import CoreData

struct TaskForm: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(fetchRequest: goalRequest) var goals: FetchedResults<Goal>

    @Binding var taskState: TaskState
    var showGoal: Bool = false
    var onTapClose: () -> Void
    var onTapSave: () -> Void
    @State private var speed = 5
    @State var isShowRepeatPicker = false
    @State var isShowDatePicker = false

    static var goalRequest: NSFetchRequest<Goal> {
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Goal.pos, ascending: true)
        ]
        return request
    }
    
    var isEdit: Bool {
        taskState.originTask != nil
    }
    
    func onAppear () {
        if taskState.goalId == nil && goals.count > 0 {
            taskState.goalId = goals[0].id!
            taskState.goalName = goals[0].name!
        }
    }
    
    var header: some View {
        Group {
            HStack {
                Button(action: { onTapClose() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.subtitle)
                }
                Spacer()
                Text(isEdit ? "编辑任务" : "创建任务").font(.headlineCustom).foregroundColor(.body)
                Spacer()
                Button(action: { onTapSave() }) {
                    Text("保存")
                        .font(.subheadCustom)
                        .foregroundColor(.hospitalGreen)
                }
            }
            .padding(.vertical, 30.0)
            .padding(.horizontal, 25.0)
            ExDivider()
        }
    }

    var taskTitle: some View {
        Group {
            TextField("任务标题", text: $taskState.name)
                .font(.titleCustom)
                .multilineTextAlignment(.leading)
                .padding(.vertical, 20)
            ExDivider()
        }
    }

    var taskGoal: some View {
        let goalMenu = Menu {
            ForEach(goals, id: \.id) {goalOption in
                Button(action: {
                    let targetGoal = goals.first{ $0.id == goalOption.id }
                    taskState.goalName = targetGoal!.name!
                }) {
                    Text(goalOption.name!)
                }
            }
        } label: {
            HStack(spacing: 20.0) {
                Text(taskState.goalName)
                    .font(.footnoteCustom)
                Image(systemName: "chevron.down")
                    .frame(width: 16.0)
            }
            .padding(10)
            .frame(minWidth: 100)
            .frame(height: 32)
            .background(Color.white.cornerRadius(10).shadow(color: .shadow2, radius: 2, x: 0, y: 2))
        }
        .animation(.none)
        
        return Group {
            FormItem(name: "所属目标", rightContent: goalMenu)
            ExDivider()
        }
    }

    var taskDifficulty: some View {
        VStack(spacing: 0.0) {
            FormItem(name: "难度", rightContent: Text(""))
            DifficultyPicker(difficulty: $taskState.difficulty)
                .padding(.bottom, 20.0)
            ExDivider()
        }
    }
    
    var taskTimeCost: some View {
        Group {
            FormItem(name: "预计耗时", rightContent: Text("\(taskState.timeCost)小时"))
            MySlider(value: $taskState.timeCost, range: 1...10)
                .padding(.bottom, 20.0)
            ExDivider()
        }
    }

    var taskMyDay: some View {
        Group {
            FormItem(
                name: "在“我的一天”中显示",
                rightContent: Toggle("", isOn:$taskState.starred).toggleStyle(SwitchToggleStyle(tint: .hospitalGreen))
            )
            ExDivider()
        }
    }

    var taskRepeat: some View {
        Group {
            Button(action: {
                isShowRepeatPicker.toggle()
                dismissKeyboard()
            }) {
                FormItem(
                    name: "重复频率",
                    rightContent: Text(getRepeatFrequencyText(taskState.repeatFrequency))
                )
            }
            ExDivider()
        }
    }

    var repeatTimes: some View {
        Group {
            FormItem(name: "重复次数", rightContent: Text("\(taskState.repeatTimes)次"))
            MySlider(value: $taskState.repeatTimes, range: 1...50)
                .padding(.bottom, 20.0)
            ExDivider()
        }
    }

    var taskDdl: some View {
        Button(action: {
            taskState.hasDdl = true
            isShowDatePicker.toggle()
            dismissKeyboard()
        }) {
            FormItem(
                name: taskState.hasDdl ? "\(dateToString(taskState.ddl)) 截止" : "添加截止日期",
                rightContent: !taskState.hasDdl ? nil : Button(action: {
                    taskState.hasDdl = false
                    taskState.ddl = Date()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16, alignment: .center)
                })
            )
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
                .background(Color.g10.cornerRadius(12))
        }
    }
    
//    重复频率选择器
    var repeatPicker: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Button(action: {
                isShowRepeatPicker.toggle()
                dismissKeyboard()
            }) {
                Text("确认")
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
    
//    日期选择
    var datePicker: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Button(action: {
                isShowDatePicker.toggle()
            }) {
                Text("确认")
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
    
//    备注
    var taskDesc: some View {
        TextArea(placeholder: "备注", text: $taskState.desc)
            .padding(.top, 10.0)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0.0) {
                header
                ScrollView {
                    VStack(alignment: .leading, spacing: 0.0) {
                        taskTitle
                        showGoal ? taskGoal : nil
                        taskDifficulty
                        taskTimeCost
                        taskMyDay
                        taskRepeat
                        taskState.repeatFrequency != RepeatFrequency.never ? repeatTimes : nil
                        taskDdl
                        taskDesc
                    }
                    .padding(.horizontal, 25)
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .topLeading
                    )
                }
            }
            .onTapGesture {
                dismissKeyboard()
            }
            MyPopup(isVisible: $isShowRepeatPicker, content: repeatPicker, background: Color.g10)
            MyPopup(isVisible: $isShowDatePicker, content: datePicker, background: Color.g10)
        }
            .onAppear(perform: onAppear)
    }
}

struct TaskFormPreviewWrapper: View {
    @State var taskState = TaskState(nil)

    var body: some View {
        taskState.name = "赚一百万"
        return TaskForm(taskState: $taskState, showGoal: true, onTapClose: emptyFunc, onTapSave: emptyFunc)
    }
}

struct TaskForm_Previews: PreviewProvider {
    static var previews: some View {
        TaskFormPreviewWrapper()
    }
}
