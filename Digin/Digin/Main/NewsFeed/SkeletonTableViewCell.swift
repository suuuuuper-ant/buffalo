//
//  SkeletonTableViewCell.swift
//  Digin
//
//  Created by 김예은 on 2021/04/20.
//

import UIKit

///reference : https://github.com/jrasmusson/swift-arcade/blob/master/Animation/Shimmer/README.md

class SkeletonTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    private func setup() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        //Create the CAGradientLayer
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        titleLabel.layer.addSublayer(gradient)

        // Create the shimmer animation
        let animationGroup = makeAnimationGroup()
        animationGroup.beginTime = 0.0
        gradient.add(animationGroup, forKey: "backgroundColor")

        // Set the gradients frame to the labels bounds
        gradient.frame = titleLabel.bounds
    }

}

extension SkeletonTableViewCell: SkeletonLoadable {}
