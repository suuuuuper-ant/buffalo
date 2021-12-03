//
//  SingupInterestingCell.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/15.
//

import UIKit

struct Interesting {
    var image = ""
    var interesting = ""
    var tiker = ""
}

class SingupInterestingCell: UICollectionViewCell, ViewType {

    lazy var interstingImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.makeRounded(cornerRadius: contentView.bounds.width / 2)
        image.backgroundColor = AppColor.homeBackground.color
        return image
    }()

    lazy var selectedImageView: UIImageView = {
        let image = UIImageView()
        image.makeRounded(cornerRadius: contentView.bounds.width / 2)
        image.backgroundColor = AppColor.mainColor.color.withAlphaComponent(0.9)

        image.addSubview(selectedHeartImageView)
        selectedHeartImageView.translatesAutoresizingMaskIntoConstraints = false
        selectedHeartImageView.centerYAnchor.constraint(equalTo: image.centerYAnchor).isActive = true
        selectedHeartImageView.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive = true
        selectedHeartImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        selectedHeartImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        return image
    }()

    lazy var selectedHeartImageView: UIImageView = {
       let heart = UIImageView()
        heart.image = UIImage(named: "icon_heart")
        return heart
    }()

    lazy var interestingLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    var selectedImageWidthConstraints: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        [interstingImageView, interestingLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        interstingImageView.addSubview(selectedImageView)
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false

    }

    func setupConstraint() {

        interstingImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        interstingImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        interstingImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        interstingImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true

        selectedImageView.centerXAnchor.constraint(equalTo: interstingImageView.centerXAnchor).isActive = true

        selectedImageView.centerYAnchor.constraint(equalTo: interstingImageView.centerYAnchor).isActive = true

        selectedImageView.heightAnchor.constraint(equalTo: interstingImageView.heightAnchor).isActive = true
        selectedImageView.widthAnchor.constraint(equalTo: interstingImageView.widthAnchor).isActive = true

        interestingLabel.topAnchor.constraint(equalTo: interstingImageView.bottomAnchor, constant: 8).isActive = true
        interestingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        interestingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        interestingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

    }

    func configure(_ model: Interesting, isSelected: Bool) {
        if isSelected {
            selectCell()
        } else {
            deselectCell()
        }
        if let url = URL(string: model.image) {
            self.interstingImageView.kf.setImage(with: url, placeholder: UIImage(named: "icon_heart"))
        }
        self.interestingLabel.text = model.interesting
    }

    func selectCell() {
        selectedImageView.isHidden = false
        selectedHeartImageView.isHidden = false
    }

    func deselectCell() {
        selectedImageView.isHidden = true
        selectedHeartImageView.isHidden = true
    }
}
