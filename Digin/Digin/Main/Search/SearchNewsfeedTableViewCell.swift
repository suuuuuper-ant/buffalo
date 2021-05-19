//
//  SearchNewsfeedTableViewCell.swift
//  Digin
//
//  Created by 김예은 on 2021/05/19.
//

import UIKit

class SearchNewsfeedTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    private func setup() {
        newsImageView.makeRounded(cornerRadius: 10)
    }

}
