//
//  GreetingCell.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/29.
//

import UIKit

class GreetingCell: UITableViewCell {

    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "04.14"
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    let greetingLabel: UILabel = {
        let greeting = UILabel()
        greeting.numberOfLines = 0
        greeting.text = "가니님,\n오늘도 함꼐 디긴해요!"
        greeting.font = UIFont.boldSystemFont(ofSize: 30)
        greeting.translatesAutoresizingMaskIntoConstraints = false
        return greeting
    }()

    let radomPickButton: UIButton = {
       let randomPick = UIButton()
        randomPick.setTitle("새로운 기업을 디긴해 볼까요?", for: .normal)
        randomPick.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        randomPick.layer.cornerRadius = 10
        randomPick.clipsToBounds = true
        randomPick.translatesAutoresizingMaskIntoConstraints = false
        randomPick.backgroundColor = .lightGray
        return randomPick
    }()

    var slideOpenView: SlideOpenView = {
        let slide = SlideOpenView(frame: CGRect(x: 0, y: 0, width: 40, height: 0))

        slide.thumbnailViewStartingDistance = 6
        slide.sliderCornerRadius = 80 / 2
        return slide
    }()

    let backContentView  = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // background setting
        backgroundColor = .white

        addSubview(backContentView)
        backContentView.translatesAutoresizingMaskIntoConstraints = false
        backContentView.fittingView(self.contentView)
        backContentView.heightAnchor.constraint(equalToConstant: 354).isActive = true

        backContentView.addSubview(dateLabel)
        dateLabel.leadingAnchor.constraint(equalTo: backContentView.leadingAnchor, constant: 25).isActive = true
        dateLabel.topAnchor.constraint(equalTo: backContentView.topAnchor, constant: 10).isActive = true

        backContentView.addSubview(greetingLabel)
        greetingLabel.leadingAnchor.constraint(equalTo: backContentView.leadingAnchor, constant: 25).isActive = true
        greetingLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 50).isActive = true

        backContentView.addSubview(slideOpenView)
        slideOpenView.translatesAutoresizingMaskIntoConstraints = false

        slideOpenView.leadingAnchor.constraint(equalTo: backContentView.leadingAnchor, constant: 16).isActive = true
        slideOpenView.trailingAnchor.constraint(equalTo: backContentView.trailingAnchor, constant: -16).isActive = true
        slideOpenView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        slideOpenView.bottomAnchor.constraint(equalTo: backContentView.bottomAnchor, constant: -20).isActive = true

    }

    fileprivate func addGradientMaskToView(view: UIView, transparency: CGFloat = 0.5, gradientWidth: CGFloat = 40.0) {
        let gradientMask = CAGradientLayer()
        gradientMask.frame = view.bounds
        let gradientSize = gradientWidth/view.frame.size.width
        let gradientColor = UIColor(white: 1, alpha: transparency)
        let startLocations = [0, gradientSize/2, gradientSize]
        let endLocations = [(1 - gradientSize), (1 - gradientSize/2), 1]
        let animation = CABasicAnimation(keyPath: "locations")

        gradientMask.colors = [gradientColor.cgColor, UIColor.white.cgColor, gradientColor.cgColor]
        gradientMask.locations = startLocations as [NSNumber]?
        gradientMask.startPoint = CGPoint(x: 0 - (gradientSize * 2), y: 0.5)
        gradientMask.endPoint = CGPoint(x: 1 + gradientSize, y: 0.5)

        view.layer.mask = gradientMask

        animation.fromValue = startLocations
        animation.toValue = endLocations
        animation.repeatCount = HUGE
        animation.duration = 3

        gradientMask.add(animation, forKey: nil)
    }

}
