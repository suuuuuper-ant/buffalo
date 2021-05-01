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

        return companyImage
    }()

    lazy var relativeTagStack: UIStackView = {
        let tag = UIStackView()
        tag.spacing = 10
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
        area.layer.borderColor = UIColor.init(named: "stock_blue")?.cgColor
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

    func configure(model: Company) {

        model.tags.enumerated().forEach { (index, str) in
            (relativeTagStack.subviews[index] as? UILabel)?.isHidden = false
            (relativeTagStack.subviews[index] as? UILabel)?.text  = str

        }

        for idx in (model.tags.count..<relativeTagStack.subviews.count) {
            (relativeTagStack.subviews[idx] as? UILabel)?.isHidden = true

        }

        favoriteCompanyLabel.text = model.interestingCompany

//        contentArea.model =  Float(model.currentPrice)! / (Float(model.targetPrice) ?? 0.0 )
        newsArea.news = model.news
        likeCountLabel.text = String(model.likeCount)

        contentArea.configure(model.opinionInfo)
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

class HomeGridPriceArea: UIView {

    lazy var originLabel: UILabel = UILabel()
    lazy var dateLabel: UILabel = UILabel()
    lazy var byOrSellLabel: UILabel = {
        let label = UILabel()
        label.text = "SELL"
        label.font = UIFont.systemFont(ofSize: 30)
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

class TagGenerator {

    let count: Int
    let textArray: [String]?
    init(_ count: Int, textArray: [String]? = nil) {
        self.count = count
        self.textArray = textArray
    }

    func generateTagLabels() -> [PaddingLabel] {

        var labels: [PaddingLabel] = []
        for index in (0...2) {

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

            labels.append(label)
        }
        return labels
    }

}

class PaddingLabel: UILabel {

    var edgeInset: UIEdgeInsets = .zero

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: edgeInset.top, left: edgeInset.left, bottom: edgeInset.bottom, right: edgeInset.right)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + edgeInset.left + edgeInset.right, height: size.height + edgeInset.top + edgeInset.bottom)
    }
}

class NewsArea: UIView, UITableViewDataSource, UITableViewDelegate {

    var news: [News] = [] {
        didSet {
            newsTableView.reloadData()
        }
    }

    lazy var newsTableView: UITableView = {
        let news = UITableView()
        news.delegate = self
        news.dataSource = self
        news.isScrollEnabled = false

        news.register(HomeNewCell.self, forCellReuseIdentifier: HomeNewCell.reuseIdentifier)
        return news
    }()

    lazy var moreLabel: UILabel = {
        let moreLabel = UILabel()
        moreLabel.text = "뉴스 더보기"
        moreLabel.textColor = UIColor(named: "darkgray_82")
        moreLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return moreLabel
    }()

    lazy var moreButton: UIButton = {
        let more = UIButton()
        more.setImage(UIImage(named: "home_new_more"), for: .normal)
        return more
    }()

    lazy var divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor.init(named: "divider_color")
        return divider

    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        addSubview(newsTableView)
        newsTableView.translatesAutoresizingMaskIntoConstraints = false
        newsTableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        newsTableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        newsTableView.topAnchor.constraint(equalTo: topAnchor).isActive = true

        addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false

        divider.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        divider.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        let dividerCostraints = divider.topAnchor.constraint(equalTo: newsTableView.bottomAnchor, constant: 4.5)
        dividerCostraints.priority = .defaultLow
        dividerCostraints.isActive = true

        addSubview(moreLabel)
        moreLabel.translatesAutoresizingMaskIntoConstraints = false
        moreLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        moreLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 16.5).isActive = true
        moreLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -31).isActive = true

        addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.centerYAnchor.constraint(equalTo: moreLabel.centerYAnchor).isActive = true
        moreButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        moreButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: 20).isActive = true

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return news.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let homeNewCell = tableView.dequeueReusableCell(withIdentifier: HomeNewCell.reuseIdentifier) as? HomeNewCell
        let news = self.news[indexPath.row]
        homeNewCell?.configure(news: news)
        homeNewCell?.selectionStyle = .none
        return homeNewCell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}

class HomeNewCell: UITableViewCell {

    let dateLabel: UILabel = {
        let date = UILabel()
        date.text = "00.00"
        date.textColor = UIColor.init(named: "gray_160")
        date.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        date.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return date
    }()

    let titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = UIColor.init(named: "darkgray_82")
        title.text = "Digin은 영리한 주린이 앱인 것을 이 기사에서 소개하죠!"
        title.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return title
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        titleLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
    }

    func configure(news: News) {
        dateLabel.text = news.date
        titleLabel.text = news.title

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
