//
//  DetailsCompanyTableViewCell.swift
//  Digin
//
//  Created by 김예은 on 2021/05/10.
//

import UIKit

class DetailsCompanyTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: PaddingLabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    private func setup() {
        logoImageView.makeCircle()

        categoryLabel.makeRounded(cornerRadius: 13)
        categoryLabel.layer.borderWidth = 1
        categoryLabel.edgeInset = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
    }

}
