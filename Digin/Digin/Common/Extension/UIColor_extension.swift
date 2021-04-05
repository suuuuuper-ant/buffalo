//
//  UIColor_extension.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/05.
//

import Foundation
import UIKit

enum diginColor {
    
    case mainColor
}

extension UIColor {
    
    static func appColor(_ name: diginColor) -> UIColor {
          
        switch name {
        
        //FIXME: 추후 색상 수정
        case .mainColor:
            return UIColor(red: 242/255, green: 145/255, blue: 145/255, alpha: 1)
        }
        
    }
}
