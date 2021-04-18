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
    var importance: Importance
    var taskNum: Int
    var value: Int
    var progress: Float
    var isDone: Bool
    var onLeftSwipe: (() -> Void)?
    var onRightSwipe: (() -> Void)?
    
    var goalName: some View {
        Text(name)
            .strikethrough(isDone)
            .font(.titleCustom)
            .foregroundColor(Color.init(type.rawValue))
    }

    var importanceTag: some View {
        Text(ImportanceText[importance]!)
            .font(.captionCustom)
            .fontWeight(.bold)
            .foregroundColor(ImportanceColor[importance]!)
            .padding(.vertical, 5)
            .padding(.horizontal, 9)
            .background(ImportanceColor[importance]!.opacity(0.3).cornerRadius(6))
    }
    
    var taskNumText: some View {
        Text("\(taskNum) 个任务")
            .font(.captionCustom)
            .foregroundColor(.caption)
    }
    
    var mainView: some View {
        HStack(alignment: .center, spacing: 30.0) {
            GoalIcon(goalType: type)
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    VStack(alignment: .leading, spacing: 8.0) {
                        goalName
                        
                        HStack(spacing: 12.0) {
                            importanceTag
                            taskNumText
                        }
                    }
                    Spacer()
                    NutIcon(value: value, hidePlus: true)
                }
                isDone ? nil : ProgressBar(value: progress)
            }
        }
        .padding(.horizontal, 20.0)
        .padding(.vertical, 8)
        .frame(height: GOAL_ROW_HEIGHT)
        .background(Color.white)
    }

    var body: some View {
        SwipeWrapper(
            content: mainView,
            height: Int(GOAL_ROW_HEIGHT),
            onLeftSwipe: onLeftSwipe,
            onRightSwipe: onRightSwipe
        )
    }
}

struct GoalItem_Previews: PreviewProvider {
    static var previews: some View {
        GoalItemView(name: "练出六块腹肌", type: GoalType.exercise, importance: .epic, taskNum: 3, value: 188, progress: 0.32, isDone: false)
    }
}
