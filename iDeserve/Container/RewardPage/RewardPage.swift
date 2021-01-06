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
        return VStack {
            NavigationLink(destination:  EditRewardPage(initReward: reward), isActive: $isTapped) {
                EmptyView()
            }
            RewardGrid(reward: reward, isEditMode: isEditMode)
                .gesture(ExclusiveGesture(
                    TapGesture().onEnded { _ in
                        if isEditMode == true {
                            setIsEditMode(false)
                        } else {
                            isTapped.toggle()
                        }
                    },
                    LongPressGesture().onEnded{_ in
                        setIsEditMode(true)
                    }
                ))
    func setIsEditMode (_ value: Bool) {
        if value == true {
            withAnimation(Animation.easeInOut(duration: 0.15).repeatForever(autoreverses: true)) {
                isEditMode = true
            }
        } else {
            withAnimation(.default) {
                isEditMode = false
            }
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
                        .animation(.spring(), value: rewards.count)
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
                    setIsEditMode(false)
                }
    }
}
