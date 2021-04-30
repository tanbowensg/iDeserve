//
//  RewardGrid.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/7.
//

import SwiftUI
import CoreData

struct RewardGrid: View {
    @EnvironmentObject var gs: GlobalStore
    @ObservedObject var reward: Reward

//    这个和 isEditMode 是一起变化的。但是为了让删除按钮的动画和整个卡片分离开来，所以弄了两个变量
    @State var isTapped = false

    @State var isShowRedeemAlert = false
    
    var disableRedeem: Bool {
        return !reward.isAvailable || gs.pointsStore.points < reward.value
    }
//    
//    var cover: some View {
//        Image(uiImage: UIImage(data: reward.cover!)!)
//            .resizable()
//            .aspectRatio(4/3, contentMode: .fit)
//            .cornerRadius(16)
//    }
    
    var soldoutLogo: some View {
        Text("SOLD OUT")
            .font(.titleCustom)
            .fontWeight(.black)
            .foregroundColor(.warningRed)
            .frame(width: 120, height: 38)
            .roundBorder(Color.warningRed, width: 4, cornerRadius: 5)
            .rotationEffect(.degrees(-15))
            .padding(.bottom, 60)
    }
//    
    var removeButton: some View {
        Button(action: {
            gs.moc.delete(reward)
            gs.coreDataContainer.saveContext()
        }) {
            Image(systemName: "multiply")
                .resizable()
                .scaledToFit()
                .frame(width: 8, height: 8)
                .padding(4)
                .foregroundColor(.b2)
                .background(Color.white.cornerRadius(10))
        }
        .padding(10)
    }
    
    var redeemAlert: Alert {
        let confirmButton = Alert.Button.default(Text("确定")) {
            gs.rewardStore.redeemReward(reward)
        }
        let cancelButton = Alert.Button.cancel(Text("取消"))
        return Alert(
            title: Text("兑换奖励"),
            message: Text("确定要兑换\(reward.name!)吗？"),
            primaryButton: confirmButton,
            secondaryButton: cancelButton
        )
    }
    
    var redeemButton: some View {
        Button(action: { isShowRedeemAlert.toggle() }) {
            NutIcon(value: Int(reward.value), hidePlus: true)
//            HStack(alignment: .center, spacing: 4){
//                Image("NutIcon")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 16, height: 16.0)
//                Text(String(reward.value))
//                    .font(.footnoteCustom)
//                    .foregroundColor(.rewardGold)
//            }
            .frame(height: 24)
            .padding(.horizontal, 16.0)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.darkShadow, radius: 5, x: 2, y: 2)
            .saturation(disableRedeem ? 0 : 1)
        }
        .alert(isPresented: $isShowRedeemAlert, content: { redeemAlert })
        .disabled(disableRedeem)
    }

    var link: some View {
        NavigationLink(destination:  EditRewardPage(initReward: reward), isActive: $isTapped) {
            EmptyView()
        }
    }
    
    var mainCard: some View {
        VStack(alignment: .center, spacing: 10) {
            Image(reward.type ?? "")
                .resizable()
                .scaledToFit()
                .frame(height: 38)
            Text(reward.name ?? "未知")
                .font(.footnoteCustom)
                .foregroundColor(.b4)
                .lineLimit(2)
                .frame(height: 34, alignment: .center)
                .padding(.horizontal, 10)
            redeemButton
        }
        .padding(.vertical, 20)
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Image("rewardBg").resizable().scaledToFit().frame(width: 170, height: 170).cornerRadius(16))
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            reward.type != RewardType.system.rawValue ? link : nil // 系统奖励不可以更改，所以不能进入详情
            ZStack(alignment: .center) {
                mainCard
                    .saturation(reward.isSoldout ? 0 : 1)
                reward.isSoldout ? soldoutLogo : nil
            }
            !reward.isUnlockCalendar || reward.isSoldout ? removeButton : nil
        }
        .id(reward.id)
        .onTapGesture {
            isTapped.toggle()
        }
    }
}


struct RewardGrid_Previews: PreviewProvider {
    private var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    static var previews: some View {
        let context = CoreDataContainer.shared.context
        let rewards = genMockRewards(context)
        
        return ScrollView {
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    alignment: .center,
                    spacing: 20
                ) {
                    ForEach(rewards, id: \.id) { (reward: Reward) in
                        RewardGrid(reward: reward)
                    }
                }
                .padding(20)
            }
        }
    }
}
