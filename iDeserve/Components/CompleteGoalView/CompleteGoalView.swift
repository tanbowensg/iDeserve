//
//  CompleteGoalView.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/2/25.
//

import SwiftUI

struct CompleteGoalView: View {
    var goalReward: GoalReward?
    
    var mainView: some View {
        VStack(spacing: 6.0) {
            Image(systemName: "checkmark.seal")
                .resizable()
                .foregroundColor(.hospitalGreen)
                .frame(width: 200.0, height: 200.0)
            VStack(spacing: 6.0) {
                HStack {
                    Text("完成目标奖励").font(.avenirBlack14)
                    Spacer()
                    NutIcon(value: goalReward!.basicReward, hidePlus: true)
                }
                HStack {
                    Text("在截至前完成任务").font(.avenirBlack14)
                    Spacer()
                    NutIcon(value: goalReward!.beforeDdlReward, hidePlus: true)
                }
                HStack {
                    Text("完成全部重复次数").font(.avenirBlack14)
                    Spacer()
                    NutIcon(value: goalReward!.allRpeatReward, hidePlus: true)
                }
                Divider()
                HStack {
                    Text("总计").font(.avenirBlack14)
                    Spacer()
                    NutIcon(value: goalReward!.totalReward, hidePlus: true)
                }
            }
            .padding([.top, .leading, .trailing], 16)
            
            Divider().padding(.bottom, 10.0)

            Button(action: {
                
            }) {
                Text("好！")
                    .font(.avenirBlack14)
                    .foregroundColor(.white)
                    .frame(width: 100.0, height: 40.0)
                    .background(Color.rewardColor)
                    .cornerRadius(20)
            }
        }
        .padding(.vertical, 16)
        .frame(width: 300.0)
        .background(Color.white.cornerRadius(16))
    }

    var body: some View {
        goalReward != nil ? mainView : nil
    }
}

struct CompleteGoalView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteGoalView(goalReward: GoalReward(importance: Importance.epic, basicRewardBase: 500, allRpeatRewardBase: 100, beforeDdlRewardBase: 200))
    }
}
