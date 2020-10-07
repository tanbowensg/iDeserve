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

    var body: some View {
        ScrollView {
            RewardGrid(reward: sortedRewards[0])
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 16
            ) {
                ForEach (sortedRewards) { reward in
                    RewardGrid(reward: reward)
                }
            }
            .padding(16)
        }
    }
}

struct RewardPage_Previews: PreviewProvider {
    static var previews: some View {
        RewardPage()
    }
}
