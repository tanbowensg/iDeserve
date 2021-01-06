//
//  draggableModifier.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/6.
//

import Foundation
import SwiftUI

// @available(iOS 13.4, *) - needed for iOS
struct Draggable: ViewModifier {
    let condition: Bool
    let action: () -> NSItemProvider

    @ViewBuilder
    func body(content: Content) -> some View {
        if condition {
            content.onDrag(action)
        } else {
            content
        }
    }
}
