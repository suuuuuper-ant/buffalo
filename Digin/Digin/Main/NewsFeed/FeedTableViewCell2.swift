//
//  FeedTableViewCell2.swift
//  Digin
//
//  Created by 김예은 on 2021/04/28.
//

import UIKit

class FeedTableViewCell2: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    private func setup() {
        newsImageView.makeRounded(cornerRadius: 10)
        titleLabel.textColor = UIColor.appColor(.black62)
        contentsLabel.textColor = UIColor.appColor(.grey1)
    }

}
