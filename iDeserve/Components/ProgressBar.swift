//
//  ProgressBar.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/14.
//

import SwiftUI

struct ProgressBar: View {
    var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: 4)
                    .opacity(0.3)
                    .foregroundColor(Color.brandGreen)
                
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: 4)
                    .foregroundColor(Color.brandGreen)
                    .animation(.linear, value: value)
            }
            .cornerRadius(2)
            .padding(0)
        }
        .frame(height: 4.0)
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(value: 0.3)
    }
}
