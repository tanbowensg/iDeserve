//
//  RewardPageHeader.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/3.
//

import SwiftUI

struct RewardPageHeader: View {
    @EnvironmentObject var pointsStore: PointsStore

    var body: some View {
        ZStack {
            VStack(spacing: 16.0) {
                Text(REWARD_STORE_TEXT)
                    .foregroundColor(.white)
                    .font(.hiraginoSansGb16)
                    .fontWeight(.black)
            HStack(alignment: .center, spacing: 2){
                Image("NutIcon")
                    .resizable()
                    .padding(6)
                    .frame(width: 36.0, height: 36.0)
                Text(String(pointsStore.points))
                    .font(.avenirBlack36)
                    .fontWeight(.bold)
                    .foregroundColor(.rewardColor)
                    .frame(height: 16.0)
            }
                .frame(width: 220.0, height: 48.0)
                .background(Color.white)
                .cornerRadius(24)
            }
        }
        .frame(height: 160.0)
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color.headerGreen)
    }
}

struct RewardPageHeader_Previews: PreviewProvider {
    static var previews: some View {
        RewardPageHeader()
            .environmentObject(PointsStore.shared)
    }
}
