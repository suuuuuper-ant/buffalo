//
//  HomeDetailHeaderView.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/04.
//

import UIKit

class HomeDetailHeaderView: UITableViewCell, ViewType {
    struct UI {
        static let companyImageWidthAndHeight: CGFloat = 32
        static let contentViewLeading: CGFloat = 20
        static let contentviewTrailing: CGFloat = -20
        static let contentviewTop: CGFloat = 29
        static let contentviewBottom: CGFloat = 0
        static let likeButtonWidthAndHeight: CGFloat = 20
        static let contentAreaHeight: CGFloat = 115
    }
    lazy var companyImageView: UIImageView = {
        let companyImage = UIImageView()
        companyImage.makeRounded(cornerRadius: UI.companyImageWidthAndHeight / 2)
        companyImage.backgroundColor = .lightGray
        return companyImage
    }()

    let companyLabel: UILabel = {
        let company = UILabel()
        company.text = "프레스티지바이오로직스바이오"
        company.font = UIFont.boldSystemFont(ofSize: 24)
        company.numberOfLines = 2
        company.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return company
    }()

    lazy var likeButton: UIButton = {
        let like = UIButton()
        like.setImage(UIImage(named: "icon_home_like"), for: .normal)
        return like
    }()

    lazy var likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(named: "darkgray_52")
        label.text = "23123"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    lazy var contentArea: HomeGridPriceArea = {
        let area = HomeGridPriceArea()
        area.layer.cornerRadius = 15
        area.layer.borderColor = UIColor.init(named: "stock_sell")?.cgColor
        area.layer.borderWidth = 1.0
        area.layer.masksToBounds = true
        area.backgroundColor = .white
        return area
    }()

    lazy var relativeTagStack: UIStackView = {
        let tag = UIStackView()
        tag.spacing = 10
        tag.backgroundColor = .lightGray
        tag.alignment = .leading
        return tag
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
        contentView.backgroundColor = UIColor.init(named: "home_background")
        [companyImageView, companyLabel, likeButton, likeCountLabel, contentArea, relativeTagStack].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        for label in TagGenerator(3).generateTagLabels() {
            relativeTagStack.addArrangedSubview(label)
        }
    }

    func configure(tags: [String]) {
        tags.enumerated().forEach { (index, str) in
            (relativeTagStack.subviews[index] as? UILabel)?.isHidden = false
            (relativeTagStack.subviews[index] as? UILabel)?.text  = str

        }

        for idx in (tags.count..<relativeTagStack.subviews.count) {
            (relativeTagStack.subviews[idx] as? UILabel)?.isHidden = true

        }
    }

    func setupConstraint() {
        companyImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.contentViewLeading).isActive = true
        companyImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UI.contentviewTop).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: UI.companyImageWidthAndHeight).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: UI.companyImageWidthAndHeight).isActive = true

        companyLabel.leadingAnchor.constraint(equalTo: companyImageView.leadingAnchor).isActive = true
        companyLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor, constant: 16).isActive = true
        companyLabel.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: -30).isActive = true

        likeButton.topAnchor.constraint(equalTo: companyLabel.topAnchor, constant: 2).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: UI.likeButtonWidthAndHeight).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: UI.likeButtonWidthAndHeight).isActive = true

        likeCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 4).isActive = true
        likeCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: UI.contentviewTrailing).isActive = true
        likeCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor).isActive = true

        relativeTagStack.leadingAnchor.constraint(equalTo: companyImageView.leadingAnchor).isActive = true
        relativeTagStack.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: 10).isActive = true
        relativeTagStack.trailingAnchor.constraint(lessThanOrEqualTo: likeCountLabel.trailingAnchor, constant: -40).isActive = true

        contentArea.leadingAnchor.constraint(equalTo: companyImageView.leadingAnchor).isActive = true
        contentArea.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: UI.contentviewTrailing).isActive = true
        contentArea.topAnchor.constraint(equalTo: relativeTagStack.bottomAnchor, constant: 25).isActive = true
        contentArea.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: UI.contentviewBottom).isActive = true
        contentArea.heightAnchor.constraint(equalToConstant: UI.contentAreaHeight).isActive = true

}
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
