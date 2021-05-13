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
    @AppStorage(PRO_IDENTIFIER) var isPro = false
    var onTapRedeem: () -> Void

//    这个和 isEditMode 是一起变化的。但是为了让删除按钮的动画和整个卡片分离开来，所以弄了两个变量
    @State var isTapped = false
    @State var isShowPurchase = false
    
    var disableRedeem: Bool {
        return !reward.isAvailable
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
    
    var redeemButton: some View {
        Button(action: {
            if gs.pointsStore.points >= reward.value || isPro {
                onTapRedeem()
            } else {
                isShowPurchase = true
            }
        }) {
            NutIcon(value: Int(reward.value), hidePlus: true)
                .frame(height: 24)
                .padding(.horizontal, 16.0)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.darkShadow, radius: 5, x: 2, y: 2)
                .saturation(disableRedeem ? 0 : 1)
        }
        .disabled(disableRedeem)
    }

    var link: some View {
        NavigationLink(destination:  EditRewardPage(initReward: reward), isActive: $isTapped) {
            EmptyView()
        }
    }
    
    var noEnoughNutsAlert: Alert {
        let confirmButton = Alert.Button.default(Text("购买 Pro 版")) {
            gs.isShowPayPage = true
        }
        let cancelButton = Alert.Button.cancel(Text("再攒攒吧"))
        return Alert(
            title: Text("坚果不够"),
            message: Text(NO_ENOUGH_NUTS_ALERT),
            primaryButton: confirmButton,
            secondaryButton: cancelButton
        )
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
            link
            ZStack(alignment: .center) {
                mainCard
                    .saturation(reward.isAvailable ? 1 : 0)
                !reward.isAvailable ? soldoutLogo : nil
            }
            !reward.isAvailable ? removeButton : nil
        }
        .id(reward.id)
        .onTapGesture {
            isTapped.toggle()
        }
        .alert(isPresented: $isShowPurchase, content: { noEnoughNutsAlert })
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
                        RewardGrid(reward: reward, onTapRedeem: emptyFunc)
                    }
                }
                .padding(20)
            }
        }
    }
}
