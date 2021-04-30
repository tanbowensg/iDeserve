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
        ZStack(alignment: .topLeading) {
            Image("headerCover")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.size.width)
            Image("headerLeaf")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.size.width)
            Image("headerNuts")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.size.width)
            Image("rabbit")
                .resizable()
                .scaledToFit()
                .frame(width: 116, height: 116)
                .offset(x: UIScreen.main.bounds.size.width - 87, y: HEADER_HEIGHT - 116)
            NutsAndSettings()
                .padding(.top, 10 + safeAreaHeight)
                .padding(.horizontal, 25)
        }
        .ignoresSafeArea()
        .frame(width: UIScreen.main.bounds.size.width)
    }
}

struct RewardPageHeader_Previews: PreviewProvider {
    static var previews: some View {
        RewardPageHeader()
    }
}
