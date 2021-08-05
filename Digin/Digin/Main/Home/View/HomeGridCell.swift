//
//  HomeGridCell.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/19.
//

import UIKit
import SwiftUI

class HomeGridCell: UICollectionViewCell {
    lazy var favoriteCompanyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "관심기업"
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    // image size 32
    lazy var companyImageView: UIImageView = {
        let companyImage = UIImageView()
        companyImage.backgroundColor = UIColor.init(named: "home_background")
        companyImage.makeRounded(cornerRadius: 32 / 2)
        companyImage.contentMode = .scaleAspectFill

        return companyImage
    }()

    lazy var relativeTagStack: UIStackView = {
        let tag = UIStackView()
        tag.spacing = 5
        tag.alignment = .leading
        return tag
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
        label.numberOfLines = 1
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

    lazy var newsArea: NewsArea = {
        let news = NewsArea()
        return news
    }()

    lazy var roundShadowView = RoundShadowView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubiews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(model: HomeUpdatedCompany) {

        //모델개수만큼 relativeTagStack 앞에서부터 업데이트
//        model.tags.enumerated().forEach { (index, str) in
//            (relativeTagStack.subviews[index] as? UILabel)?.isHidden = false
//            (relativeTagStack.subviews[index] as? UILabel)?.text  = str
//        }
        //모델 업데이트 이후에도 relativeTagStack의 서브뷰가 남아 있다면 숨김
//        for idx in (model.tags.count..<relativeTagStack.subviews.count) {
//            (relativeTagStack.subviews[idx] as? UILabel)?.isHidden = true
//        }

        favoriteCompanyLabel.text = model.company.shortName
        newsArea.news = model.newsList
        likeCountLabel.text = String(model.company.likeCount)

        if let opinionInfo = model.consensusList.first {
            contentArea.layer.borderColor = opinionInfo.opinion.colorForType().cgColor

            contentArea.configure(opinionInfo)
        }

        companyImageView.kf.setImage(with: URL(string: model.company.imageUrl))
    }

    private func setupConstraints() {

        let roundShadowViewConstraints = [
            roundShadowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            roundShadowView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            roundShadowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            roundShadowView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ]

        let companyImageViewConstraints = [
            companyImageView.leadingAnchor.constraint(equalTo: roundShadowView.leadingAnchor, constant: 16),
            companyImageView.topAnchor.constraint(equalTo: roundShadowView.topAnchor, constant: 30),
            companyImageView.widthAnchor.constraint(equalToConstant: 32),
            companyImageView.heightAnchor.constraint(equalToConstant: 32)
        ]

        let favoriteCompanyLabelConstraints = [
            favoriteCompanyLabel.leadingAnchor.constraint(equalTo: companyImageView.trailingAnchor, constant: 10),
            favoriteCompanyLabel.topAnchor.constraint(equalTo: companyImageView.topAnchor),
            favoriteCompanyLabel.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: -10)
        ]

        let likeButtonConstraints = [
            likeButton.topAnchor.constraint(equalTo: companyImageView.topAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 20),
            likeButton.heightAnchor.constraint(equalToConstant: 20)
        ]

        let likeCountConstraints = [
            likeCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            likeCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 4),
            likeCountLabel.trailingAnchor.constraint(equalTo: roundShadowView.trailingAnchor, constant: -14)
        ]

        let relativeTagStackConstraints = [
            relativeTagStack.leadingAnchor.constraint(equalTo: companyImageView.leadingAnchor),
            relativeTagStack.topAnchor.constraint(equalTo: companyImageView.bottomAnchor, constant: 17),
            relativeTagStack.trailingAnchor.constraint(lessThanOrEqualTo: roundShadowView.trailingAnchor, constant: -40)

        ]

        let contentAreaConstraints = [
            contentArea.leadingAnchor.constraint(equalTo: roundShadowView.leadingAnchor, constant: 16),
            contentArea.trailingAnchor.constraint(equalTo: roundShadowView.trailingAnchor, constant: -16),
            contentArea.topAnchor.constraint(equalTo: relativeTagStack.bottomAnchor, constant: 20),
            contentArea.heightAnchor.constraint(equalToConstant: 115)
        ]

        let newsAreaConstraints = [
            newsArea.leadingAnchor.constraint(equalTo: roundShadowView.leadingAnchor, constant: 16),
            newsArea.trailingAnchor.constraint(equalTo: roundShadowView.trailingAnchor, constant: -16),
            newsArea.topAnchor.constraint(equalTo: contentArea.bottomAnchor, constant: 20),
            newsArea.heightAnchor.constraint(equalToConstant: 150)
        ]

        [roundShadowViewConstraints,
         companyImageViewConstraints,
         favoriteCompanyLabelConstraints,
         relativeTagStackConstraints,
         likeButtonConstraints,
         likeCountConstraints,
         contentAreaConstraints,
         newsAreaConstraints
        ].forEach(NSLayoutConstraint.activate(_:))
    }

    private func addSubiews() {
        addSubview(roundShadowView)
        backgroundColor = UIColor.init(named: "home_background")
        roundShadowView.backgroundColor = UIColor.init(named: "home_background")
        roundShadowView.translatesAutoresizingMaskIntoConstraints = false
        let subviews = [companyImageView, favoriteCompanyLabel, relativeTagStack, likeButton, likeCountLabel, contentArea, newsArea]

        subviews.forEach {
            roundShadowView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        for label in TagGenerator(3).generateTagLabels() {
            relativeTagStack.addArrangedSubview(label)
        }
    }
}

class TagGenerator {

    let count: Int
    let textArray: [String]?
    init(_ count: Int, textArray: [String]? = nil) {
        self.count = count
        self.textArray = textArray
    }

    func generateTagLabels() -> [PaddingLabel] {

        var labels: [PaddingLabel] = []
        for index in (0..<count) {

            let label = PaddingLabel()
            label.edgeInset = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
            label.makeRounded(cornerRadius: 13)
            label.font = UIFont.systemFont(ofSize: 12, weight: .medium)

            if index == 0 {
                label.backgroundColor = UIColor.init(named: "tag_color")
                label.textColor = .white
            } else {
                label.backgroundColor = UIColor.white
                label.layer.borderWidth = 1
            }

            label.text = textArray?[safe: index]
            labels.append(label)
        }
        return labels
    }

}
