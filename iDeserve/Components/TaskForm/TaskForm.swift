//
//  TaskForm.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/26.
//

import SwiftUI
import CoreData

struct TaskForm: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(fetchRequest: goalRequest) var goals: FetchedResults<Goal>

    @Binding var taskState: TaskState
    var showGoal: Bool = false
    
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

    var taskGoal: some View {
        Group {
            Button(action: {
                isShowGoalPicker.toggle()
            }) {
                HStack() {
                    Image(systemName: "repeat")
                    Text("所属目标")
                    Spacer()
                    Text(taskState.goalName)
                }
                    .padding(.horizontal, 16.0)
                    .foregroundColor(.g80)
            }
            Divider()
        }
    }
    
//    目标选择器
    var goalPicker: some View {
        return VStack(alignment: .trailing, spacing: 0) {
            Button(action: {
                isShowGoalPicker.toggle()
            }) {
                Text("完成")
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
                .font(.title)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 16.0)
            Divider()
        }
    }

    var taskDifficulty: some View {
        Group {
            Button(action: {
                isShowDifficultyPicker.toggle()
            }) {
                HStack() {
                    Image(systemName: "repeat")
                    Text("难度")
                    Spacer()
                    Text(getDifficultyText(taskState.difficulty))
                }
                    .padding(.horizontal, 16.0)
                    .foregroundColor(.g80)
            }
            Divider()
        }
    }
    
//    难度选择器
    var difficultyPicker: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Button(action: {
                isShowDifficultyPicker.toggle()
//                tempTask = Task()
            }) {
                Text("完成")
            }
                .padding(8)
            Picker("难度", selection: $taskState.difficulty) {
                ForEach(Difficulty.allCases, id: \.self) {difficultyOption in
                    Text(getDifficultyText(difficultyOption)).tag(difficultyOption)
                }
                .labelsHidden()
            }
        }
            .background(Color.g10)
    }
 
    
    var taskTimeCost: some View {
        Group {
            HStack() {
                Image(systemName: "time")
                Text("耗时（单位半个小时）")
                Spacer()
                TextField("1", text: $taskState.timeCost)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
            }
                .padding(.horizontal, 16.0)
            Divider()
        }
    }

    var repeatTimes: some View {
        Group {
            HStack() {
                Image(systemName: "repeat")
                Text("重复次数")
                Spacer()
                TextField("0", text: $taskState.repeatTimes)
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
                    Text("重复频率")
                    Spacer()
                    Text(getRepeatFrequencyText(taskState.repeatFrequency))
                }
                    .padding(.horizontal, 16.0)
                    .foregroundColor(.g80)
            }
            Divider()
            taskState.repeatFrequency != RepeatFrequency.never ? repeatTimes : nil
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

    var taskMyDay: some View {
        Group {
            HStack() {
                Button(action: {
                    taskState.starred.toggle()
                }) {
                    Image(systemName: "sun.max")
                    taskState.starred ? Text("从“我的一天”移除") : Text("添加到“我的一天”")
                    Spacer()
                }
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
                showGoal ? taskGoal : nil
                taskDifficulty
                taskTimeCost
                taskMyDay
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
//                Spacer()
            }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
            Popup(isVisible: isShowGoalPicker, content: goalPicker)
            Popup(isVisible: isShowRepeatPicker, content: repeatPicker)
            Popup(isVisible: isShowDatePicker, content: datePicker)
            Popup(isVisible: isShowDifficultyPicker, content: difficultyPicker)
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
