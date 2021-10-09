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
        date.textColor = AppColor.gray160.color
        date.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return date
    }()

    let titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = AppColor.gray160.color
        title.text = "Digin은 영리한 주린이 앱인 것을 이 기사에서 소개하죠!"
        title.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return title
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16))
        dateLabel.sizeToFit()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        titleLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 10).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true

    }

    func configure(consensus: Consensus) {
        dateLabel.text = DateFormatter().convertBy(format: "yyyy-MM-dd", dateString: consensus.createdAt, oldFormat: "yyyy-MM-dd'T'HH:mm:ss")
        titleLabel.text = consensus.opinion.decription()

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
