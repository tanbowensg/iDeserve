//
//  Confetti.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/5/18.
//

import SwiftUI
import ConfettiSwiftUI

struct Confetti: View {
    @Binding var counter: Int

    var body: some View {
        ConfettiCannon(
            counter: $counter,
            num: 40,
            colors: [.warningRed, .customBlue, .customGreen, .customOrange],
            radius: 300
        )
    }
}
