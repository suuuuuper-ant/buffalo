//
//  HomeNewsCell.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/03.
//

import UIKit

class HomeNewsCell: UITableViewCell {

    let dateLabel: UILabel = {
        let date = UILabel()
        date.text = "00.00"
        date.textColor = UIColor.init(named: "gray_160")
        date.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        date.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return date
    }()

    let titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = UIColor.init(named: "darkgray_82")
        title.text = "Digin은 영리한 주린이 앱인 것을 이 기사에서 소개하죠!"
        title.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return title
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        titleLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
    }

    func configure(news: News) {
        dateLabel.text = news.date
        titleLabel.text = news.title

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
