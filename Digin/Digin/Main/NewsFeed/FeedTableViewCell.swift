//
//  FeedTableViewCell.swift
//  Digin
//
//  Created by 김예은 on 2021/04/20.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}
