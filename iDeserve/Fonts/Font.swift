//
//  Font.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/12/3.
//

import Foundation
import SwiftUI

extension UIFont {
//    class var hiraginoSansGb16Pt2: UIFont {
//        return UIFont(name: "HiraginoSansGB-W6", size: 16.0)!
//    }
//    class var avenir14Pt4: UIFont {
//        return UIFont(name: "Avenir-Black", size: 14.0)!
//    }
//    class var avenirBlack12: UIFont {
//        return UIFont(name: "Avenir-Black", size: 12.0)!
//    }
//    class var avenir14Pt3: UIFont {
//        return UIFont(name: "Avenir-Black", size: 14.0)!
//    }
//    class var hiraginoSansGb14Pt2: UIFont {
//        return UIFont(name: "Hiragino-Sans-GB-W6", size: 14.0)!
//    }
//    class var hiraginoSansGb9Pt2: UIFont {
//        return UIFont(name: "HiraginoSansGB-W6", size: 9.0)!
//    }
}

extension Font {
//    public static var captionCustom = Font.custom("HiraginoSansGB-W6", size: 11)
//    public static var footnoteSmCustom = Font.custom("HiraginoSansGB-W6", size: 12)
//    public static var footnoteCustom = Font.custom("HiraginoSansGB-W6", size: 13)
//    public static var subheadCustom = Font.custom("HiraginoSansGB-W6", size: 15)
//    public static var bodyCustom = Font.custom("HiraginoSansGB-W3", size: 17)
//    public static var headlineCustom = Font.custom("HiraginoSansGB-W6", size: 17)
//    public static var titleCustom = Font.custom("HiraginoSansGB-W6", size: 28)
    
    public static var captionCustom = Font.system(size: 12)
    public static var footnoteCustom = Font.system(size: 13)
    public static var subheadCustom = Font.system(size: 15)
    public static var bodyCustom = Font.system(size: 17)
    public static var headlineCustom = Font.system(size: 17)
    public static var titleCustom = Font.system(size: 20)
//    public static var avenirBlack12 = Font(UIFont(name: "Avenir-Black", size: 13.0)!)
//    public static var avenirBlack14 = Font(UIFont(name: "Avenir-Black", size: 15.0)!)
//    public static var avenirBlack36 = Font(UIFont(name: "Avenir-Black", size: 36.0)!)
}
