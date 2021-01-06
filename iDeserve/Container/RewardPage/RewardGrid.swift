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
//    这个和 isEditMode 是一起变化的。但是为了让删除按钮的动画和整个卡片分离开来，所以弄了两个变量
    @State var isShowButton = false
    
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
            Image(systemName: "minus.circle.fill")
                .resizable()
                .padding(4.0)
                .frame(width: 20.0, height: 20.0)
        }
        .background(Color.g10)
        .foregroundColor(.myBlack)
        .cornerRadius(10)
        .offset(x: -5, y: -5)
        .animation(.none, value: isShowButton)
    }
    
    var redeemButton: some View {
        Button(action: {
            print(reward)
            gs.rewardStore.redeemReward(reward)
        }) {
            HStack(alignment: .center, spacing: 2){
                Text(String(reward.value))
                    .font(.avenirBlack12)
                    .fontWeight(.black)
                    .foregroundColor(.rewardColor)
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
            .cornerRadius(100)
            .shadow(color: Color.init(hex: "f2f2f2"), radius: 0, x: 3, y: 3)
        }
            .buttonStyle(HighPriorityButtonStyle())
            .disabled(isEditMode)
    }
    
    var body: some View {
        ZStack(alignment: Alignment.topLeading) {
            VStack(alignment: .center, spacing: 11.0) {
                Text(reward.name ?? "未知")
                    .font(.hiraginoSansGb14)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                redeemButton
            }
            .padding(14)
            .frame(height: 100)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.rewardColor)
            .cornerRadius(10)
            .id(reward.id)
            isShowButton ? removeButton : nil
        }
        .rotationEffect(.degrees(isEditMode ? 2.5 : 0))
        .onChange(of: isEditMode, perform: { value in
            isShowButton = value
        })
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
                        RewardGrid(reward: reward, isEditMode: false)
                    }
                }
                .padding(16)
            }
        }
    }
}
