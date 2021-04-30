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
                .frame(height: HEADER_HEIGHT)
            Image("headerLeaf")
                .resizable()
                .frame(height: HEADER_HEIGHT)
            Image("headerNuts")
                .resizable()
                .scaledToFit()
                .frame(height: HEADER_HEIGHT)
            NutsAndSettings()
                .padding(.top, 10 + safeAreaHeight)
                .padding(.horizontal, 25)
            Image("rabbit")
                .resizable()
                .scaledToFit()
                .frame(width: 116, height: 116)
                .padding(.leading, UIScreen.main.bounds.size.width - 87)
                .padding(.top, HEADER_HEIGHT - 116)
        }
        .ignoresSafeArea()
        .frame(width: UIScreen.main.bounds.size.width, height: HEADER_HEIGHT)
    }
}

struct RewardPageHeader_Previews: PreviewProvider {
    static var previews: some View {
        RewardPageHeader()
    }
}
