//
//  GoalItem.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/14.
//

import SwiftUI

struct GoalItemView: View {
    var name: String
    var type: GoalType
    var taskNum: Int
    var value: Int
    var progress: Float
    var isDone: Bool

    var body: some View {
        HStack(alignment: .center) {
            GoalIcon(goalType: type)
            VStack(alignment: .leading) {
                Text(name)
                    .strikethrough(isDone)
                    .font(.hiraginoSansGb14)
                    .padding(.bottom, 2.0)
                Text("\(taskNum) 个任务")
                    .font(.hiraginoSansGb12)
                    .foregroundColor(.g60)
                    .padding(.bottom, 4.0)
                isDone ? nil : ProgressBar(value: progress)
            }
            Spacer()
            NutIcon(value: value, hidePlus: true)
        }
        .padding(.horizontal, 20.0)
        .padding(.vertical, 8)
        .frame(height: GOAL_ROW_HEIGHT)
        .frame(maxWidth: .infinity)
        .foregroundColor(.g80)
        .background(Color.white)
    }
}

struct GoalItem_Previews: PreviewProvider {
    static var previews: some View {
        GoalItemView(name: "练出六块腹肌", type: GoalType.exercise, taskNum: 3, value: 188, progress: 0.32, isDone: false)
    }
}
