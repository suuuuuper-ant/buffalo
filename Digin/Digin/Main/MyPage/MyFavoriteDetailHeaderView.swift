//
//  MyFavoriteDetailHeaderView.swift
//  Digin
//
//  Created by jinho jeong on 2021/06/22.
//

import UIKit

class MyFavoriteDetailHeaderView: UITableViewHeaderFooterView, ViewType {

    lazy var titleLabel: UILabel = {
       let title = UILabel()
        title.text = "홈화면"
        title.textColor = AppColor.darkgray82.color
        title.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return title
    }()

//    lazy var countLabel: UILabel = {
//       let count = UILabel()
//        count.text = "3/15"
//        count.textColor = AppColor.gray160.color
//        count.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        return count
//    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        self.contentView.backgroundColor = AppColor.lightgray249.color
        [titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }

    func setupConstraint() {
        // titleLabel
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28).isActive = true
        // countLabel
//        countLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 1).isActive = true
//        countLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
//        countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28).isActive = true
    }
}
