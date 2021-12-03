//
//  InterestedCompanyCell.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/02.
//

import UIKit

class InterestedCompanyCell: UITableViewCell {

    struct UI {
        static let companyImageHeight: CGFloat = 28
    }

    lazy var companyImageView: UIImageView  = {
        let companyImage: UIImageView = UIImageView()
        companyImage.layer.cornerRadius = UI.companyImageHeight / 2
        companyImage.clipsToBounds = true
        companyImage.backgroundColor = .white
        companyImage.contentMode = .scaleAspectFill
        return companyImage
    }()

    lazy var companyLabel: UILabel = {
        let company = UILabel()
        company.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        company.textColor = AppColor.darkgray62.color
        company.text = "피엔케이피부임상연구센타"
        return company
    }()

    lazy var likeButton: UIButton = {
        let like = UIButton()
        like.setImage(UIImage(named: "icon_home_like"), for: .normal)
        return like
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
        setupConstraints()
    }

    func setupUI() {
        contentView.backgroundColor = UIColor.init(named: "home_background")
        [companyImageView, companyLabel, likeButton].forEach { subview in
            contentView.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setupConstraints() {
        // companyImage
        companyImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        companyImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        companyImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true

        // companyLabel
        companyLabel.leadingAnchor.constraint(equalTo: companyImageView.trailingAnchor, constant: 10).isActive = true
        companyLabel.centerYAnchor.constraint(equalTo: companyImageView.centerYAnchor).isActive
            = true
        companyLabel.trailingAnchor.constraint(greaterThanOrEqualTo: likeButton.leadingAnchor, constant: -30).isActive = true

        // likeButton
        likeButton.centerYAnchor.constraint(equalTo: companyImageView.centerYAnchor).isActive
            = true
        likeButton.widthAnchor.constraint(equalToConstant: 16).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
    }

    func configure(model: HomeInterestedCompany) {
        companyLabel.text = model.company?.shortName
        companyImageView.kf.setImage(with: URL(string: model.company?.imageUrl ?? ""))

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
