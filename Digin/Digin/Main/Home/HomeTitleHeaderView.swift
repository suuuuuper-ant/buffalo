//
//  HomeTitleHeaderView.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/19.
//

import UIKit

class HomeTitleHeaderView: UITableViewHeaderFooterView {
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "04.14"
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    let greetingLabel: UILabel = {
        let greeting = UILabel()
        greeting.numberOfLines = 0
        greeting.text = "안녕하세요~\n어쩌구님~\n어쩌구하세요 헤헷\n렛츠디긴 ㅎㅎ"
        greeting.font = UIFont.systemFont(ofSize: 20)
        greeting.translatesAutoresizingMaskIntoConstraints = false
        return greeting
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(dateLabel)
        dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true

        addSubview(greetingLabel)
        greetingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        greetingLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 50).isActive = true

    }

}
