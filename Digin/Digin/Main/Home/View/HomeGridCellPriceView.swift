//
//  HomeGridCellPriceView.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/04.
//

import UIKit

class HomeGridPriceArea: UIView {

    lazy var originLabel: UILabel = UILabel()
    lazy var dateLabel: UILabel = UILabel()
    lazy var byOrSellLabel: UILabel = {
        let label = UILabel()
        label.text = "SELL"
        label.font = UIFont.englishFont(ofSize: 30)
        return label

    }()

    lazy var reportButton: UIButton = {
        let report = UIButton()
        report.setImage(UIImage(named: "home_report"), for: .normal)
        report.imageView?.contentMode  = .scaleAspectFill
        return report
    }()

    lazy var reportLabel: UILabel = {
        let report = UILabel()
        report.text = "리포트"
        report.textColor = UIColor.init(named: "darkgray62")
        report.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        return report
    }()
    lazy var progressBarView: UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.progress = 0.5
        progressBar.backgroundColor = .darkGray
        progressBar.layer.cornerRadius = 10
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 10
        progressBar.progressTintColor = .systemPink
        return progressBar
    }()

    var opinionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "투자의견"
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 12.0)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
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
    }

    func configure(_ model: OpinionInfo) {
        self.byOrSellLabel.text = model.opinion

        let tailString = " | \(model.opinionCompany) \(model.opinionDate)"
        let totalString = "\(model.opinionDescription)\(tailString)"
        let attributedString = NSMutableAttributedString(string: "\(model.opinionDescription)\(tailString)", attributes: [
            .font: UIFont(name: "AppleSDGothicNeo-Medium", size: 12.0)!,
            .foregroundColor: UIColor.black,
            .kern: -0.4
        ])

        if let range = totalString.range(of: tailString) {
            attributedString.addAttribute(.font, value: UIFont(name: "AppleSDGothicNeo-Medium", size: 10.0)!, range: NSRange(range, in: totalString))
        }

        self.opinionLabel.attributedText = attributedString
    }
    private func addSubiews() {
        let subviews = [
            byOrSellLabel,
            reportButton,
            reportLabel,
            opinionLabel
        ]

        subviews.forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    var const: NSLayoutConstraint?
    private func setupConstraints() {

        let buyOrSellConstraints = [
            byOrSellLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 33),
            byOrSellLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            byOrSellLabel.trailingAnchor.constraint(equalTo: reportButton.leadingAnchor, constant: 16)
        ]

        let opinionLabelConstraints = [
            opinionLabel.topAnchor.constraint(equalTo: byOrSellLabel.bottomAnchor, constant: 11),
            opinionLabel.leadingAnchor.constraint(equalTo: byOrSellLabel.leadingAnchor),
            opinionLabel.trailingAnchor.constraint(equalTo: reportButton.leadingAnchor, constant: 16),
            opinionLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -5)
        ]

        let reportConstraints = [
            reportButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            reportButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            reportButton.widthAnchor.constraint(equalToConstant: 20),
            reportButton.heightAnchor.constraint(equalToConstant: 20)
        ]

        let reportLabelConstraints = [
            reportLabel.topAnchor.constraint(equalTo: reportButton.bottomAnchor, constant: 1),
            reportLabel.centerXAnchor.constraint(equalTo: reportButton.centerXAnchor)

        ]

        [
            buyOrSellConstraints,
            opinionLabelConstraints,
            reportConstraints,
            reportLabelConstraints
        ].forEach(NSLayoutConstraint.activate(_:))
    }
}
