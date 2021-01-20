//
//  GoalItem.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/14.
//

import SwiftUI

struct GoalItemView: View {
    var name: String
    var taskNum: Int
    var value: Int
    var progress: Float

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "gamecontroller")
                .resizable()
//                .aspectRatio(1, contentMode: .fit)
                .padding(10)
                .scaledToFit()
                .frame(width: 60.0, height: 60.0)
                .background(Color.tagBg)
                .cornerRadius(15)
                .foregroundColor(Color.tagColor)
            VStack(alignment: .leading) {
                Text(name)
                    .font(.hiraginoSansGb14)
                    .padding(.bottom, 2.0)
                Text("\(taskNum) 个任务")
                    .font(.hiraginoSansGb12)
                    .foregroundColor(.g60)
                    .padding(.bottom, 4.0)
                ProgressBar(value: progress)
            }
            Spacer()
            NutIcon(value: value)
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
        GoalItemView(name: "通关赛博朋克2077", taskNum: 3, value: 188, progress: 0.32)
    }
}
