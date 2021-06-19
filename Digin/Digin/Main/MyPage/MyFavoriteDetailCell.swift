//
//  MyFavoriteDetailCell.swift
//  Digin
//
//  Created by jinho jeong on 2021/06/19.
//

import UIKit

class MyFavoriteDetailCell: UITableViewCell, ViewType {

    lazy var thumbnailImageView: UIImageView = {
        let thumbnail = UIImageView()
        thumbnail.layer.cornerRadius = 28 / 2
        thumbnail.clipsToBounds = true
        return thumbnail
    }()

    lazy var companyLabel: UILabel = {
        let company = UILabel()
        company.text = "testtest"
        company.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        company.textColor = AppColor.darkgray62.color
        return company
    }()

    let tagLabel: PaddingLabel = {
        let company = PaddingLabel()
        company.edgeInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        company.font = UIFont.englishFont(ofSize: 12)
        company.layer.cornerRadius = 20
        return company
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        self.setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        [thumbnailImageView, companyLabel, tagLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setupConstraint() {
        // thumbnailImageView
        thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
//        // companyLabel
//        companyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
//        companyLabel.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor).isActive = true
//
//        // tagLabel
//        tagLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
//        tagLabel.centerYAnchor.constraint(equalTo: tagLabel.centerYAnchor).isActive = true
//        tagLabel.leadingAnchor.constraint(greaterThanOrEqualTo: companyLabel.trailingAnchor, constant: 20).isActive = true

    }

}
