//
//  RewardPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI
import CoreData
import UniformTypeIdentifiers
import StoreKit


struct RewardPage: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var gs: GlobalStore
    @FetchRequest(fetchRequest: rewardRequest) var rewards: FetchedResults<Reward>
    @AppStorage(PRO_IDENTIFIER) var isPro = false
    @AppStorage(FIRST_REWARD_STORE) var isFirstVisitPage = true

    @State var filterType: RewardFilterType = RewardFilterType.createAsc
    @State var isShowRedeemAlert: Bool = false
    @State var isShowLanding: Bool = false
    @State var currentReward: Reward? = nil
    @State var isShowPurchase = false
    @State var confettiTrigger = 0

    let safeAreaHeight: CGFloat = (UIApplication.shared.windows.first?.safeAreaInsets.top)!

    static var rewardRequest: NSFetchRequest<Reward> {
        let request: NSFetchRequest<Reward> = Reward.fetchRequest()
        request.sortDescriptors = []
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
        GridItem(.flexible(minimum: 0, maximum: 170), spacing: 25),
        GridItem(.flexible(minimum: 0, maximum: 170), spacing: 25)
    ]
    
    private var rewardsArray: [Reward] {
        rewards.map{ return $0 }
    }

    var canCreateGoal: Bool {
        isPro || rewards.count < MAX_REWARD
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
        let createBtn =
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

        return HStack {
            canCreateGoal ? NavigationLink(destination: EditRewardPage(initReward: nil)) {
                createBtn
            } : nil
            !canCreateGoal ? Button(action: { isShowPurchase.toggle() }) {
                createBtn
            } : nil
            Spacer()
            RewardFilter(filterType: $filterType)
        }
        .alert(isPresented: $isShowPurchase, content: { rewardLimitAlert })
        .padding(.horizontal, 25)
    }

    var rewardLimitAlert: Alert {
        let confirmButton = Alert.Button.default(Text("购买 Pro 版")) {
            gs.isShowPayPage = true
        }
        return Alert(
            title: Text("奖励数量达到上限"),
            message: Text(REWARD_LIMIT_ALERT),
            primaryButton: confirmButton,
            secondaryButton: Alert.Button.cancel(Text("以后再说"))
        )
    }

    var body: some View {
        ZStack(alignment: .center) {
            Image("headerBg")
                .resizable()
                .frame(width: UIScreen.main.bounds.size.width)
            VStack(spacing: 0.0) {
                RewardPageHeader()
                toolBar
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .trailing, spacing: 25) {
                        rewardGridLayout(rewards: availableRewards)
                        soldoutRewards.count > 0 ? soldoutRewardsView : nil
                    }
                    .padding(.top, 30)
                }
            }
            isShowRedeemAlert || isShowLanding ? PopupMask() : nil
            Confetti(counter: $confettiTrigger)
        }
        .ignoresSafeArea()
        .popup(isPresented: $isShowRedeemAlert, type: .default, closeOnTap: false, closeOnTapOutside: false, view: {
            RedeemRewardAlert(
                reward: currentReward,
                isShow: $isShowRedeemAlert,
                onConfirm: {
                    confettiTrigger += 1
                    gs.rewardStore.redeemReward(currentReward!)
//                    当用户坚果数量大于200，邀请评价
                    if gs.pointsStore.points > 200 {
                        SKStoreReviewController.requestReviewInCurrentScene()
                    }
                    
                }
            )
        })
        .popup(isPresented: $isShowLanding, type: .default, closeOnTap: false, closeOnTapOutside: false, dismissCallback: { isFirstVisitPage = false }) {
            HelpTextModal(isShow: $isShowLanding, title: "奖励商店介绍", text: FIRST_REWARD_STORE_TEXT)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isShowLanding = isFirstVisitPage
            }
        }
        .navigationBarHidden(true)
    }
}
