//
//  HomeGridCell.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/19.
//

import UIKit
import SwiftUI

class HomeGridCell: UITableViewCell {
    lazy var favoriteCompanyLabel: UILabel = {
        let label = UILabel()
        label.text = "관심기업"
        return label
    }()

    lazy var relativeTagStack: UIStackView = {
        let tag = UIStackView()
        tag.spacing = 10
        tag.alignment = .leading
        tag.addArrangedSubview(UILabel())
        tag.addArrangedSubview(UILabel())
        tag.addArrangedSubview(UILabel())
        return tag
    }()

    lazy var likeButton: UIButton = {
        let like = UIButton()
        like.backgroundColor  = .red
        return like
    }()

    lazy var contentArea: HomeGridPriceArea = HomeGridPriceArea()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubiews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(model: [String]) {

        model.enumerated().forEach { (index, str) in
            (relativeTagStack.subviews[index] as? UILabel)?.text  = str
        }

        for idx in (model.count..<relativeTagStack.subviews.count) {
            (relativeTagStack.subviews[idx] as? UILabel)?.text = ""
        }

        contentArea.model = Float.random(in: 0..<1)
    }

    private func setupConstraints() {

        let favoriteCompanyLabelConstraints = [
            favoriteCompanyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            favoriteCompanyLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20)
        ]

        let likeButtonConstraints = [
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            likeButton.bottomAnchor.constraint(equalTo: relativeTagStack.bottomAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 20),
            likeButton.heightAnchor.constraint(equalToConstant: 20)
        ]
        likeButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let relativeTagStackConstraints = [
            relativeTagStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            relativeTagStack.topAnchor.constraint(equalTo: favoriteCompanyLabel.bottomAnchor, constant: 14),
            relativeTagStack.trailingAnchor.constraint(lessThanOrEqualTo: likeButton.leadingAnchor, constant: -40)

        ]

        let contentAreaConstraints = [
            contentArea.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 9),
            contentArea.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -9),
            contentArea.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 18.5),
            contentArea.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -140)
        ]

        contentArea.backgroundColor = .gray

        [favoriteCompanyLabelConstraints,
         relativeTagStackConstraints,
         likeButtonConstraints,
         contentAreaConstraints
        ].forEach(NSLayoutConstraint.activate(_:))
    }

    private func addSubiews() {
        backgroundColor = UIColor.lightGray
           let subviews = [favoriteCompanyLabel, relativeTagStack, likeButton, contentArea]

           subviews.forEach {
               contentView.addSubview($0)
               $0.translatesAutoresizingMaskIntoConstraints = false
           }
       }
}

class HomeGridPriceArea: UIView {

    lazy var originLabel: UILabel = UILabel()
    lazy var dateLabel: UILabel = UILabel()
    lazy var byOrSellLabel: UILabel = {
        let label = UILabel()
        label.text = "BUY or Sell"
        label.font = UIFont.systemFont(ofSize: 30)
        return label

    }()

    lazy var iconImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .yellow
        return image
    }()
    lazy var progressBarView: UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.progress = 0.5
        progressBar.backgroundColor = .darkGray
        progressBar.layer.cornerRadius = 10
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 10
        progressBar.progressTintColor = .systemPink
//        progressBar.subviews[1].clipsToBounds = true
//        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 8)
        return progressBar
    }()

    var currentPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "현재가\n59,999"
        return label
    }()

    var model: Float = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubiews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        print(frame.width * CGFloat(progressBarView.progress))
        const?.constant = progressBarView.frame.width * CGFloat(progressBarView.progress)
        progressBarView.progress = Float(model)

    }
    private func addSubiews() {
           let subviews = [originLabel,
                           dateLabel,
                           byOrSellLabel,
                           iconImageView,
                           progressBarView,
                           currentPrice
           ]

           subviews.forEach {
               self.addSubview($0)
               $0.translatesAutoresizingMaskIntoConstraints = false
           }
    }
    var const: NSLayoutConstraint?
    private func setupConstraints() {

        originLabel.text = "한경컨센서스"
        let originConstraints = [
            originLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            originLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10)
        ]

        let buyOrSellConstraints = [
            byOrSellLabel.topAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: 13),
            byOrSellLabel.leadingAnchor.constraint(equalTo: originLabel.leadingAnchor)
        ]

        dateLabel.text = "21.04.23"
        let dateConstraints = [
            dateLabel.bottomAnchor.constraint(equalTo: originLabel.bottomAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -21),
            dateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: originLabel.trailingAnchor, constant: 48)
        ]

        let iconConstraints = [
            iconImageView.centerYAnchor.constraint(equalTo: byOrSellLabel.centerYAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20)
        ]

//        let targetPriceConstraint = [
//            targetPriceLabel.topAnchor.constraint(equalTo: byOrSellLabel, constant: 10)
//            tar
//        ]

        let progressBarConstraints = [
            progressBarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            progressBarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            progressBarView.heightAnchor.constraint(equalToConstant: 20),
            progressBarView.bottomAnchor
                .constraint(equalTo: bottomAnchor, constant: -16)
        ]

//        let currentPriceConstraints = [
      const = currentPrice.centerXAnchor.constraint(equalTo: leadingAnchor, constant: frame.width * CGFloat(progressBarView.progress))
        const?.isActive = true
            currentPrice.bottomAnchor.constraint(equalTo: progressBarView.topAnchor, constant: -10).isActive = true
     //   ]
        [originConstraints,
         buyOrSellConstraints,
         dateConstraints,
         iconConstraints,
         progressBarConstraints
        ].forEach(NSLayoutConstraint.activate(_:))
    }
}

class ProgressBarView: UIView {
    let progressLayer = CALayer()
    var progress: CGFloat = 0.5 {
        didSet {
            setNeedsDisplay()
        }
    }
    var currentPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.text = "현재가/n59,999"
        return label
    }()

    override func draw(_ rect: CGRect) {
       // super.draw(rect)
        let backgroundMask  = CAShapeLayer()
        backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.25).cgPath
        layer.mask = backgroundMask

        let prorgressRect = CGRect(origin: .zero, size: CGSize(width: rect.width * progress, height: rect.height))
        progressLayer.frame = prorgressRect
       // layer.addSublayer(progressLayer)
        progressLayer.backgroundColor = UIColor.systemPink.cgColor
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(progressLayer)
        backgroundColor = .darkGray

        addSubview(currentPrice)

    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
