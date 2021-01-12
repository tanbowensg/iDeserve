//
//  viberate.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/12.
//

import Foundation
import SwiftUI

func viberate () -> Void {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.warning)
}
