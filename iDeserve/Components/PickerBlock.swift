//
//  SwiftUIView.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/15.
//

import SwiftUI

struct PickerBlock: View {
    var title: String
    var subtitle: String
    var isHighlight: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 10.0) {
                Text(title)
                Text(subtitle).font(.avenirBlack12).foregroundColor(.g60)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .roundBorder(
                isHighlight ? Color.rewardColor : Color.g60,
                width: 2,
                cornerRadius: 20
            )
            .background(Color.white)
            .padding(.horizontal, 20)
        }
    }
}


struct PickerBlock_Previews: PreviewProvider {
    static var previews: some View {
        PickerBlock(title: "挑战", subtitle: "有点难，要集中精神才能完成。", isHighlight: false)
    }
}
