//
//  FeedSkeletonTableViewCell3.swift
//  Digin
//
//  Created by 김예은 on 2021/04/29.
//

import UIKit

class FeedSkeletonTableViewCell3: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lineView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    private func setup() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = UIColor.appColor(.lightGrey2)

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

extension FeedSkeletonTableViewCell3: SkeletonLoadable {}
