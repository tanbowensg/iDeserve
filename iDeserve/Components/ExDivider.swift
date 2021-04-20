//
//  ExDivider.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/11.
//

import SwiftUI

struct ExDivider: View {
    let color: Color = .g1
    let width: CGFloat = 1
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
            .frame(maxWidth: .infinity)
            .padding(0)
    }
}

struct ExDivider_Previews: PreviewProvider {
    static var previews: some View {
        ExDivider()
    }
}
