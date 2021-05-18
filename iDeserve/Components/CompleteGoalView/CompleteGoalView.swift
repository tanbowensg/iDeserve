//
//  CompleteGoalView.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/2/25.
//

import SwiftUI

struct CompleteGoalView: View {
    @Binding var isShow: Bool
    var goalReward: GoalReward?
    var onConfirm: () -> Void
    var openHelp: () -> Void
    
//    展示数据
    @State var isShowResult = false

    var mainView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 6.0) {
                HStack {
                    Image(systemName: "xmark")
                        .onTapGesture {
                            isShow = false
                        }
                    Spacer()
                    Text("完成目标")
                    Spacer()
                    Image(systemName: "questionmark.circle")
                        .onTapGesture {
                            openHelp()
                        }
                }
                .font(Font.headlineCustom.weight(.bold))

                Image("prize")
                    .resizable()
                    .frame(width: 200.0, height: 200.0)

                Text(goalReward?.name ?? "")
                    .font(.headlineCustom)
                    .fontWeight(.bold)

                if isShowResult {
                    VStack(spacing: 6.0) {
                        HStack {
                            Text("\(ImportanceText[goalReward!.importance]!)目标固定奖励").font(.footnoteCustom)
                            Spacer()
                            NutIcon(value: goalReward!.fixedReward, hidePlus: true)
                        }
                        HStack {
                            Text("完成目标加成奖励").font(.footnoteCustom)
                            Spacer()
                            NutIcon(value: goalReward!.basicReward, hidePlus: true)
                        }
                        HStack {
                            Text("在截止前完成任务").font(.footnoteCustom)
                            Spacer()
                            NutIcon(value: goalReward!.beforeDdlReward, hidePlus: true)
                        }
                        HStack {
                            Text("完成全部重复次数").font(.footnoteCustom)
                            Spacer()
                            NutIcon(value: goalReward!.allRpeatReward, hidePlus: true)
                        }
                        VStack(spacing: 6.0) {
                            ExDivider()
                            HStack {
                                Text("总计").font(.footnoteCustom)
                                Spacer()
                                NutIcon(value: goalReward!.totalReward, hidePlus: true)
                            }
                        }
                    }
                    .padding(.top, 25)
                }
            }
                .padding(.horizontal, 25)
            
            ExDivider().padding(.vertical, 10.0)
            
            Firework(onTap: { onConfirm() }, content: {
                Text("完成！")
                    .font(.footnoteCustom)
                    .foregroundColor(.white)
                    .frame(width: 100.0, height: 40.0)
                    .background(Color.rewardGold)
                    .cornerRadius(20)
            })
            .frame(width: 100.0, height: 40.0)
        }
        .padding(.vertical, 25)
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

//struct CompleteGoalView_Previews: PreviewProvider {
//    static var previews: some View {
//        CompleteGoalView(isShow: <#Binding<Bool>#>, goalReward: GoalReward(name: "做3个引体向上", importance: Importance.epic, basicRewardBase: 500, allRpeatRewardBase: 100, beforeDdlRewardBase: 200), onConfirm: emptyFunc, openHelp: emptyFunc)
//    }
//}
