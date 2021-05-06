//
//  RecordPageHeader.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/4/27.
//

import SwiftUI

struct RecordPageHeader: View {
    let safeAreaHeight: CGFloat = (UIApplication.shared.windows.first?.safeAreaInsets.top)!

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image("headerCover")
                .resizable()
                .frame(height: HEADER_HEIGHT + 100)
            Image("headerLeaf")
                .resizable()
                .frame(height: HEADER_HEIGHT)
            Text("历史记录")
                .font(.titleCustom)
                .fontWeight(.bold)
                .foregroundColor(.b4)
                .padding(.top, 140)
                .padding(.trailing, 25)
        }
        .ignoresSafeArea()
        .frame(width: UIScreen.main.bounds.size.width, height: HEADER_HEIGHT + 100)
    }
}

struct RecordPageHeader_Previews: PreviewProvider {
    static var previews: some View {
        RecordPageHeader()
    }
}
