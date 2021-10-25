//
//  HomeDetailPriceView.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/23.
//

import UIKit
import Combine

class HomeDetailPriceView: UIView {
    var subscriptions = Set<AnyCancellable>()
    //    lazy var majorityOpinion = {
    //        let opinion = UIView()
    //        opinion.
    //        return opinion
    //    }
    //    lazy var originLabel: UILabel = UILabel()
    //    lazy var dateLabel: UILabel = UILabel()
    //    lazy var byOrSellLabel: UILabel = {
    //        let label = UILabel()
    //        label.text = "SELL"
    //        label.font = UIFont.englishFont(ofSize: 30)
    //        return label
    //
    //    }()
    //
    //    lazy var reportButton: UIButton = {
    //        let report = UIButton()
    //        report.setImage(UIImage(named: "home_report_white"), for: .normal)
    //        report.imageView?.contentMode  = .scaleAspectFill
    //        return report
    //    }()
    //
    //    lazy var reportLabel: UILabel = {
    //        let report = UILabel()
    //        report.text = "리포트"
    //        report.textColor = UIColor.white
    //        report.font = UIFont.systemFont(ofSize: 10, weight: .medium)
    //        return report
    //    }()
    //    lazy var progressBarView: UIProgressView = {
    //        let progressBar = UIProgressView()
    //        progressBar.progress = 0.5
    //        progressBar.backgroundColor = .darkGray
    //        progressBar.layer.cornerRadius = 10
    //        progressBar.clipsToBounds = true
    //        progressBar.layer.sublayers![1].cornerRadius = 10
    //        progressBar.progressTintColor = .systemPink
    //        return progressBar
    //    }()
    //
    //    var opinionLabel: UILabel = {
    //        let label = UILabel()
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        label.numberOfLines = 0
    //        label.text = "투자의견"
    //        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 12.0)
    //        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    //        return label
    //    }()

    lazy var topTagView: PaddingLabel = {
        let topTag = PaddingLabel()
        topTag.edgeInset = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
        topTag.font = UIFont.englishFont(ofSize: 10)
        topTag.layer.cornerRadius = 10
        topTag.clipsToBounds = true
        topTag.text = "NEW!"
        topTag.backgroundColor = .white
        return topTag
    }()

    lazy var headOpinionLabel: UILabel = {
        let head = UILabel()
        head.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        head.textColor = .white
        head.numberOfLines = 0
        return head
    }()

    lazy var tailOpinionLabel: UILabel = {
        let tailOpinion = UILabel()
        return tailOpinion
    }()

    lazy var consensusInfoLabel: UILabel = {
        let consensusInfo = UILabel()
        consensusInfo.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        consensusInfo.textColor = .white
        return consensusInfo
    }()

    lazy var linkButton: UIButton = {
        let link = UIButton()
        link.setImage(UIImage(named: "icon_report"), for: .normal)
        link.layer.cornerRadius = 30 / 2
        link.clipsToBounds = true

        return link
    }()

    var model: Consensus?
//    var model: Float = 0.5 {
//        didSet {
//            setNeedsLayout()
//        }
//    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func setupSubViews() {

        [topTagView, headOpinionLabel, tailOpinionLabel, consensusInfoLabel, linkButton].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        linkButton.tapPublisher.sink { [weak self] _ in
            guard let model = self?.model else { return }
            self?.goReport(link: "http://consensus.hankyung.com/apps.analysis/analysis.list?search_text=\(model.stockCode)&business_code=")

        }.store(in: &subscriptions)
    }

    private func addConstraints() {

        topTagView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        topTagView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        topTagView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        headOpinionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        headOpinionLabel.topAnchor.constraint(equalTo: topTagView.bottomAnchor, constant: 12).isActive = true

        consensusInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        consensusInfoLabel.topAnchor.constraint(equalTo: headOpinionLabel.bottomAnchor, constant: 10).isActive = true

        linkButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        linkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        linkButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        linkButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

    }

    func configure(_ model: Consensus) {
        self.model = model
        self.topTagView.textColor = model.opinion.colorForType()
        self.backgroundColor = model.opinion.colorForType()
        updateHeadTitleAttributed(model: model)
        let date = DateFormatter().convertBy(format: "MM-dd", dateString: model.createdAt, oldFormat: "yyyy-MM-dd'T'HH:mm:ss")
        self.consensusInfoLabel.text = "\(model.opinionCompany) | \(date)"

    }

    private func updateHeadTitleAttributed(model: Consensus) {
        let headString = model.opinion.stockTypeHeadString()
        let attributeString = NSMutableAttributedString.init(string: headString.0)
        attributeString.addAttributes([
            .font: UIFont.systemFont(ofSize: 20, weight: .heavy),
            .foregroundColor: UIColor.white

        ], range: NSRange(location: 0, length: headString.0.count))

        if let attachImage = model.opinion.stockTypeIconImage(.white) {
            let attachment = NSTextAttachment(image: attachImage)

            let attatchString = NSAttributedString.init(attachment: attachment)
            attributeString.append(attatchString)
        }
        attributeString.append(NSAttributedString(string: "\n"))

        let tail = NSMutableAttributedString.init(string: headString.1)
        tail.addAttributes([
            .font: UIFont.systemFont(ofSize: 20, weight: .medium)
        ], range: NSRange(location: 0, length: headString.1.count))

        attributeString.append(tail)
        headOpinionLabel.attributedText = attributeString

    }

    func goReport(link: String) {

        let presentedViewController = UIApplication.topViewController()
        let reportVIew = UIStoryboard(name: "NewsFeed", bundle: nil).instantiateViewController(identifier: NewsDetailsViewController.reuseIdentifier) as NewsDetailsViewController
        reportVIew.newsURL = link
        reportVIew.modalPresentationStyle = .formSheet
        presentedViewController?.present(reportVIew, animated: true, completion: nil)

    }
}
