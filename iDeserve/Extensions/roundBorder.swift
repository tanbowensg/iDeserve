//
//  roundBorder.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/13.
//

import Foundation
import SwiftUI

extension View {
    public func roundBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
             .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
}
