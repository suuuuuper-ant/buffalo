//
//  HomeTitleHeaderView.swift
//  Digin
//
//  Created by jinho jeong on 2021/06/16.
//

import UIKit

class HomeTitleHeaderView: UITableViewHeaderFooterView {

    let sectionLabel: UILabel = {
        let section = UILabel()
        section.font = UIFont.englishFont(ofSize: 16)
        return section
    }()
    let backContentView = UIView()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(backContentView)
        backContentView.translatesAutoresizingMaskIntoConstraints = false
        backContentView.fittingView(contentView)
        backContentView.addSubview(sectionLabel)

        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionLabel.leadingAnchor.constraint(equalTo: backContentView.leadingAnchor, constant: 20).isActive = true
        sectionLabel.trailingAnchor.constraint(equalTo: backContentView.trailingAnchor, constant: -20).isActive = true
        sectionLabel.topAnchor.constraint(equalTo: backContentView.topAnchor, constant: 0).isActive = true
        sectionLabel.bottomAnchor.constraint(equalTo: backContentView.bottomAnchor, constant: -16).isActive = true

    }
}
