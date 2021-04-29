//
//  FeedTableViewCell4.swift
//  Digin
//
//  Created by 김예은 on 2021/04/28.
//

import UIKit

class FeedTableViewCell4: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var opImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    private func setup() {
        newsImageView.makeRounded(cornerRadius: 10)
        opImageView.makeRounded(cornerRadius: 10)
        dateLabel.textColor = UIColor.appColor(.lightGrey1)
        titleLabel.textColor = UIColor.appColor(.white)
    }

}
