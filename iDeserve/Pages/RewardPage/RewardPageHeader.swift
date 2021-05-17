//
//  RewardPageHeader.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/4/30.
//

import SwiftUI

struct RewardPageHeader: View {
    let safeAreaHeight: CGFloat = (UIApplication.shared.windows.first?.safeAreaInsets.top)!

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image("rabbit")
                .resizable()
                .scaledToFit()
                .frame(width: 116, height: 116)
                .offset(x: 25, y: -10)
            ZStack(alignment: .topLeading) {
                Image("headerLeaf")
                    .scaledToFit()
                Image("headerNuts")
                    .scaledToFit()
                NutsAndSettings()
                    .padding(.top, 10 + safeAreaHeight)
                    .padding(.horizontal, 25)
            }
        }
        .frame(width: UIScreen.main.bounds.size.width)
    }
}

struct RewardPageHeader_Previews: PreviewProvider {
    static var previews: some View {
        RewardPageHeader()
    }
}
