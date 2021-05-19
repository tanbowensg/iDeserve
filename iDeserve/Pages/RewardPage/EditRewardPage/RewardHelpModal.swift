//
//  RewardHelpModal.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/5/19.
//

import SwiftUI

struct RewardHelpModal: View {
    @Binding var isShow: Bool
    
    var columns: [GridItem] {
        return [
            GridItem(.fixed(40), spacing: 6, alignment: .leading),
            GridItem(.flexible(minimum: 10, maximum: .infinity), spacing: 6, alignment: .leading),
            GridItem(.flexible(minimum: 10, maximum: .infinity), spacing: 6, alignment: .leading),
        ]
    }
    
    var body: some View {
        VStack(spacing: 25) {
            Text(REWARD_VALUE_DESC_TITLE)
                .font(.bodyCustom)
                .fontWeight(.bold)
                .padding(.top, 25)
            
            Text(REWARD_VALUE_DESC)
                .font(.subheadCustom)
                .lineSpacing(8)
                .padding(.horizontal, 25)
            
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 12
            ) {
                Group {
                    Text("坚果").fontWeight(.bold)
                    Text("奖励").fontWeight(.bold)
                    Text("任务").fontWeight(.bold)
                    Text("10")
                    Text("熬夜看剧")
                    Text("12 点前睡觉")
                    Text("20")
                    Text("打 1 小时游戏")
                    Text("做作业 1 小时")
                }
                Group {
                    Text("40")
                    Text("1 杯奶茶")
                    Text("跑步 1 小时")
                    Text("500")
                    Text("Kindle")
                    Text("读完《红楼梦》")
                    Text("1200")
                    Text("AirPods")
                    Text("上 30 节 Python 课")
                }
                Group {
                    Text("1600")
                    Text("国内 5 日游")
                    Text("刷完五年高考真题")
                }
            }
                .font(.footnoteCustom)
                .padding(.horizontal, 25)

            Button(action: {
                isShow = false
            }) {
                Text("知道了")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 265.0, height: 60.0)
                    .background(Color.customOrange)
            }
        }
        .frame(width: 265.0)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: .darkShadow, radius: 20, x: 0, y: 0)
    }
}
