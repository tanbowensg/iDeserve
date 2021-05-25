//
//  AlertItem.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/5/25.
//

import Foundation
import SwiftUI

struct AlertItem: Identifiable {
    var id = UUID()
    var title: Text
    var message: Text?
    var primaryButton: Alert.Button?
    var secondaryButton: Alert.Button?
}
