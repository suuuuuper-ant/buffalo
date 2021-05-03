//
//  HomeTitleHeaderView.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/19.
//

import UIKit

class HomeGreetingHeaderView: UITableViewHeaderFooterView {
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "04.14"
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    let searchButton: UIButton = {
        let search = UIButton()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.setImage(UIImage(named: "icon_home_search"), for: .normal)

        return search
    }()

    let greetingLabel: UILabel = {
        let greeting = UILabel()
        greeting.numberOfLines = 0
        greeting.text = "가은가가은가은간ㅇㅁㄴㅇㅁㄴㅁ나ㅣㅇㄴ미ㅏ언미ㅏ언ㅁ언미아넘인머인머ㅏㅣ엄ㅇ"
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
        return randomPick
    }()

    var slideOpenView: SlideOpenView = {
        let slide = SlideOpenView(frame: CGRect(x: 0, y: 0, width: 40, height: 0))

        slide.thumbnailViewStartingDistance = 6
        slide.sliderCornerRadius = 80 / 2
        return slide
    }()
    let backContentView  = UIView()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }

    private func setupUI() {
        // background setting
        contentView.addSubview(backContentView)
        backContentView.translatesAutoresizingMaskIntoConstraints = false
        slideOpenView.translatesAutoresizingMaskIntoConstraints = false
        backContentView.addSubview(slideOpenView)
        backContentView.fittingView(self.contentView)
        backContentView.setContentHuggingPriority(.defaultLow, for: .vertical)

        backContentView.addSubview(greetingLabel)
        backContentView.addSubview(searchButton)
        searchButton.trailingAnchor.constraint(equalTo: backContentView.trailingAnchor, constant: -18).isActive = true
        searchButton.topAnchor.constraint(equalTo: backContentView.topAnchor, constant: 18).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 24).isActive = true

        greetingLabel.leadingAnchor.constraint(equalTo: backContentView.leadingAnchor, constant: 25).isActive = true
        greetingLabel.trailingAnchor.constraint(equalTo: backContentView.trailingAnchor, constant: -81).isActive = true
        greetingLabel.topAnchor.constraint(equalTo: backContentView.topAnchor, constant: 120).isActive = true
        greetingLabel.bottomAnchor.constraint(equalTo: slideOpenView.topAnchor, constant: -50).isActive = true

        slideOpenView.leadingAnchor.constraint(equalTo: backContentView.leadingAnchor, constant: 16).isActive = true
        slideOpenView.trailingAnchor.constraint(equalTo: backContentView.trailingAnchor, constant: -16).isActive = true
        slideOpenView.heightAnchor.constraint(equalToConstant: 132).isActive = true
        slideOpenView.bottomAnchor.constraint(equalTo: backContentView.bottomAnchor, constant: -50).isActive = true

    }

    func configure(nickname: String, greeting: String) {
        let thinString = "\(nickname)님,\n"
        let totalString = "\(thinString)\(greeting)"
        let attributedString = NSMutableAttributedString(string: totalString, attributes: [
          .font: UIFont(name: "AppleSDGothicNeo-Bold", size: 30.0)!,
          .foregroundColor: UIColor(white: 62.0 / 255.0, alpha: 1.0),
          .kern: -0.4
        ])
        if let range = totalString.range(of: thinString) {
            attributedString.addAttribute(.font, value: UIFont(name: "AppleSDGothicNeo-Medium", size: 24.0)!, range: NSRange(range, in: totalString))
        }

        self.greetingLabel.attributedText = attributedString

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
