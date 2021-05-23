//
//  HomeDetailRelativeCell.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/10.
//

struct RelativeCompany {
    var relativeFields: [String] = []
    var relativeKeyword: [String] = []
    var companyImage: String = ""
    var company: String = ""
}

extension Collection {

    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UIStackView {
    func removeAllArrangeViews() {
        self.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
    }

}

import UIKit

class HomeDetailRelativeCell: UITableViewCell, ViewType {

    lazy var relativedImageView: UIImageView = {
       let image = UIImageView(image: UIImage(named: "bgGreen"))
        return image
    }()

    lazy var backContentView: UIView = {
        let content = UIView()
        content.backgroundColor = .white
        content.makeRounded(cornerRadius: 15)
        return content
    }()
    lazy var separatedLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.init(named: "home_background")
        return line
    }()

    lazy var relativeFieldStackView: UIStackView = {
        let field = UIStackView()
        field.spacing = 5
        field.alignment = .leading
        return field
    }()

    lazy var relativeKeywordStackView: UIStackView = {
        let keyword = UIStackView()
        keyword.spacing = 5
        keyword.alignment = .leading
        return keyword
    }()

    lazy var relativeFieldImageView: UIImageView = {
        let field = UIImageView()
        field.backgroundColor = UIColor.init(named: "home_background")
        field.makeCircle()
        return field
    }()

    lazy var relativeKeywordImageView: UIImageView = {
        let keyword = UIImageView()
        keyword.makeCircle()
        keyword.backgroundColor = UIColor.init(named: "home_background")
        return keyword
    }()

    lazy var fieldTitleLabel: UILabel = {
        let field = UILabel()
        field.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return field
    }()

    lazy var keywordTitleLabel: UILabel = {
        let keyword = UILabel()
        keyword.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return keyword
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(_ field: RelativeCompany, keyword: RelativeCompany) {

        relativeFieldStackView.removeAllArrangeViews()
        let generator = TagGenerator(field.relativeFields.count, textArray: field.relativeFields)
        for label in generator.generateTagLabels() {
            relativeFieldStackView.addArrangedSubview(label)
        }

        fieldTitleLabel.text = field.company

        relativeKeywordStackView.removeAllArrangeViews()
        let keywordGenerator = TagGenerator(keyword.relativeKeyword.count, textArray: keyword.relativeKeyword)
        for label in keywordGenerator.generateTagLabels() {
            relativeKeywordStackView.addArrangedSubview(label)
        }
        keywordTitleLabel.text = keyword.company
    }

    func setupUI() {
        contentView.backgroundColor = UIColor.init(named: "home_background")
        contentView.addSubview(backContentView)
        backContentView.translatesAutoresizingMaskIntoConstraints = false
        [relativedImageView, relativeFieldStackView, relativeFieldImageView, fieldTitleLabel, relativeKeywordStackView, relativeKeywordImageView, keywordTitleLabel, separatedLine].forEach {
            backContentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

    }

    func setupConstraint() {

        backContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        backContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        backContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        backContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        backContentView.heightAnchor.constraint(equalToConstant: 225).isActive = true

        relativedImageView.fittingView(backContentView)

        relativeFieldStackView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        relativeFieldStackView.leadingAnchor.constraint(equalTo: backContentView.leadingAnchor, constant: 16).isActive = true
       let fieldStackTrailing = relativeFieldStackView.trailingAnchor.constraint(greaterThanOrEqualTo: backContentView.trailingAnchor, constant: -16)
        fieldStackTrailing.priority = .defaultLow
        fieldStackTrailing.isActive = true
        relativeFieldStackView.topAnchor.constraint(equalTo: backContentView.topAnchor, constant: 30).isActive = true
        relativeFieldImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        relativeFieldImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        relativeFieldImageView.leadingAnchor.constraint(equalTo: relativeFieldStackView.leadingAnchor).isActive = true
        relativeFieldImageView.topAnchor.constraint(equalTo: relativeFieldStackView.bottomAnchor, constant: 10).isActive = true
        fieldTitleLabel.leadingAnchor.constraint(equalTo: relativeFieldImageView.trailingAnchor, constant: 10).isActive = true
        fieldTitleLabel.trailingAnchor.constraint(equalTo: backContentView.trailingAnchor, constant: -16).isActive = true
        fieldTitleLabel.centerYAnchor.constraint(equalTo: relativeFieldImageView.centerYAnchor).isActive = true

        separatedLine.leadingAnchor.constraint(equalTo: backContentView.leadingAnchor, constant: 16).isActive = true

        separatedLine.trailingAnchor.constraint(equalTo: backContentView.trailingAnchor, constant: -16).isActive = true
        separatedLine.topAnchor.constraint(equalTo: relativeFieldImageView.bottomAnchor, constant: 20).isActive = true
        separatedLine.heightAnchor.constraint(equalToConstant: 1).isActive = true

        relativeKeywordStackView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        relativeKeywordStackView.leadingAnchor.constraint(equalTo: backContentView.leadingAnchor, constant: 16).isActive = true
        let keywordStackTrailing = relativeKeywordStackView.trailingAnchor.constraint(greaterThanOrEqualTo: backContentView.trailingAnchor, constant: -16)
        keywordStackTrailing.priority = .defaultLow
        keywordStackTrailing.isActive = true
        relativeKeywordStackView.topAnchor.constraint(equalTo: separatedLine.bottomAnchor, constant: 20).isActive = true
        relativeKeywordImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        relativeKeywordImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        relativeKeywordImageView.leadingAnchor.constraint(equalTo: relativeKeywordStackView.leadingAnchor).isActive = true
        relativeKeywordImageView.topAnchor.constraint(equalTo: relativeKeywordStackView.bottomAnchor, constant: 10).isActive = true
        keywordTitleLabel.leadingAnchor.constraint(equalTo: relativeKeywordImageView.trailingAnchor, constant: 10).isActive = true
        keywordTitleLabel.trailingAnchor.constraint(equalTo: backContentView.trailingAnchor, constant: -16).isActive = true
        keywordTitleLabel.centerYAnchor.constraint(equalTo: relativeKeywordImageView.centerYAnchor).isActive = true

    }

}
