//
//  UIColor_extension.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/05.
//

import Foundation
import UIKit

enum DiginColor {
    case mainColor

    //Skeleton
    case gradientDarkGrey
    case gradientLightGrey
}

extension UIColor {
    static func appColor(_ name: DiginColor) -> UIColor {
        switch name {
        //FIXME: 추후 색상 수정
        case .mainColor:
            return UIColor(red: 242/255, green: 145/255, blue: 145/255, alpha: 1)

        case .gradientDarkGrey:
            return UIColor(red: 239 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1)
        case .gradientLightGrey:
            return UIColor(red: 201 / 255.0, green: 201 / 255.0, blue: 201 / 255.0, alpha: 1)

        }
    }

}
