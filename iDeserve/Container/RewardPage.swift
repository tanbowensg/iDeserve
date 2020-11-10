//
//  RewardPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI
import CoreData

struct RewardPage: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var gs: GlobalStore
    @FetchRequest(fetchRequest: rewardRequest) var rewards: FetchedResults<Reward>

    static var rewardRequest: NSFetchRequest<Reward> {
        let request: NSFetchRequest<Reward> = Reward.fetchRequest()
        request.sortDescriptors = []
        return request
   }

    private var sortedRewards: [Reward] {
        rewards.sorted { (r1, r2) -> Bool in
            return r1.value > r2.value
        }
    }
    
    private var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    func genRewardGrid(reward: Reward) -> some View {
        return NavigationLink(destination: EditRewardPage(initReward: reward)) {
            RewardGrid(reward: reward, onLongPress: gs.rewardStore.claimReward)
                .foregroundColor(.g80)
        }
    }

    var body: some View {
        NavigationView() {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    sortedRewards.count > 0 ? genRewardGrid(reward: sortedRewards[0]) : nil
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
                        NavigationLink(destination: EditRewardPage(initReward: nil)) {
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
//
//struct RewardPage_Previews: PreviewProvider {
//    static var previews: some View {
//        RewardPage()
//    }
//}
