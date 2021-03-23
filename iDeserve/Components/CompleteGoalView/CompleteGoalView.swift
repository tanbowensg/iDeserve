//
//  CompleteGoalView.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/2/25.
//

import SwiftUI

struct CompleteGoalView: View {
    var goalReward: GoalReward?
    var onClose: () -> Void
    var openHelp: () -> Void
    
//    展示数据
    @State var isShowResult = false

    var mainView: some View {
        VStack(spacing: 6.0) {
            HStack {
                Spacer()
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 16)
                    .onTapGesture {
                        openHelp()
                    }
            }
            Image(systemName: "checkmark.seal")
                .resizable()
                .foregroundColor(.hospitalGreen)
                .frame(width: 200.0, height: 200.0)

            Text(goalReward?.name ?? "")
                .font(.hiraginoSansGb16)

            if isShowResult {
                VStack(spacing: 6.0) {
                    HStack {
                        Text("\(getImportanceText(goalReward!.importance))目标固定奖励").font(.avenirBlack14)
                        Spacer()
                        NutIcon(value: goalReward!.fixedReward, hidePlus: true)
                    }
                    HStack {
                        Text("完成目标加成奖励").font(.avenirBlack14)
                        Spacer()
                        NutIcon(value: goalReward!.basicReward, hidePlus: true)
                    }
                    HStack {
                        Text("在截止前完成任务").font(.avenirBlack14)
                        Spacer()
                        NutIcon(value: goalReward!.beforeDdlReward, hidePlus: true)
                    }
                    HStack {
                        Text("完成全部重复次数").font(.avenirBlack14)
                        Spacer()
                        NutIcon(value: goalReward!.allRpeatReward, hidePlus: true)
                    }
                    VStack(spacing: 6.0) {
                        Divider()
                        HStack {
                            Text("总计").font(.avenirBlack14)
                            Spacer()
                            NutIcon(value: goalReward!.totalReward, hidePlus: true)
                        }
                    }
                }
                .padding([.top, .leading, .trailing], 16)
            }
            
            Divider().padding(.bottom, 10.0)
            
            Firework(onTap: { onClose() }, content: {
                Text("完成！")
                    .font(.avenirBlack14)
                    .foregroundColor(.white)
                    .frame(width: 100.0, height: 40.0)
                    .background(Color.rewardColor)
                    .cornerRadius(20)
            })
            .frame(width: 100.0, height: 40.0)
        }
        .padding(.vertical, 16)
        .frame(width: 300.0)
        .background(Color.white.cornerRadius(16))
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(Animation.easeIn(duration: 0.3)) {
                    isShowResult = true
                }
            }
        })
    }

    var body: some View {
        goalReward != nil ? mainView : nil
    }
}

struct CompleteGoalView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteGoalView(goalReward: GoalReward(name: "做3个引体向上", importance: Importance.epic, basicRewardBase: 500, allRpeatRewardBase: 100, beforeDdlRewardBase: 200), onClose: emptyFunc, openHelp: emptyFunc)
    }
}
