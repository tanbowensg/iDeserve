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
    @State private var speed = 5
    @State var isShowGoalPicker = false
    @State var isShowRepeatPicker = false
    @State var isShowDatePicker = false
    @State var isShowDifficultyPicker = false

    static var goalRequest: NSFetchRequest<Goal> {
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Goal.pos, ascending: true)
        ]
        return request
    }
    
    func onAppear () {
        if taskState.goalId == nil && goals.count > 0 {
            taskState.goalId = goals[0].id!
            taskState.goalName = goals[0].name!
        }
    }

    var taskGoal: some View {
        Button(action: {
            isShowGoalPicker.toggle()
        }) {
            FormItem(icon: Image(systemName: "largecircle.fill.circle"), name: "所属目标", valueView: Text(taskState.goalName))
        }
    }
    
//    目标选择器
    var goalPicker: some View {
        return VStack(alignment: .trailing, spacing: 0) {
            Button(action: {
                isShowGoalPicker.toggle()
            }) {
                Text("确认")
            }
                .padding(8)
            Picker("所属目标", selection: $taskState.goalId) {
                ForEach(goals, id: \.id) {goalOption in
                    Text(goalOption.name!).tag(goalOption)
                }
                .labelsHidden()
            }
            .onChange (of: taskState.goalId) { selectedGoalId in
                let targetGoal = goals.first{ $0.id == selectedGoalId }
                taskState.goalName = targetGoal!.name!
             }
        }
            .background(Color.g10)
    }

    var taskTitle: some View {
        Group {
            TextField("任务标题", text: $taskState.name)
                .font(.hiraginoSansGb16)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20)
                .frame(height: 60)
            Divider()
        }
    }

    var taskDifficulty: some View {
        Button(action: {
            withAnimation {
                isShowDifficultyPicker.toggle()
            }
        }) {
            FormItem(icon: Image(systemName: "speedometer"), name: "难度", valueView: Text(getDifficultyText(taskState.difficulty)))
        }
    }
    
    var taskTimeCost: some View {
        FormItem(
            icon: Image(systemName: "timer"),
            name: "估时（小时）",
            valueView: MySlider(value: $taskState.timeCost, range: 1...10).frame(width: 150)
        )
    }

    var taskMyDay: some View {
        FormItem(
            icon: Image(systemName: "sun.max"),
            name: "在“我的一天”中显示",
            valueView: Toggle("", isOn:$taskState.starred)
        )
    }

    var taskRepeat: some View {
        Button(action: {
            isShowRepeatPicker.toggle()
        }) {
            FormItem(
                icon: Image(systemName: "repeat"),
                name: "重复频率",
                valueView: Text(getRepeatFrequencyText(taskState.repeatFrequency))
            )
        }
    }

    var repeatTimes: some View {
        FormItem(
            icon: Image(systemName: "repeat"),
            name: "重复次数",
            valueView: MySlider(value: $taskState.repeatTimes, range: 1...50).frame(width: 150)
        )
    }

    var taskDdl: some View {
        Button(action: {
            taskState.hasDdl = true
            isShowDatePicker.toggle()
        }) {
            FormItem(
                icon: Image(systemName: "calendar"),
                name: taskState.hasDdl ? "\(dateToString(taskState.ddl)) 截止" : "添加截止日期",
                valueView: EmptyView()
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
        .padding(16)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
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
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
            MyPopup(isVisible: $isShowGoalPicker, content: goalPicker, background: Color.g10)
            MyPopup(isVisible: $isShowRepeatPicker, content: repeatPicker, background: Color.g10)
            MyPopup(isVisible: $isShowDatePicker, content: datePicker, background: Color.g10)
            MyPopup(isVisible: $isShowDifficultyPicker, content: DifficultyPicker(difficulty: $taskState.difficulty, isShow: $isShowDifficultyPicker))
        }
            .onAppear(perform: onAppear)
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
