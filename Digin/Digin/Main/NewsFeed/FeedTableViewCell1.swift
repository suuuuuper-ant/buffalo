//
//  FeedTableViewCell1.swift
//  Digin
//
//  Created by 김예은 on 2021/04/20.
//

import UIKit

class FeedTableViewCell1: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var opImageView: UIImageView!

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    private func setup() {
        newsImageView.makeRounded(cornerRadius: 10)
        opImageView.makeRounded(cornerRadius: 10)

        dateLabel.textColor = UIColor.appColor(.white)
        titleLabel.textColor = UIColor.appColor(.white)
        contentsLabel.textColor = UIColor.appColor(.lightGrey1)
    }

}
