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

    @State var isEditMode = false
    @State var isTapped = false

    static var rewardRequest: NSFetchRequest<Reward> {
        let request: NSFetchRequest<Reward> = Reward.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Reward.value, ascending: true)
        ]
        return request
   }

    private var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    func genRewardGrid(reward: Reward) -> some View {
//        return NavigationLink(destination: EditRewardPage(initReward: reward)) {
//            RewardGrid(reward: reward, onLongPress: { isEditMode.toggle() }, isEditMode: isEditMode)
//        }
        return
            VStack {
                NavigationLink(destination:  EditRewardPage(initReward: reward), isActive: $isTapped) {
                    EmptyView()
                }
                RewardGrid(reward: reward, isEditMode: isEditMode)
                    .onTapGesture {
                        if isEditMode == true {
                            isEditMode = false
                        } else {
                            isTapped.toggle()
                        }
                    }
                    .simultaneousGesture(LongPressGesture().onEnded{_ in
                        isEditMode.toggle()
                    })
            }
    }

    var body: some View {
        return
            VStack(spacing: 0.0) {
                AppHeader(points: gs.pointsStore.points, title: "奖励商店")
                ZStack(alignment: .bottomTrailing) {
                    ScrollView {
                        LazyVGrid(
                            columns: columns,
                            alignment: .center,
                            spacing: 16
                        ) {
                            ForEach(rewards, id: \.id) { (reward: Reward) in
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
            }
                .navigationBarHidden(true)
                .onTapGesture {
                    isEditMode = false
                }
    }
}
