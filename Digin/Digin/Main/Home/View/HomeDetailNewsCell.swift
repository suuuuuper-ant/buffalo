//
//  HomeDetailNewsCell.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/07.
//

import UIKit

class HomeDetailNewsCell: UITableViewCell, ViewType {

    lazy var  thumbnailImageView: UIImageView = {
        let thumbnail = UIImageView()
        thumbnail.makeRounded(cornerRadius: 10)
        thumbnail.backgroundColor = .gray
        return thumbnail
    }()

    lazy var titleLabel: UILabel = {
       let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        title.textColor = UIColor.init(named: "darkgray62")
        title.text = "[단독] 이찌안 귀엽다고 소리 지른 20대 여성 두명 붙잡혀..."
        title.numberOfLines = 2
        return title
    }()

    lazy var dateLabel: UILabel = {
       let date = UILabel()
        date.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        date.textColor = UIColor.init(named: "gray160")
        date.text = "연합뉴스 | 04. 17. 19:14"
        return date
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        [titleLabel, thumbnailImageView, dateLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setupConstraint() {
        //thumbnail
        thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true

        thumbnailImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true

        //title
        titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        //date
        dateLabel.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
       let dateTop = dateLabel.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor)
        dateTop.priority = .defaultLow
        dateTop.isActive = true

    }

}
