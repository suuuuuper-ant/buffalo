//
//  DetailsCategoryCollectionViewCell.swift
//  Digin
//
//  Created by 김예은 on 2021/05/10.
//

import UIKit

class DetailsCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        contentView.makeRounded(cornerRadius: 10)
        contentView.backgroundColor = UIColor.appColor(.bgLightGrey)

        //shadow
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.15
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }

}
