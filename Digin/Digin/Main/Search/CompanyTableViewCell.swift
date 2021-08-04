//
//  CompanyTableViewCell.swift
//  Digin
//
//  Created by 김예은 on 2021/05/03.
//

import UIKit

class CompanyTableViewCell: UITableViewCell {

    @IBOutlet weak var topC: NSLayoutConstraint!
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
        categoryLabel.layer.borderColor = AppColor.darkgray62.color.cgColor
        categoryLabel.edgeInset = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
    }

}
