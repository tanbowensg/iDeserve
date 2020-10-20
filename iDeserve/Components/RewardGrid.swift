//
//  RewardGrid.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/7.
//

import SwiftUI
import URLImage

struct RewardGrid: View {
    @ObservedObject var reward: Reward
    
    var cover: some View {
        Image(uiImage: UIImage(data: reward.cover!)!)
            .resizable()
            .aspectRatio(4/3, contentMode: .fit)
            .cornerRadius(16)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(reward.name ?? "未知")
                .font(.subheadline)
                .foregroundColor(.g80)
            reward.cover != nil ? cover : nil
            VStack(alignment: .center){
                Text(String(reward.value))
            }
                .frame(minWidth: 0, maxWidth: .infinity)
        }
            .padding(16)
            .background(Color.g10)
            .cornerRadius(16)
    }
}

//struct RewardGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        RewardGrid(reward: DefaultRewards[2])
//    }
//}
