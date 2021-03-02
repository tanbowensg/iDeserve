//
//  if.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/3/2.
//

import Foundation
import SwiftUI

extension View {
   @ViewBuilder
   func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }
}
