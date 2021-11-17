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
        thumbnail.image = UIImage(named: "digin_logo")
        return thumbnail
    }()

    lazy var companyLabel: UILabel = {
        let company = UILabel()
        company.text = "testas;ldsa"
        company.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        company.textColor = AppColor.darkgray62.color
        company.numberOfLines = 0
        return company
    }()

//    let tagLabel: PaddingLabel = {
//        let company = PaddingLabel()
//        company.edgeInset = UIEdgeInsets(top: 10, left: 12, bottom: 8, right: 12)
//        company.font = UIFont.englishFont(ofSize: 12)
//        company.layer.cornerRadius = 15
//        company.text = "Not Rated"
//        company.layer.borderColor = AppColor.darkgray82.color.cgColor
//        company.layer.borderWidth = 1
//        company.textColor = AppColor.darkgray82.color
//        return company
//    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        self.setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        self.contentView.backgroundColor = AppColor.lightgray249.color
        [thumbnailImageView, companyLabel].forEach {
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
        thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true

        // companyLabel
        companyLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10).isActive = true
        companyLabel.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor).isActive = true

    }

}
