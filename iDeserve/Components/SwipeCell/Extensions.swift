//
//  Extensions.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/11/17.
//

import SwiftUI

public extension View {
    
    func onSwipe(leading: [Slot] = [], trailing: [Slot] = []) -> some View {
        return self.modifier(SlidableModifier(leading: leading, trailing: trailing))
    }
    
    func embedInAnyView() -> AnyView {
        return AnyView ( self )
    }
}
