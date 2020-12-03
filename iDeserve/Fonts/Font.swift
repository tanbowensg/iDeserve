//
//  Font.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/12/3.
//

import Foundation
import SwiftUI

extension UIFont {
  class var hiraginoSansGb16Pt2: UIFont {
    return UIFont(name: "HiraginoSansGB-W6", size: 16.0)!
  }
  class var avenir14Pt4: UIFont {
    return UIFont(name: "Avenir-Black", size: 14.0)!
  }
  class var avenir14Pt3: UIFont {
    return UIFont(name: "Avenir-Black", size: 14.0)!
  }
  class var hiraginoSansGb14Pt2: UIFont {
    return UIFont(name: "Hiragino-Sans-GB-W6", size: 14.0)!
  }
  class var hiraginoSansGb9Pt2: UIFont {
    return UIFont(name: "HiraginoSansGB-W6", size: 9.0)!
  }
}

extension Font {
    public static var hiraginoSansGb14Pt2 = Font(UIFont(name: "HiraginoSansGB-W6", size: 14.0)!)
    public static var hiraginoSansGb16Pt2 = Font(UIFont(name: "HiraginoSansGB-W6", size: 16.0)!)
}
