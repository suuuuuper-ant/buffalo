//
//  FeedTableViewCell3.swift
//  Digin
//
//  Created by 김예은 on 2021/04/28.
//

import UIKit

class FeedTableViewCell3: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lineView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    private func setup() {
        titleLabel.textColor = UIColor.appColor(.black62)
        lineView.backgroundColor = UIColor.appColor(.lightGrey2)
    }

}
