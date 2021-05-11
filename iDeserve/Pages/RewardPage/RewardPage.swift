//
//  RewardPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI
import CoreData
import UniformTypeIdentifiers


struct RewardPage: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var gs: GlobalStore
    @FetchRequest(fetchRequest: rewardRequest) var rewards: FetchedResults<Reward>

    @State var filterType: RewardFilterType = RewardFilterType.createAsc
    @State var isShowRedeemAlert: Bool = false
    @State var currentReward: Reward? = nil

    let safeAreaHeight: CGFloat = (UIApplication.shared.windows.first?.safeAreaInsets.top)!

    static var rewardRequest: NSFetchRequest<Reward> {
        let request: NSFetchRequest<Reward> = Reward.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Reward.pos, ascending: true)
        ] 
        return request
   }
    
    private var soldoutRewards: [Reward] {
        return rewards.filter{ !$0.isAvailable }
    }
    
    private var availableRewards: [Reward] {
        let _rewards = rewards.filter{ $0.isAvailable }
        switch filterType {
            case .createAsc:
                return  _rewards.sorted{ $0.createdTime! > $1.createdTime! }
            case .createDesc:
                return  _rewards.sorted{ $0.createdTime! < $1.createdTime! }
            case .valueAsc:
                return  _rewards.sorted{ $0.value < $1.value }
            case .valueDesc:
                return  _rewards.sorted{ $0.value > $1.value }
        }
    }

    private var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    private var rewardsArray: [Reward] {
        rewards.map{ return $0 }
    }
    
    func rewardGridLayout (rewards: [Reward]) -> some View {
        LazyVGrid(
            columns: columns,
            alignment: .center,
            spacing: 25
        ) {
            ForEach(rewards, id: \.id) { (reward: Reward) in
                RewardGrid(reward: reward, onTapRedeem: {
                    isShowRedeemAlert.toggle()
                    currentReward = reward
                })
            }
        }
            .padding(.horizontal, 25)
            .animation(.spring())
    }

    var soldoutRewardsView: some View {
        VStack(alignment: .leading, spacing: 20.0) {
            Text("已兑换的奖励")
                .font(.subheadCustom)
                .fontWeight(.bold)
                .foregroundColor(.b3)
                .padding(.horizontal, 25)
            rewardGridLayout(rewards: soldoutRewards)
        }
    }
    
    var toolBar: some View {
        HStack {
            NavigationLink(destination: EditRewardPage(initReward: nil)) {
                HStack(spacing: 10.0) {
                    Image(systemName: "plus")
                    Text("添加奖励")
                }
                    .font(Font.footnoteCustom.weight(.bold))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 18)
                    .background(
                        Color.white
                            .cornerRadius(20)
                            .shadow(color: Color.darkShadow, radius: 10, x: 0, y: 2)
                    )
                    .foregroundColor(.b3)
            }
            Spacer()
            RewardFilter(filterType: $filterType)
        }
        .padding(.horizontal, 25)
    }

    var body: some View {
        ZStack(alignment: .top) {
            Image("headerBg")
                .resizable()
                .frame(width: UIScreen.main.bounds.size.width)
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .trailing, spacing: 25) {
                    toolBar
                    rewardGridLayout(rewards: availableRewards)
                    soldoutRewards.count > 0 ? soldoutRewardsView : nil
                }
                .padding(.top, 30)
            }
                .padding(.top, HEADER_HEIGHT - safeAreaHeight)
            RewardPageHeader()
            isShowRedeemAlert ? Color.popupMask.ignoresSafeArea() : nil
        }
        .popup(isPresented: $isShowRedeemAlert, type: .default, closeOnTap: false, closeOnTapOutside: false, view: {
            RedeemRewardAlert(
                reward: currentReward,
                isShow: $isShowRedeemAlert,
                onConfirm: {
                    gs.rewardStore.redeemReward(currentReward!)
                }
            )
        })
        .navigationBarHidden(true)
    }
}
