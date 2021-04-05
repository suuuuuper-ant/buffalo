//
//  NSObject_extension.swift
//  Digin
//
//  Created by 김예은 on 2021/04/05.
//

import Foundation

extension NSObject {
    
    //MARK: Storyboard idetifier
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
