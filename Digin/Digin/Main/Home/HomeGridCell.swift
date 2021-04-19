//
//  HomeGridCell.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/19.
//

import UIKit

class HomeGridCell: UITableViewCell {
    let favoriteCompanyLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "관심기업"
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(favoriteCompanyLabel)
        favoriteCompanyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        favoriteCompanyLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
