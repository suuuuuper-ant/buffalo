//
//  SkeletonLoadable.swift
//  Digin
//
//  Created by 김예은 on 2021/04/20.
//

import UIKit

///reference : https://github.com/jrasmusson/swift-arcade/blob/master/Animation/Shimmer/README.md

protocol SkeletonLoadable {}

extension SkeletonLoadable {

    func makeAnimationGroup(previousGroup: CAAnimationGroup? = nil) -> CAAnimationGroup {

        let animDuration: CFTimeInterval = 1.5
        let anim1 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim1.fromValue = UIColor.appColor(.gradientLightGrey).cgColor
        anim1.toValue = UIColor.appColor(.gradientDarkGrey).cgColor
        anim1.duration = animDuration
        anim1.beginTime = 0.0

        let anim2 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim2.fromValue = UIColor.appColor(.gradientDarkGrey).cgColor
        anim2.toValue = UIColor.appColor(.gradientLightGrey).cgColor
        anim2.duration = animDuration
        anim2.beginTime = anim1.beginTime + anim1.duration

        let group = CAAnimationGroup()
        group.animations = [anim1, anim2]
        group.repeatCount = .greatestFiniteMagnitude
        group.duration = anim2.beginTime + anim2.duration
        group.isRemovedOnCompletion = false

        if let previousGroup = previousGroup {
            // Offset groups by 0.33 seconds for effect
            group.beginTime = previousGroup.beginTime + 0.33
        }

        return group
    }
}
