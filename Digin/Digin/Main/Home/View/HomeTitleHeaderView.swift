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

    let radomPickButton: UIButton = {
       let randomPick = UIButton()
        randomPick.setTitle("오늘 꼭 하나만 보고싶다면? (랜덤뽑기btn)", for: .normal)
        randomPick.layer.cornerRadius = 10
        randomPick.clipsToBounds = true
        randomPick.translatesAutoresizingMaskIntoConstraints = false
        randomPick.backgroundColor = .lightGray
        return randomPick
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

        addSubview(radomPickButton)
        radomPickButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        radomPickButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        radomPickButton.heightAnchor.constraint(equalToConstant: 73).isActive = true
        radomPickButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true

    }

}
