//
//  RewardPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI

struct RewardPage: View {
    @ObservedObject var rewardsStore = RewardsStore()
    
    private var sortedRewards: [Reward] {
        rewardsStore.rewards.sorted { (r1, r2) -> Bool in
            return r1.value > r2.value
        }
    }
    
    private var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    func genRewardGrid(reward: Reward) -> some View {
        return NavigationLink(destination: EditRewardPage(initReward: reward, rewardsStore: rewardsStore)) {
            RewardGrid(reward: reward)
                .foregroundColor(.g80)
        }
    }

    var body: some View {
        NavigationView() {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    genRewardGrid(reward: sortedRewards[0])
                    LazyVGrid(
                        columns: columns,
                        alignment: .center,
                        spacing: 16
                    ) {
                        ForEach (sortedRewards) { reward in
                            genRewardGrid(reward: reward)
                        }
                    }
                    .padding(16)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: EditRewardPage(initReward: nil, rewardsStore: rewardsStore)) {
                                CreateButton()
                        }
                    }
                        .padding(.trailing, 16)
                }
                    .padding(.bottom, 16)
            }
                .navigationBarHidden(true)
        }
    }
}

struct RewardPage_Previews: PreviewProvider {
    static var previews: some View {
        RewardPage()
    }
}
