//
//  RedeemRewardAlert.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/5/11.
//

import SwiftUI

struct RedeemRewardAlert: View {
    var reward: Reward?
    @Binding var isShow: Bool
    var onConfirm: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0.0) {
                Text("兑换奖励")
                    .font(.subheadCustom)
                    .fontWeight(.bold)
                    .padding(.top, 25)
                    .padding(.bottom, 30)
                Image(reward?.type ?? "")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 86)
                    .shadow(color: Color.darkShadow, radius: 6, x: 0, y: 3)
                    .padding(.bottom, 20)
                Text("我想要兑换一份")
                    .font(.footnoteCustom)
                    .padding(.bottom, 10)
                Text(reward?.name ?? "")
                    .font(.subheadCustom)
                    .fontWeight(.bold)
                    .padding(.bottom, 30)
                    .foregroundColor(.customOrange)
                Button(action: {
                    isShow = false
                    onConfirm()
                }) {
                    Text("确定")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(width: 265.0, height: 60.0)
                        .background(Color.customOrange)
                }
            }
            Image(systemName: "xmark")
                .font(Font.subheadCustom.weight(.bold))
                .padding(.top, 25)
                .padding(.trailing, 20)
                .onTapGesture {
                    isShow = false
                }
        }
            .foregroundColor(.b3)
            .frame(width: 265.0)
            .background(Color.white)
            .cornerRadius(25)
    }
}

//struct RedeemRewardAlert_Previews: PreviewProvider {
//    static var previews: some View {
//        RedeemRewardAlert()
//    }
//}
