//
//  UIColor_extension.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/05.
//

import Foundation
import UIKit

enum DiginColor {
    //main color
    case mainBlue
    case mainOrange

    //stock color
    case stockRed
    case stockBlue

    //black color
    case black
    case black62

    //white color
    case white

    //Grey color
    case lightGrey1
    case lightGrey2
    case darkGrey2
    case grey1
    case grey2

    //background color
    case bgPurple
    case bgLightGrey

    //Skeleton color
    case gradientDarkGrey
    case gradientLightGrey
}

extension UIColor {
    static func appColor(_ name: DiginColor) -> UIColor {
        switch name {

        case .mainBlue:
            return UIColor(red: 82/255, green: 0/255, blue: 255/255, alpha: 1)
        case .mainOrange:
            return UIColor(red: 253/255, green: 156/255, blue: 11/255, alpha: 1)

        case .stockRed:
            return UIColor(red: 255/255, green: 0/255, blue: 46/255, alpha: 1)
        case .stockBlue:
            return UIColor(red: 36/255, green: 44/255, blue: 232/255, alpha: 1)

        case .black:
            return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        case .black62:
            return UIColor(red: 62/255, green: 62/255, blue: 62/255, alpha: 1)

        case .white:
            return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)

        case .lightGrey1:
            return UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        case .lightGrey2:
            return UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        case .darkGrey2:
            return UIColor(red: 82/255, green: 82/255, blue: 82/255, alpha: 1)
        case .grey1:
            return UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
        case .grey2:
            return UIColor(red: 183/255, green: 183/255, blue: 183/255, alpha: 1)

        case .bgPurple:
            return UIColor(red: 240/255, green: 240/255, blue: 249/255, alpha: 1)
        case .bgLightGrey:
            return UIColor(red: 249/255, green: 249/255, blue: 251/255, alpha: 1)

        case .gradientDarkGrey:
            return UIColor(red: 239 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1)
        case .gradientLightGrey:
            return UIColor(red: 201 / 255.0, green: 201 / 255.0, blue: 201 / 255.0, alpha: 1)

        }
    }

}
