//
//  dismissKeyboard.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/3/11.
//

import Foundation
import UIKit

func dismissKeyboard () -> Void {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
