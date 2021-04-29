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
    
    var isEditMode: Bool
//    在编辑模式下tap奖励
    var onEditModeTap: () -> Void
//    这个和 isEditMode 是一起变化的。但是为了让删除按钮的动画和整个卡片分离开来，所以弄了两个变量
    @State var isTapped = false
    @State var isShowButton = false

    @State var isShowRedeemAlert = false
    
    var disableRedeem: Bool {
        return isEditMode
            || !reward.isAvailable
            || gs.pointsStore.points < reward.value
    }
    
    var cover: some View {
        Image(uiImage: UIImage(data: reward.cover!)!)
            .resizable()
            .aspectRatio(4/3, contentMode: .fit)
            .cornerRadius(16)
    }
    
    var removeButton: some View {
        Button(action: {
            gs.moc.delete(reward)
            gs.coreDataContainer.saveContext()
        }) {
            Image(systemName: "multiply")
                .resizable()
                .padding(4.0)
                .frame(width: 20.0, height: 20.0)
        }
        .background(Color.g10)
        .foregroundColor(.b2)
        .cornerRadius(10)
        .animation(.none, value: isShowButton)
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
            HStack(alignment: .center, spacing: 2){
                Text(String(reward.value))
                    .font(.footnoteCustom)
                    .foregroundColor(.rewardGold)
                    .frame(height: 16.0)
                Image("NutIcon")
                    .resizable()
                    .frame(width: 14.0, height: 14.0)
                    .padding(2.0)
            }
            .frame(height: 16.0)
            .padding(.vertical, 5.0)
            .padding(.horizontal, 16.0)
            .background(Color.white)
            .cornerRadius(13)
            .shadow(color: Color.init(hex: "f2f2f2"), radius: 0, x: 3, y: 3)
            .grayscale(disableRedeem ? 0.9 : 1)
            .frame(height: 26.0)
        }
        .alert(isPresented: $isShowRedeemAlert, content: { redeemAlert })
        .disabled(disableRedeem)
    }
    
    var soldoutLogo: some View {
        Text("Sold Out")
            .font(.subheadCustom)
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            .padding(4)
            .foregroundColor(.red)
            .border(Color.red, width: 2)
    }
    
    var link: some View {
        NavigationLink(destination:  EditRewardPage(initReward: reward), isActive: $isTapped) {
            EmptyView()
        }
    }
    
    var mainCard: some View {
        VStack(alignment: .center) {
            HStack {
                isShowButton && !reward.isUnlockCalendar ? removeButton : nil
                Spacer()
                reward.isSoldout && !reward.isRepeat ? soldoutLogo : nil
            }
                .frame(height: 20.0)
            Text(reward.name ?? "未知")
                .font(.subheadCustom)
                .foregroundColor(.white)
                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
            redeemButton
        }
        .padding([.leading, .bottom, .trailing], 14)
        .frame(height: 100)
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color.rewardGold)
        .cornerRadius(10)
        .id(reward.id)
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack(alignment: .center) {
                reward.type != RewardType.system.rawValue ? link : nil // 系统奖励不可以更改，所以不能进入详情
                mainCard
            }
            Image(reward.type ?? "")
                .resizable()
                .scaledToFit()
                .frame(width: 20)
                .foregroundColor(.white)
                .padding(10.0)
        }
        .rotationEffect(.degrees(isEditMode ? 2.5 : 0))
        .onChange(of: isEditMode, perform: { value in
            isShowButton = value
        })
        .onTapGesture {
            if isEditMode == true {
                onEditModeTap()
            } else {
                isTapped.toggle()
            }
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
                    spacing: 16
                ) {
                    ForEach(rewards, id: \.id) { (reward: Reward) in
                        RewardGrid(reward: reward, isEditMode: false, onEditModeTap: emptyFunc)
                    }
                }
                .padding(16)
            }
        }
    }
}
