//
//  MyFavoriteEditDetailCell.swift
//  Digin
//
//  Created by jinho jeong on 2021/06/24.
//

import UIKit

class MyFavoriteEditDetailCell: UITableViewCell, ViewType {
    lazy var thumbnailImageView: UIImageView = {
        let thumbnail = UIImageView()
        thumbnail.layer.cornerRadius = 28 / 2
        thumbnail.clipsToBounds = true
        thumbnail.image = UIImage(named: "digin_logo")
        return thumbnail
    }()

    lazy var downloadImageView: UIImageView = {
        let download = UIImageView()
        download.image = UIImage(named: "icon_download")
        return download
    }()

    lazy var reorderImageView: UIImageView = {
        let reorder = UIImageView()
        reorder.image = UIImage(named: "icon_reorder")
        return reorder
    }()

    lazy var companyLabel: UILabel = {
        let company = UILabel()
        company.text = "testas;ldsa"
        company.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        company.textColor = AppColor.darkgray62.color
        company.numberOfLines = 0
        return company
    }()

    lazy var separatedLine: UIView = {
        let separated = UIView()
        separated.backgroundColor = AppColor.lightgray239.color

        return separated
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
        self.contentView.backgroundColor = .white
        [thumbnailImageView, companyLabel, downloadImageView, reorderImageView, separatedLine].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setupConstraint() {
        downloadImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        downloadImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        downloadImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        downloadImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        thumbnailImageView.leadingAnchor.constraint(equalTo: downloadImageView.trailingAnchor, constant: 10).isActive = true
        thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true

        thumbnailImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true

        // companyLabel
        companyLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10).isActive = true
        companyLabel.trailingAnchor.constraint(greaterThanOrEqualTo: reorderImageView.leadingAnchor, constant: 0).isActive = true
        companyLabel.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor).isActive = true

        reorderImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        reorderImageView.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor).isActive = true
        reorderImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        reorderImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        separatedLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        separatedLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        separatedLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatedLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
