//
//  UIFont_extension.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/04.
//

import UIKit

extension UIFont {

    static func englishFont(ofSize size: CGFloat) -> UIFont? {

        func printMyFonts() {
            print("--------- Available Font names ----------")
            for name in UIFont.familyNames {
                print(name)
                print(UIFont.fontNames(forFamilyName: name))
            }
        }
        printMyFonts()
        return UIFont(name: "COCOGOOSE-DemiBold", size: size)
    }
}
