//
//  Color.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/6.
//

import Foundation
import SwiftUI

//让 color 兼容 hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    public static var g0 = Color(hex: "FFFFFF")
    public static var g10 = Color(hex: "F7F7F7")
    public static var g20 = Color(hex: "F0F0F0")
    public static var g30 = Color(hex: "E5E5E5")
    public static var g40 = Color(hex: "D9D9D9")
    public static var g50 = Color(hex: "BFBFBF")
    public static var g60 = Color(hex: "8C8C8C")
    public static var g70 = Color(hex: "595959")
    public static var g80 = Color(hex: "262626")
    public static var bg = Color(hex: "F7F6F1")
    public static var normalText = Color(hex: "363636")
    public static var tagColor = Color(hex: "6d859b")
    public static var tagBg = Color(hex: "dceeff")
    public static var warning = Color(hex: "e9614d")
    public static var popupMask = Color(red: 0, green: 0, blue: 0, opacity: 0.3)
    public static var lightShadow = Color(red: 0, green: 0, blue: 0, opacity: 0.05)
    public static var darkShadow = Color(red: 0, green: 0, blue: 0, opacity: 0.1)
    public static var completeColor = Color(hex: "a6c2a7")

    public static var brandGreen = Color(UIColor(named: "brandGreen")!)
    public static var darkBrandGreen = Color(UIColor(named: "darkBrandGreen")!)
    public static var rewardGold = Color(UIColor(named: "rewardGold")!)

    public static var descBg = Color.init("descBg")
    public static var g1 = Color.init("g1")
    public static var g2 = Color.init("g2")
    public static var b1 = Color.init("b1")
    public static var b2 = Color.init("b2")
    public static var b3 = Color.init("b3")
    public static var b4 = Color.init("b4")
    public static var customRed = Color.init("customRed")
    public static var customBlue = Color.init("customBlue")
    public static var customGreen = Color.init("customGreen")
}
