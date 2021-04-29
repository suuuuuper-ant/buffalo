//
//  FeedSkeletonTableViewCell2.swift
//  Digin
//
//  Created by 김예은 on 2021/04/29.
//

import UIKit

class FeedSkeletonTableViewCell2: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    private func setup() {
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false

        // Create the CAGradientLayer
        let newsImageLayer = CAGradientLayer()
        newsImageLayer.startPoint = CGPoint(x: 0, y: 0.5)
        newsImageLayer.endPoint = CGPoint(x: 1, y: 0.5)
        newsImageView.layer.addSublayer(newsImageLayer)

        let titleLayer = CAGradientLayer()
        titleLayer.startPoint = CGPoint(x: 0, y: 0.5)
        titleLayer.endPoint = CGPoint(x: 1, y: 0.5)
        titleLabel.layer.addSublayer(titleLayer)

        let contentLayer = CAGradientLayer()
        contentLayer.startPoint = CGPoint(x: 0, y: 0.5)
        contentLayer.endPoint = CGPoint(x: 1, y: 0.5)
        contentLabel.layer.addSublayer(contentLayer)

        // Create the shimmer animation
        let newsGroup = makeAnimationGroup()
        newsGroup.beginTime = 0.0
        newsImageLayer.add(newsGroup, forKey: "backgroundColor")

        let titleGroup = makeAnimationGroup(previousGroup: newsGroup)
        titleLayer.add(titleGroup, forKey: "backgroundColor")

        let contentGroup = makeAnimationGroup(previousGroup: titleGroup)
        contentLayer.add(contentGroup, forKey: "backgroundColor")

        // Set the gradients frame to the labels bounds
        newsImageLayer.frame = newsImageView.bounds
        titleLayer.frame = titleLabel.bounds
        contentLayer.frame = contentLabel.bounds
    }
}

extension FeedSkeletonTableViewCell2: SkeletonLoadable {}
