//
//  HomeGridEmptyView.swift
//  Digin
//
//  Created by jinho jeong on 2021/10/14.
//

import UIKit

final class HomeGridEmptyView: UIView {

    lazy var descriptionLabel: UILabel = {
        let description = UILabel()
        description.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        description.textColor = AppColor.gray183.color
        description.text = descriptionString
        return description
    }()

    lazy var iconImageView: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "image_home_empty"))
        icon.isHidden = isIconHidden
        return icon
    }()

    var descriptionString: String
    var isIconHidden: Bool

    init(description: String, isIconHidden: Bool = true) {
        self.descriptionString = description
        self.isIconHidden = isIconHidden
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        [descriptionLabel, iconImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }

    private func setupConstraints() {
        descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 120.0).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 115.0).isActive = true

    }

}
