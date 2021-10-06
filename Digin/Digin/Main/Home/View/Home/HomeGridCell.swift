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
        label.font = UIFont.boldSystemFont(ofSize: 20)
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

    lazy var consensusView: HomeGridConsensusView = {
        let consensus = HomeGridConsensusView()
        return consensus
    }()

    lazy var  thumbnailImageView: UIImageView = {
        let thumbnail = UIImageView()
        thumbnail.makeRounded(cornerRadius: 10)
        thumbnail.backgroundColor = .gray
        thumbnail.contentMode = .scaleAspectFill
        return thumbnail
    }()

    lazy var newsTitleLabel: UILabel = {
       let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        title.textColor = UIColor.init(named: "darkgray62")
        title.text = "[단독] 이찌안 귀엽다고 소리 지른 20대 여성 두명 붙잡혀..."
        title.numberOfLines = 3
        return title
    }()

    lazy var dateLabel: UILabel = {
       let date = UILabel()
        date.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        date.textColor = UIColor.init(named: "gray160")
        date.text = "연합뉴스 | 04. 17. 19:14"
        return date
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

        favoriteCompanyLabel.text = model.company.shortName
      //  newsArea.news = model.newsList
        likeCountLabel.text = String(model.company.likeCount)

        consensusView.configure(model.consensusList)
        companyImageView.kf.setImage(with: URL(string: model.company.imageUrl))

        if let firstNews = model.newsList.first {
            newsTitleLabel.text = firstNews.title
        }
        //thumbnailImageView.kf.setImage(with: )
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
            favoriteCompanyLabel.centerYAnchor.constraint(equalTo: companyImageView.centerYAnchor),
            favoriteCompanyLabel.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: -10)
        ]

        let likeButtonConstraints = [
            likeButton.centerYAnchor.constraint(equalTo: companyImageView.centerYAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 20),
            likeButton.heightAnchor.constraint(equalToConstant: 20)
        ]

        let likeCountConstraints = [
            likeCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            likeCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 4),
            likeCountLabel.trailingAnchor.constraint(equalTo: roundShadowView.trailingAnchor, constant: -14)
        ]
        let consensusViewConstraints = [
            consensusView.leadingAnchor.constraint(equalTo: roundShadowView.leadingAnchor),
            consensusView.trailingAnchor.constraint(equalTo: roundShadowView.trailingAnchor),
            consensusView.topAnchor.constraint(equalTo: favoriteCompanyLabel.bottomAnchor, constant: 25),
            consensusView.heightAnchor.constraint(equalToConstant: 135)
        ]

        let thumbnailImageViewConst = [
            thumbnailImageView.leadingAnchor.constraint(equalTo: roundShadowView.leadingAnchor, constant: 16),
            thumbnailImageView.topAnchor.constraint(equalTo: consensusView.bottomAnchor, constant: 24),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 90),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 70)
        ]

        let newsTitleLabelConst = [
            newsTitleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            newsTitleLabel.topAnchor.constraint(equalTo: consensusView.bottomAnchor, constant: 24),
            newsTitleLabel.trailingAnchor.constraint(equalTo: roundShadowView.trailingAnchor, constant: -16)

        ]

        [roundShadowViewConstraints,
         companyImageViewConstraints,
         favoriteCompanyLabelConstraints,
         likeButtonConstraints,
         likeCountConstraints,
         consensusViewConstraints,
         thumbnailImageViewConst,
         newsTitleLabelConst
        ].forEach(NSLayoutConstraint.activate(_:))
    }

    private func addSubiews() {
        addSubview(roundShadowView)
        backgroundColor = UIColor.init(named: "home_background")
        roundShadowView.backgroundColor = UIColor.init(named: "home_background")
        roundShadowView.translatesAutoresizingMaskIntoConstraints = false
        let subviews = [companyImageView, favoriteCompanyLabel, likeButton, likeCountLabel, consensusView, thumbnailImageView, newsTitleLabel]

        subviews.forEach {
            roundShadowView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
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
